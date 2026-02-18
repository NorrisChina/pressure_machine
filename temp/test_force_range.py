#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Test currently connected force sensor range via DoPE.pdf V2.88.

Key API from DoPE.pdf:
- DoPERdSensorInfo(DoPEHdl, SensorNo, DoPESumSenInfo* Info)
  returns nominal value + upper/lower limits + sensor state.

This script:
1) Opens the DoPE link (legacy DoPEOpenLink, like dope_ui_new.py).
2) Optionally selects a setup (DoPESelSetup).
3) Reads summary info for common sensors (force sensors 1 and 4 by default).
4) Prints a best-effort guess for current force range (100N / 1kN / 10kN).

Safety:
- Switching setup may re-initialize the controller. It should not move axes,
  but keep the machine safe and unloaded when testing.

Run (recommended 32-bit venv):
- .venv32\Scripts\python.exe .\temp\test_force_range.py
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

import ctypes


DLL_PATH = Path(__file__).resolve().parents[1] / "drivers" / "DoPE.dll"


def _prefer_32bit_python() -> None:
    if sys.maxsize <= 2**32:
        return
    venv32_python = Path(__file__).resolve().parents[1] / ".venv32" / "Scripts" / "python.exe"
    if venv32_python.exists():
        subprocess.call([str(venv32_python), str(Path(__file__).resolve())] + sys.argv[1:])
        raise SystemExit(0)


class DoPESumSenInfo(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Connector", ctypes.c_ushort),
        ("NominalValue", ctypes.c_double),
        ("Unit", ctypes.c_ushort),
        ("Offset", ctypes.c_double),
        ("UpperLimit", ctypes.c_double),
        ("LowerLimit", ctypes.c_double),
        ("SensorState", ctypes.c_ushort),
        ("McType", ctypes.c_ushort),
        ("UpperSoftLimit", ctypes.c_double),
        ("LowerSoftLimit", ctypes.c_double),
        ("SoftLimitReaction", ctypes.c_ushort),
        ("BasicTare", ctypes.c_double),
    ]


@dataclass
class SensorSummary:
    sensor_no: int
    err: int
    info: DoPESumSenInfo | None


def _bind(dll: ctypes.WinDLL, name: str, argtypes: list, restype=ctypes.c_ulong):
    fn = getattr(dll, name, None)
    if fn is None:
        raise AttributeError(f"DLL missing export: {name}")
    fn.argtypes = argtypes
    fn.restype = restype
    return fn


def _guess_force_range_from_upper(upper: float) -> str:
    """Best-effort guess.

    Assumes the force channel is reported in N most of the time.
    If your unit is kN, upper might be 10 instead of 10000.
    """
    u = abs(float(upper))
    if u == 0:
        return "unknown"

    # Interpret as N
    if 50 <= u <= 250:
        return "~100N"
    if 500 <= u <= 2500:
        return "~1kN"
    if 5000 <= u <= 25000:
        return "~10kN"

    # Interpret as kN (upper like 0.1 / 1 / 10)
    if 0.05 <= u <= 0.25:
        return "~100N (0.1kN)"
    if 0.5 <= u <= 2.5:
        return "~1kN"
    if 5.0 <= u <= 25.0:
        return "~10kN"

    return "unknown"


def _print_sensor(summary: SensorSummary) -> None:
    if summary.err != 0x0000 or summary.info is None:
        print(f"Sensor {summary.sensor_no:2d}: err=0x{summary.err:04x}")
        return

    i = summary.info
    guess = _guess_force_range_from_upper(i.UpperLimit)
    print(
        "Sensor {no:2d}: connector={conn:>3d}, unit={unit:>3d}, nominal={nom:>10.4g}, "
        "upper={upr:>10.4g}, lower={lwr:>10.4g}, state={state:>3d}, mctype={mct:>3d}, guess={guess}".format(
            no=summary.sensor_no,
            conn=int(i.Connector),
            unit=int(i.Unit),
            nom=float(i.NominalValue),
            upr=float(i.UpperLimit),
            lwr=float(i.LowerLimit),
            state=int(i.SensorState),
            mct=int(i.McType),
            guess=guess,
        )
    )


