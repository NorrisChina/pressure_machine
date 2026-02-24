#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Dump raw sensor definition bytes (DoPERdSensorDef) for troubleshooting.

This is a read-only helper to see whether the set-up sensor definition record
contains upper/lower range limits that could be patched and written back.

Example:
    .venv32\\Scripts\\python.exe .\\temp\\dump_sensor_def.py --port 7 --setup 1 --sensor 4
"""

from __future__ import annotations

import argparse
import ctypes
import struct
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path

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


def _bind(dll: ctypes.WinDLL, name: str, argtypes: list, restype=ctypes.c_ulong):
    fn = getattr(dll, name, None)
    if fn is None:
        raise AttributeError(f"DoPE.dll does not export {name}")
    fn.argtypes = argtypes
    fn.restype = restype
    return fn


def _find_double(blob: bytes, value: float) -> list[int]:
    pat = struct.pack("<d", float(value))
    out: list[int] = []
    start = 0
    while True:
        idx = blob.find(pat, start)
        if idx < 0:
            return out
        out.append(idx)
        start = idx + 1


def main() -> int:
    _ensure_32bit_python()

    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, required=True)
    ap.add_argument("--baud", type=int, default=9600)
    ap.add_argument("--api", type=lambda x: int(x, 0), default=0x0289)
    ap.add_argument("--setup", type=int, required=True)
    ap.add_argument("--sensor", type=int, required=True)
    ap.add_argument("--buf", type=int, default=4096, help="Raw buffer size for DoPERdSensorDef")
    args = ap.parse_args()

    try:
        dll = ctypes.WinDLL(str(DLL_PATH))
    except Exception as e:
        print(f"Failed to load DLL: {e}")
        return 100

    DoPEOpenLink = _bind(
        dll,
        "DoPEOpenLink",
        [
            ctypes.c_uint32,
            ctypes.c_uint32,
            ctypes.c_uint32,
            ctypes.c_uint32,
            ctypes.c_uint32,
            ctypes.c_uint32,
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_void_p),
        ],
        restype=ctypes.c_uint32,
    )
    DoPECloseLink = _bind(dll, "DoPECloseLink", [ctypes.c_void_p], restype=ctypes.c_uint32)

    # Select the setup (initializes), then OPEN it for read/write SensorDef.
    DoPESelSetup = _bind(
        dll,
        "DoPESelSetup",
        [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p],
        restype=ctypes.c_uint32,
    )

    DoPEOpenSetupSync = _bind(
        dll,
        "DoPEOpenSetupSync",
        [ctypes.c_void_p, ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint16), ctypes.POINTER(ctypes.c_uint16)],
        restype=ctypes.c_uint32,
    )

    DoPECloseSetup = _bind(dll, "DoPECloseSetup", [ctypes.c_void_p], restype=ctypes.c_uint32)

    DoPERdSensorDef = _bind(
        dll,
        "DoPERdSensorDef",
        [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p],
        restype=ctypes.c_uint32,
    )

    hdl = ctypes.c_void_p(None)
    try:
        err = int(DoPEOpenLink(args.port, args.baud, 10, 10, 10, int(args.api), None, ctypes.byref(hdl)))
        print(
            f"[{datetime.now().isoformat(timespec='seconds')}] DoPEOpenLink(port={args.port}, baud={args.baud}, api=0x{int(args.api):04x}) -> 0x{err:04x}, hdl={int(hdl.value) if hdl.value else 0}"
        )
        if err != 0 or not hdl.value:
            return 1
    except Exception as e:
        print(f"DoPEOpenLink raised: {e}")
        return 101

    try:
        try:
            err = int(DoPESelSetup(hdl, int(args.setup), None, None, None))
            print(f"DoPESelSetup(setup={args.setup}) -> 0x{err:04x}")
            if err != 0:
                return 2
        except Exception as e:
            print(f"DoPESelSetup raised: {e}")
            return 102

        if DoPEOpenSetupSync is None:
            print("DoPEOpenSetupSync not exported")
            return 203

        try:
            tan_first = ctypes.c_uint16(0)
            tan_last = ctypes.c_uint16(0)
            err = int(DoPEOpenSetupSync(hdl, int(args.setup), ctypes.byref(tan_first), ctypes.byref(tan_last)))
            print(f"DoPEOpenSetupSync(setup={args.setup}) -> 0x{err:04x} (tan_first={tan_first.value}, tan_last={tan_last.value})")
            if err != 0:
                return 4
        except Exception as e:
            print(f"DoPEOpenSetupSync raised: {e}")
            return 104

        time.sleep(0.1)

        try:
            buf = ctypes.create_string_buffer(int(args.buf))
            err = int(DoPERdSensorDef(hdl, int(args.sensor), ctypes.byref(buf)))
            print(f"DoPERdSensorDef(sensor={args.sensor}) -> 0x{err:04x}")
            if err != 0:
                return 3
        except Exception as e:
            print(f"DoPERdSensorDef raised: {e}")
            return 103

        blob = bytes(buf.raw)
        head = blob[:128]
        print(f"raw[0:128] = {head.hex()}")

        # quick pattern search
        for v in (85.0, 1000.0, 1100.0, -1100.0, 1500.0, -1500.0):
            offs = _find_double(blob, v)
            if offs:
                print(f"found double {v:g} at offsets: {offs[:10]}")

        # also search for uint16 connector=85
        pat85 = struct.pack("<H", 85)
        idx = blob.find(pat85)
        if idx >= 0:
            print(f"found uint16 85 (connector) at offset: {idx}")

        return 0

    finally:
        try:
            if DoPECloseSetup is not None and hdl.value:
                DoPECloseSetup(hdl)
        except Exception:
            pass
        try:
            DoPECloseLink(hdl)
        except Exception:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
