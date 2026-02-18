#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Check currently connected sensor ranges via DoPE.dll.

This script uses DoPE.pdf V2.88 documented API:
- DoPERdSetupNumber
- DoPERdSensorInfo (returns DoPESumSenInfo with Upper/Lower limits)
- DoPESelSetup (optional)

Goal:
- Print a quick summary of all sensors (Connector, Unit code, NominalValue,
  Upper/Lower limit).
- Help you identify whether the load cell range corresponds to 100N / 1kN / 10kN.
- Optionally switch the active setup (e.g., your 10kN setup) and re-check.

Notes:
- DoPE.dll in this repo is 32-bit. Run with .venv32\\Scripts\\python.exe.
- Unit codes (UNIT_xxx) are not fully enumerated in the extracted PDF text,
  so this script prints the raw unit code.
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path
import ctypes


DLL_PATH = Path(__file__).resolve().parents[1] / "drivers" / "DoPE.dll"


def _ensure_32bit_python() -> None:
    if sys.maxsize <= 2**32:
        return
    repo_root = Path(__file__).resolve().parents[1]
    venv32_python = repo_root / ".venv32" / "Scripts" / "python.exe"
    if venv32_python.exists():
        subprocess.call([str(venv32_python), str(Path(__file__).resolve())] + sys.argv[1:])
        raise SystemExit(0)
    raise SystemExit("This script must run under 32-bit Python (.venv32).")


class DoPESumSenInfo(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Connector", ctypes.c_uint16),
        ("NominalValue", ctypes.c_double),
        ("Unit", ctypes.c_uint16),
        ("Offset", ctypes.c_double),
        ("UpperLimit", ctypes.c_double),
        ("LowerLimit", ctypes.c_double),
        ("SensorState", ctypes.c_uint16),
        ("McType", ctypes.c_uint16),
        ("UpperSoftLimit", ctypes.c_double),
        ("LowerSoftLimit", ctypes.c_double),
        ("SoftLimitReaction", ctypes.c_uint16),
        ("BasicTare", ctypes.c_double),
    ]


def _bind(dll: ctypes.WinDLL, name: str, argtypes: list, restype=ctypes.c_uint32):
    fn = getattr(dll, name, None)
    if fn is None:
        raise AttributeError(f"DoPE.dll does not export {name}")
    fn.argtypes = argtypes
    fn.restype = restype
    return fn


def _open_link(dll: ctypes.WinDLL, port: int, baud: int, api_version: int) -> ctypes.c_ulong:
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
        restype=ctypes.c_ulong,
    )

    hdl = ctypes.c_ulong(0)
    err = DoPEOpenLink(port, baud, 10, 10, 10, api_version, None, ctypes.byref(hdl))
    if err != 0:
        raise RuntimeError(f"DoPEOpenLink failed: 0x{int(err):04x}")
    if hdl.value == 0:
        raise RuntimeError("DoPEOpenLink returned hdl=0")
    return hdl


def _basic_init(dll: ctypes.WinDLL, hdl: ctypes.c_ulong, setup_no: int) -> None:
    """Mimic the working UI init sequence so sensor reads work reliably."""

    DoPESetNotification = _bind(
        dll,
        "DoPESetNotification",
        [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint],
        restype=ctypes.c_ulong,
    )
    DoPESetNotification(hdl, 0xFFFFFFFF, None, None, 0)

    err_sel = _select_setup(dll, hdl, setup_no)
    if err_sel != 0:
        raise RuntimeError(f"DoPESelSetup({setup_no}) failed: 0x{err_sel:04x}")

    # DoPEOn(DoPE_HANDLE, WORD* lpusTAN)
    DoPEOn = _bind(
        dll,
        "DoPEOn",
        [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)],
        restype=ctypes.c_ulong,
    )
    DoPEOn(hdl, None)

    DoPECtrlTestValues = _bind(
        dll,
        "DoPECtrlTestValues",
        [ctypes.c_ulong, ctypes.c_ushort],
        restype=ctypes.c_ulong,
    )
    DoPECtrlTestValues(hdl, 0)

    # DoPE.pdf V2.88: DoPETransmitData(DoPE_HANDLE, unsigned short Enable, double Time, WORD* lpusTAN)
    DoPETransmitData = _bind(
        dll,
        "DoPETransmitData",
        [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_double, ctypes.POINTER(ctypes.c_ushort)],
        restype=ctypes.c_ulong,
    )
    DoPETransmitData(hdl, 1, 0.0, None)


