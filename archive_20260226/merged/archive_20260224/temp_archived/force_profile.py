#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Run a time→force profile (piecewise constant) using DoPE.dll.

Goal
- Let you define a force setpoint schedule like:
  0–5s:  5 N
  5–10s: 10 N
  10–15s: 5 N

Doc basis (DoPE.pdf V2.88)
- CTRL_LOAD (load/force control) is a control mode (CTRL_xxx).
- DoPEPos(Sync): "Move cross-head in the specified control mode and speed to the given destination".
  In load control (CTRL_LOAD), Speed is in N/s and Destination is in N.

Notes
- Uses a single lock around all DLL calls (DLL may be not thread-safe).
- Uses a large raw buffer for DoPEGetData to avoid struct-size/packing crashes.
- Designed as a standalone script first; integrate into UI after validation.
"""

from __future__ import annotations

import argparse
import ctypes
import csv
import json
import os
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path


DLL_PATH = Path(__file__).resolve().parents[1] / "drivers" / "DoPE.dll"


# Prefer 32-bit Python for the 32-bit DoPE.dll.
if sys.maxsize > 2**32:
    venv32_python = os.path.join(os.path.dirname(os.path.dirname(__file__)), ".venv32", "Scripts", "python.exe")
    if os.path.exists(venv32_python):
        subprocess.call([venv32_python, __file__] + sys.argv[1:])
        raise SystemExit(0)


class DoPEData(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Time", ctypes.c_double),
        ("SampleTime", ctypes.c_double),
        ("Position", ctypes.c_double),
        ("Force", ctypes.c_double),
        ("Extension", ctypes.c_double),
        ("SensorD", ctypes.c_double),
        ("Sensor4", ctypes.c_double),
        ("Sensor5", ctypes.c_double),
        ("Sensor6", ctypes.c_double),
        ("Sensor7", ctypes.c_double),
        ("Sensor8", ctypes.c_double),
        ("Sensor9", ctypes.c_double),
        ("Sensor10", ctypes.c_double),
        ("Status", ctypes.c_long),
        ("KeyActive", ctypes.c_uint16),
        ("KeyNew", ctypes.c_uint16),
        ("KeyGone", ctypes.c_uint16),
        ("Reserved", ctypes.c_byte * 64),
    ]


@dataclass(frozen=True)
class Segment:
    t_start: float
    t_end: float
    force_n: float


def parse_profile(profile: str) -> list[Segment]:
    """Parse profile from JSON string or JSON file.

    Accepted formats:
    - JSON string: [[0,5,5],[5,10,10],[10,15,5]]
    - JSON file path with that same content
    """
    data = None
    p = Path(profile)
    if p.exists() and p.is_file():
        data = json.loads(p.read_text(encoding="utf-8"))
    else:
        data = json.loads(profile)

    segments: list[Segment] = []
    for item in data:
        if not (isinstance(item, (list, tuple)) and len(item) == 3):
            raise ValueError(f"Invalid segment: {item!r}. Expected [t_start, t_end, force_n].")
        t0, t1, f = float(item[0]), float(item[1]), float(item[2])
        if t1 <= t0:
            raise ValueError(f"Invalid segment time range: {item!r} (t_end must be > t_start)")
        segments.append(Segment(t_start=t0, t_end=t1, force_n=f))

    segments.sort(key=lambda s: s.t_start)
    return segments


class DoPE:
    CTRL_POS = 0
    CTRL_LOAD = 1

    # DoPESetTime mode (numeric values not present in extracted manual; default 0 used by convention)
    SETTIME_MODE_IMMEDIATE = 0

    def __init__(self, dll_path: Path):
        if not dll_path.exists():
            raise FileNotFoundError(f"DoPE.dll not found: {dll_path}")
        self.dll = ctypes.WinDLL(str(dll_path))
        self.hdl = ctypes.c_ulong(0)
        self._lock = ctypes.RLock() if hasattr(ctypes, "RLock") else None  # never used; kept for type clarity

        # Python lock (do not use ctypes RLock)
        import threading

        self._py_lock = threading.RLock()
        self._bind()

    def _bind(self) -> None:
        self.dll.DoPEOpenLink.argtypes = [
            ctypes.c_ulong,
            ctypes.c_ulong,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_ulong),
        ]
        self.dll.DoPEOpenLink.restype = ctypes.c_ulong

        if hasattr(self.dll, "DoPECloseLink"):
            self.dll.DoPECloseLink.argtypes = [ctypes.c_ulong]
            self.dll.DoPECloseLink.restype = ctypes.c_ulong

        if hasattr(self.dll, "DoPESetNotification"):
            self.dll.DoPESetNotification.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ulong,
                ctypes.c_void_p,
                ctypes.c_void_p,
                ctypes.c_uint,
            ]
            self.dll.DoPESetNotification.restype = ctypes.c_ulong

        self.dll.DoPESelSetup.argtypes = [
            ctypes.c_ulong,
            ctypes.c_ushort,
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_ushort),
            ctypes.POINTER(ctypes.c_ushort),
        ]
        self.dll.DoPESelSetup.restype = ctypes.c_ulong

        if hasattr(self.dll, "DoPEOn"):
            self.dll.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
            self.dll.DoPEOn.restype = ctypes.c_ulong

        if hasattr(self.dll, "DoPECtrlTestValues"):
            self.dll.DoPECtrlTestValues.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
            self.dll.DoPECtrlTestValues.restype = ctypes.c_ulong

        if hasattr(self.dll, "DoPETransmitData"):
            # DoPE.pdf V2.88: DoPETransmitData(DoPE_HANDLE, unsigned short Enable, double Time, WORD *lpusTAN)
            self.dll.DoPETransmitData.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_double,
                ctypes.POINTER(ctypes.c_ushort),
            ]
            self.dll.DoPETransmitData.restype = ctypes.c_ulong

        # DoPESetTime: DoPESetTime(DoPE_HANDLE, WORD Mode, double Time, WORD *lpusTAN)
        if hasattr(self.dll, "DoPESetTime"):
            self.dll.DoPESetTime.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_double,
                ctypes.POINTER(ctypes.c_ushort),
            ]
            self.dll.DoPESetTime.restype = ctypes.c_ulong

        # GetData: bind as void* and decode from raw buffer
        self.dll.DoPEGetData.argtypes = [ctypes.c_ulong, ctypes.c_void_p]
        self.dll.DoPEGetData.restype = ctypes.c_ulong

        # DoPEPos: DoPEPos(DoPE_HANDLE, unsigned short MoveCtrl, double Speed, double Destination, WORD *lpusTAN)
        if hasattr(self.dll, "DoPEPos"):
            self.dll.DoPEPos.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_double,
                ctypes.c_double,
                ctypes.POINTER(ctypes.c_ushort),
            ]
            self.dll.DoPEPos.restype = ctypes.c_ulong

        # DoPEHalt: DoPEHalt(DoPE_HANDLE, unsigned short MoveCtrl, WORD *lpusTAN)
        if hasattr(self.dll, "DoPEHalt"):
            self.dll.DoPEHalt.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.POINTER(ctypes.c_ushort),
            ]
            self.dll.DoPEHalt.restype = ctypes.c_ulong

    def open(self, port: int, baud: int, api_version: int, setup_no: int) -> None:
        tan_first = ctypes.c_ushort(0)
        tan_last = ctypes.c_ushort(0)

        with self._py_lock:
            err = int(
                self.dll.DoPEOpenLink(
                    int(port),
                    int(baud),
                    10,
                    10,
                    10,
                    int(api_version),
                    None,
                    ctypes.byref(self.hdl),
                )
            )
        if err != 0x0000:
            raise RuntimeError(f"DoPEOpenLink failed: 0x{err:04x}")

        if hasattr(self.dll, "DoPESetNotification"):
            with self._py_lock:
                _ = int(self.dll.DoPESetNotification(self.hdl, 0xFFFFFFFF, None, None, 0))

        with self._py_lock:
            err = int(self.dll.DoPESelSetup(self.hdl, int(setup_no), None, ctypes.byref(tan_first), ctypes.byref(tan_last)))
        if err != 0x0000:
            raise RuntimeError(f"DoPESelSetup({setup_no}) failed: 0x{err:04x}")

        if hasattr(self.dll, "DoPEOn"):
            with self._py_lock:
                _ = int(self.dll.DoPEOn(self.hdl, None))

        if hasattr(self.dll, "DoPECtrlTestValues"):
            with self._py_lock:
                _ = int(self.dll.DoPECtrlTestValues(self.hdl, 0))

        if hasattr(self.dll, "DoPETransmitData"):
            with self._py_lock:
                err = int(self.dll.DoPETransmitData(self.hdl, 1, 0.0, None))
            if err != 0x0000:
                raise RuntimeError(f"DoPETransmitData failed: 0x{err:04x}")

    def close(self) -> None:
        try:
            if self.hdl and self.hdl.value and hasattr(self.dll, "DoPECloseLink"):
                with self._py_lock:
                    _ = int(self.dll.DoPECloseLink(self.hdl))
        finally:
            self.hdl = ctypes.c_ulong(0)

    def halt(self, movectrl: int = 0) -> None:
        if not (self.hdl and self.hdl.value):
            return
        if not hasattr(self.dll, "DoPEHalt"):
            return
        with self._py_lock:
            _ = int(self.dll.DoPEHalt(self.hdl, int(movectrl), None))

    def set_time(self, time_s: float, mode: int | None = None) -> int:
        """Set the internal DoPE time counter.

        Manual shows: DoPESetTime(DoPEHdl, Mode, Time, TAN)
        The extracted PDF text doesn't include numeric values for the Mode constants,
        so we default to 0 (IMMEDIATE) and allow overriding via CLI.
        """
        if not (self.hdl and self.hdl.value):
            return 0
        if not hasattr(self.dll, "DoPESetTime"):
            return 0
        if mode is None:
            mode = self.SETTIME_MODE_IMMEDIATE
        with self._py_lock:
            return int(self.dll.DoPESetTime(self.hdl, int(mode), float(time_s), None))

    def get_data(self) -> DoPEData | None:
        if not (self.hdl and self.hdl.value):
            return None
        buf = ctypes.create_string_buffer(1024)
        with self._py_lock:
            err = int(self.dll.DoPEGetData(self.hdl, ctypes.byref(buf)))
        if err != 0x0000:
            return None
        return DoPEData.from_buffer_copy(buf.raw[: ctypes.sizeof(DoPEData)])

    def set_force_target(self, force_n: float, load_rate_n_s: float) -> int:
        """Set force setpoint in load control.

        In CTRL_LOAD mode:
        - Speed is load rate (N/s)
        - Destination is force (N)
        """
        if not hasattr(self.dll, "DoPEPos"):
            raise RuntimeError("DoPEPos not available in this DLL")
        with self._py_lock:
            return int(self.dll.DoPEPos(self.hdl, self.CTRL_LOAD, float(load_rate_n_s), float(force_n), None))


def run_profile(
    dope: DoPE,
    segments: list[Segment],
    load_rate_n_s: float,
    tol_n: float,
    settle_timeout_s: float,
    sample_hz: float,
    reassert_every_s: float,
    csv_writer: csv.writer | None,
) -> None:
    if not segments:
        raise ValueError("Profile has no segments")

    t0 = time.perf_counter()

    def now_s() -> float:
        return time.perf_counter() - t0

    last_reassert_ts = -1e9
    current_segment_idx = -1

    print("\n[profile] Starting... Ctrl+C to stop")
    print("[profile] Segments:")
    for s in segments:
        print(f"  {s.t_start:g}–{s.t_end:g}s: {s.force_n:g} N")

    dt = 1.0 / max(1.0, float(sample_hz))

    try:
        while True:
            t = now_s()
            if t > segments[-1].t_end:
                break

            # Find current segment
            seg_i = None
            for i, s in enumerate(segments):
                if s.t_start <= t < s.t_end:
                    seg_i = i
                    break
            if seg_i is None:
                time.sleep(min(dt, 0.05))
                continue

            # On segment change, command new setpoint
            if seg_i != current_segment_idx:
                current_segment_idx = seg_i
                seg = segments[seg_i]
                print(f"\n[profile] t={t:.2f}s -> setpoint {seg.force_n:g} N (rate {load_rate_n_s:g} N/s)")
                err = dope.set_force_target(seg.force_n, load_rate_n_s)
                print(f"[profile] DoPEPos(CTRL_LOAD) => 0x{err:04x}")

                # Optional: wait until we are near the setpoint (best-effort)
                if settle_timeout_s > 0:
                    settle_deadline = time.perf_counter() + float(settle_timeout_s)
                    while time.perf_counter() < settle_deadline:
                        d = dope.get_data()
                        if d is not None:
                            f = float(d.Force)
                            if abs(f - float(seg.force_n)) <= float(tol_n):
                                break
                        time.sleep(min(dt, 0.05))

                last_reassert_ts = t

            # Read and print current force
            d = dope.get_data()
            if d is not None:
                f = float(d.Force)
                pos = float(d.Position)
                print(f"t={t:6.2f}s  Force={f:9.3f} N  Pos={pos:9.4f}")

                if csv_writer is not None:
                    # wall_time_s: our perf_counter-based time
                    # dope_time_s: time reported by DoPE measuring record (if mapped correctly)
                    csv_writer.writerow(
                        [
                            f"{t:.6f}",
                            f"{float(getattr(d, 'Time', 0.0)):.6f}",
                            f"{pos:.6f}",
                            f"{f:.6f}",
                            f"{segments[current_segment_idx].force_n:.6f}",
                            str(current_segment_idx),
                        ]
                    )

            # Re-assert the same setpoint occasionally (helps compensate relaxation)
            if reassert_every_s > 0 and (t - last_reassert_ts) >= reassert_every_s:
                seg = segments[current_segment_idx]
                err = dope.set_force_target(seg.force_n, load_rate_n_s)
                print(f"[profile] reassert setpoint {seg.force_n:g} N => 0x{err:04x}")
                last_reassert_ts = t

            time.sleep(min(dt, 0.05))

    except KeyboardInterrupt:
        print("\n[profile] Interrupted")
    finally:
        print("[profile] Halting...")
        try:
            dope.halt(DoPE.CTRL_LOAD)
        except Exception:
            pass


def main() -> int:
    ap = argparse.ArgumentParser(description="Run a force (load) profile with DoPE.dll")
    ap.add_argument("--port", type=int, default=7, help="COM port number (e.g. 7 for COM7)")
    ap.add_argument("--baud", type=int, default=9600)
    ap.add_argument("--api", type=lambda s: int(s, 0), default=0x0289, help="API version, e.g. 0x0289")
    ap.add_argument("--setup", type=int, default=1, help="Setup number")

    ap.add_argument(
        "--profile",
        required=True,
        help='JSON string or JSON file path. Example: "[[0,5,5],[5,10,10],[10,15,5]]"',
    )

    ap.add_argument("--rate", type=float, default=20.0, help="Load rate (N/s) used in DoPEPos(CTRL_LOAD)")
    ap.add_argument("--tol", type=float, default=0.5, help="Tolerance (N) to consider setpoint reached")
    ap.add_argument("--settle-timeout", type=float, default=2.0, help="Max seconds to wait for setpoint each step (0 to disable)")
    ap.add_argument("--sample-hz", type=float, default=5.0, help="Sampling print rate")
    ap.add_argument("--reassert-every", type=float, default=0.0, help="Re-issue setpoint every N seconds (0 to disable)")

    ap.add_argument("--csv", type=str, default="", help="Optional CSV output path (e.g. temp\\profile_log.csv)")
    ap.add_argument(
        "--reset-dll-time",
        action="store_true",
        help="Call DoPESetTime to reset DoPE time counter to 0 at start (best-effort)",
    )
    ap.add_argument(
        "--settime-mode",
        type=int,
        default=0,
        help="Mode passed to DoPESetTime (manual names exist, numeric values not in extracted text; default 0)",
    )

    args = ap.parse_args()

    segments = parse_profile(args.profile)

    dope = DoPE(DLL_PATH)
    try:
        print(f"[init] Loading {DLL_PATH}")
        dope.open(port=args.port, baud=args.baud, api_version=args.api, setup_no=args.setup)
        print("[init] Connected")

        if args.reset_dll_time:
            err = dope.set_time(0.0, mode=int(args.settime_mode))
            if err != 0x0000:
                print(f"[init] DoPESetTime failed: 0x{err:04x}")

        csv_writer = None
        csv_file = None
        try:
            if args.csv:
                csv_path = Path(args.csv)
                csv_path.parent.mkdir(parents=True, exist_ok=True)
                csv_file = csv_path.open("w", newline="", encoding="utf-8")
                csv_writer = csv.writer(csv_file)
                csv_writer.writerow(
                    [
                        "wall_time_s",
                        "dope_time_s",
                        "position",
                        "force_n",
                        "force_setpoint_n",
                        "segment_idx",
                    ]
                )

            run_profile(
                dope,
                segments,
                load_rate_n_s=float(args.rate),
                tol_n=float(args.tol),
                settle_timeout_s=float(args.settle_timeout),
                sample_hz=float(args.sample_hz),
                reassert_every_s=float(args.reassert_every),
                csv_writer=csv_writer,
            )
        finally:
            if csv_file is not None:
                try:
                    csv_file.flush()
                except Exception:
                    pass
                try:
                    csv_file.close()
                except Exception:
                    pass
    finally:
        try:
            dope.close()
        except Exception:
            pass

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