def main() -> int:
    _prefer_32bit_python()

    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, default=7, help="COM port number for DoPEOpenLink (e.g. 7 for COM7)")
    ap.add_argument("--baud", type=int, default=9600, help="Baud rate")
    ap.add_argument("--api", type=lambda x: int(x, 0), default=0x0289, help="APIVersion (hex allowed, e.g. 0x0289)")
    ap.add_argument("--setup", type=int, default=None, help="If set, call DoPESelSetup with this setup number")
    ap.add_argument(
        "--switch-to-10kn",
        action="store_true",
        help="Convenience: switch to 10kN setup number (see --setup-10kn)",
    )
    ap.add_argument("--setup-10kn", type=int, default=1, help="Setup number that corresponds to 10kN")
    ap.add_argument(
        "--sensors",
        type=str,
        default="1,4",
        help="Comma list of SensorNo to query via DoPERdSensorInfo (default: 1,4)",
    )
    args = ap.parse_args()

    if not DLL_PATH.exists():
        print(f"ERROR: DLL not found: {DLL_PATH}")
        return 2

    dll = ctypes.WinDLL(str(DLL_PATH))

    DoPEOpenLink = _bind(
        dll,
        "DoPEOpenLink",
        [
            ctypes.c_ulong,
            ctypes.c_ulong,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_ulong),
        ],
    )
    DoPESetNotification = None
    if hasattr(dll, "DoPESetNotification"):
        DoPESetNotification = _bind(
            dll,
            "DoPESetNotification",
            [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint],
        )

    DoPESelSetup = None
    if hasattr(dll, "DoPESelSetup"):
        DoPESelSetup = _bind(
            dll,
            "DoPESelSetup",
            [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_void_p,
                ctypes.POINTER(ctypes.c_ushort),
                ctypes.POINTER(ctypes.c_ushort),
            ],
        )

    DoPERdSetupNumber = None
    if hasattr(dll, "DoPERdSetupNumber"):
        DoPERdSetupNumber = _bind(
            dll,
            "DoPERdSetupNumber",
            [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)],
        )

    DoPERdSensorInfo = _bind(
        dll,
        "DoPERdSensorInfo",
        [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(DoPESumSenInfo)],
    )

    DoPECloseLink = None
    if hasattr(dll, "DoPECloseLink"):
        DoPECloseLink = _bind(dll, "DoPECloseLink", [ctypes.c_ulong])

    hdl = ctypes.c_ulong(0)
    err = DoPEOpenLink(args.port, args.baud, 10, 10, 10, int(args.api), None, ctypes.byref(hdl))
    print(f"DoPEOpenLink(port={args.port}, baud={args.baud}, api=0x{int(args.api):04x}) -> 0x{err:04x}, hdl={hdl.value}")
    if err != 0x0000 or hdl.value == 0:
        return 1

    try:
        if DoPESetNotification is not None:
            err_n = DoPESetNotification(hdl, 0xFFFFFFFF, None, None, 0)
            print(f"DoPESetNotification -> 0x{err_n:04x}")

        if DoPERdSetupNumber is not None:
            setup_no = ctypes.c_ushort(0)
            tan = ctypes.c_ushort(0)
            err_s = DoPERdSetupNumber(hdl, ctypes.byref(setup_no), ctypes.byref(tan))
            print(f"DoPERdSetupNumber -> 0x{err_s:04x}, setup={setup_no.value}, tan={tan.value}")

        # Setup switching
        setup_to_use = args.setup
        if args.switch_to_10kn:
            setup_to_use = int(args.setup_10kn)

        if setup_to_use is not None:
            if DoPESelSetup is None:
                print("ERROR: DLL missing DoPESelSetup export; cannot switch setup")
                return 1
            tan_first = ctypes.c_ushort(0)
            tan_last = ctypes.c_ushort(0)
            err_sel = DoPESelSetup(hdl, int(setup_to_use), None, ctypes.byref(tan_first), ctypes.byref(tan_last))
            print(f"DoPESelSetup(setup={int(setup_to_use)}) -> 0x{err_sel:04x}, tan_first={tan_first.value}, tan_last={tan_last.value}")

            if DoPERdSetupNumber is not None:
                setup_no = ctypes.c_ushort(0)
                tan = ctypes.c_ushort(0)
                err_s = DoPERdSetupNumber(hdl, ctypes.byref(setup_no), ctypes.byref(tan))
                print(f"DoPERdSetupNumber(after) -> 0x{err_s:04x}, setup={setup_no.value}, tan={tan.value}")

        # Query sensors
        sensor_list = []
        for part in str(args.sensors).split(","):
            part = part.strip()
            if not part:
                continue
            sensor_list.append(int(part))

        print("\n=== DoPERdSensorInfo ===")
        results: list[SensorSummary] = []
        for s_no in sensor_list:
            info = DoPESumSenInfo()
            err_i = DoPERdSensorInfo(hdl, int(s_no), ctypes.byref(info))
            results.append(SensorSummary(sensor_no=int(s_no), err=int(err_i), info=info if err_i == 0x0000 else None))
            _print_sensor(results[-1])

        # Best-effort: pick a likely force range between sensor 1 and 4
        force_candidates = [r for r in results if r.sensor_no in (1, 4) and r.err == 0x0000 and r.info is not None]
        if force_candidates:
            # Prefer the one with non-zero upper limit
            force_candidates.sort(key=lambda r: abs(float(r.info.UpperLimit)) if r.info else 0.0, reverse=True)
            best = force_candidates[0]
            upper = float(best.info.UpperLimit)
            guess = _guess_force_range_from_upper(upper)
            print(f"\nDetected force sensor candidate: SensorNo={best.sensor_no}, UpperLimit={upper:.4g} -> {guess}")
            if best.sensor_no == 1:
                print("Force sensor looks like SENSOR_F (Sensor 1, usually 10kN).")
            elif best.sensor_no == 4:
                print("Force sensor looks like SENSOR_4 (Sensor 4, usually 100N/1kN depending on wiring).")
        else:
            print("\nNo force candidates (1/4) returned valid sensor info.")

        return 0
    finally:
        if DoPECloseLink is not None:
            try:
                err_c = DoPECloseLink(hdl)
                print(f"\nDoPECloseLink -> 0x{int(err_c):04x}")
            except Exception:
                pass


if __name__ == "__main__":
    raise SystemExit(main())