def _select_setup(dll: ctypes.WinDLL, hdl: ctypes.c_ulong, setup_no: int) -> int:
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
        restype=ctypes.c_ulong,
    )
    tan_first = ctypes.c_ushort(0)
    tan_last = ctypes.c_ushort(0)
    err = DoPESelSetup(hdl, int(setup_no), None, ctypes.byref(tan_first), ctypes.byref(tan_last))
    return int(err)


def _read_setup_number(dll: ctypes.WinDLL, hdl: ctypes.c_ulong) -> tuple[int, int]:
    DoPERdSetupNumber = _bind(
        dll,
        "DoPERdSetupNumber",
        [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)],
        restype=ctypes.c_ulong,
    )
    setup_no = ctypes.c_ushort(0)
    tan = ctypes.c_ushort(0)
    err = DoPERdSetupNumber(hdl, ctypes.byref(setup_no), ctypes.byref(tan))
    return int(err), int(setup_no.value)


def _read_sensor_info(dll: ctypes.WinDLL, hdl: ctypes.c_ulong, sensor_no: int) -> tuple[int, DoPESumSenInfo]:
    # IMPORTANT: We don't know the exact packing/size used by the DLL for DoPESumSenInfo.
    # Passing a too-small ctypes.Structure risks memory corruption (and can crash Python).
    # To stay safe, we pass a large raw buffer, then decode the known subset.
    DoPERdSensorInfo = _bind(
        dll,
        "DoPERdSensorInfo",
        [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p],
        restype=ctypes.c_ulong,
    )
    buf = ctypes.create_string_buffer(256)
    err = DoPERdSensorInfo(hdl, int(sensor_no), ctypes.byref(buf))
    info = DoPESumSenInfo.from_buffer_copy(buf.raw[: ctypes.sizeof(DoPESumSenInfo)])
    return int(err), info


def _close_link(dll: ctypes.WinDLL, hdl: ctypes.c_ulong) -> None:
    try:
        DoPECloseLink = _bind(dll, "DoPECloseLink", [ctypes.c_ulong], restype=ctypes.c_ulong)
        DoPECloseLink(hdl)
    except Exception:
        pass


def _guess_load_range_from_limits(upper_limit: float, unit_code: int) -> str:
    # Unit code mapping isn't available in the extracted PDF text, so we rely on
    # the absolute limit value (common cases: 100 / 1000 / 10000 in N).
    # If your unit is kN, the values could be 0.1 / 1 / 10; we still match.
    if upper_limit <= 0:
        return "unknown"

    candidates = [
        (100.0, "~100N"),
        (1000.0, "~1kN"),
        (10000.0, "~10kN"),
        (0.1, "~100N (if unit=kN)"),
        (1.0, "~1kN (if unit=kN)"),
        (10.0, "~10kN (if unit=kN)"),
    ]
    best = None
    best_rel = None
    for target, label in candidates:
        rel = abs(upper_limit - target) / max(target, 1e-9)
        if best_rel is None or rel < best_rel:
            best_rel = rel
            best = label
    if best_rel is not None and best_rel <= 0.15:
        return best
    return "unknown"


def _is_plausible_force_range(upper_limit: float) -> bool:
    # Heuristic: typical load ranges are in a human scale.
    if not (upper_limit == upper_limit):
        return False
    return 20.0 <= abs(float(upper_limit)) <= 50000.0


def main() -> int:
    _ensure_32bit_python()

    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, default=7, help="DoPEOpenLink port number (your UI uses 7)")
    ap.add_argument("--baud", type=int, default=9600)
    ap.add_argument("--api", type=lambda s: int(s, 0), default=0x0289, help="API version (default 0x0289)")
    ap.add_argument("--setup", type=int, default=1, help="Setup number to select during init (default 1)")
    ap.add_argument("--select-setup", type=int, default=None, help="Optional: call DoPESelSetup with this setup number")
    ap.add_argument("--max-sensors", type=int, default=16, help="How many SensorNo values to probe")
    ap.add_argument(
        "--show-errors",
        action="store_true",
        help="Print error codes for each sensor number even if not OK",
    )
    args = ap.parse_args()

    if not DLL_PATH.exists():
        print(f"ERROR: DoPE.dll not found at: {DLL_PATH}")
        return 2

    dll = ctypes.WinDLL(str(DLL_PATH))

    hdl = None
    try:
        hdl = _open_link(dll, port=args.port, baud=args.baud, api_version=args.api)
        print(f"OpenLink OK: hdl={hdl.value}")

        init_setup = int(args.select_setup) if args.select_setup is not None else int(args.setup)
        _basic_init(dll, hdl, init_setup)
        print(f"Init OK (SelSetup={init_setup}, TransmitData=ON)")

        err_sn, setup_no = _read_setup_number(dll, hdl)
        print(f"DoPERdSetupNumber -> 0x{err_sn:04x}, currentSetup={setup_no}")

        print("\nSensors (DoPERdSensorInfo):")
        print("SensorNo  Conn  Unit  NominalValue        UpperLimit          LowerLimit   McType  State  Guess")
        print("--------  ----  ----  ---------------     ---------------      -----------  ------  -----  -----")

        best_load_candidate = None  # (score, sensor_no, info)

        for sensor_no in range(int(args.max_sensors)):
            err, info = _read_sensor_info(dll, hdl, sensor_no)
            if err != 0:
                if args.show_errors:
                    print(f"{sensor_no:8d}  ----  ----  (DoPERdSensorInfo err=0x{err:04x})")
                continue

            # Skip obviously empty rows
            if (
                float(info.NominalValue) == 0.0
                and float(info.UpperLimit) == 0.0
                and float(info.LowerLimit) == 0.0
                and int(info.Connector) == 0
            ):
                continue

            guess = _guess_load_range_from_limits(float(info.UpperLimit), int(info.Unit))

            print(
                f"{sensor_no:8d}  {int(info.Connector):4d}  {int(info.Unit):4d}  "
                f"{float(info.NominalValue):15.6g}     {float(info.UpperLimit):15.6g}      "
                f"{float(info.LowerLimit):11.6g}  {int(info.McType):6d}  {int(info.SensorState):5d}  {guess}"
            )

            # Try to identify the load cell range candidate.
            upper = float(info.UpperLimit)
            score = abs(upper)
            if _is_plausible_force_range(upper):
                if best_load_candidate is None or score > best_load_candidate[0]:
                    best_load_candidate = (score, sensor_no, info)

        if best_load_candidate:
            _, sn, info = best_load_candidate
            guess = _guess_load_range_from_limits(float(info.UpperLimit), int(info.Unit))
            print(
                "\nLikely highest-range sensor (heuristic): "
                f"SensorNo={sn}, UpperLimit={float(info.UpperLimit):g}, Unit={int(info.Unit)} => {guess}"
            )
            print("(If this is not the load channel, tell me which SensorNo is 'Force' in your setup.)")
        else:
            print(
                "\nNo sensors returned data via DoPERdSensorInfo. "
                "Re-run with --show-errors to see error codes."
            )

        return 0

    except Exception as e:
        print(f"ERROR: {e}")
        return 1

    finally:
        if hdl is not None:
            _close_link(dll, hdl)


if __name__ == "__main__":
    raise SystemExit(main())
