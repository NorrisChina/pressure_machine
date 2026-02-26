#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Search SensorDef blob for integer encodings (u16/i16/u32/i32) of target values.

Usage:
  .venv32\\Scripts\\python.exe .\\temp\\search_sensor_def_ints.py --port 7 --setup 3 --sensor 1 --value 440

This is a read-only helper: it opens the setup, reads SensorDef (default 256 bytes)
then prints offsets where the value appears in various integer encodings.
"""

from __future__ import annotations

import argparse
import ctypes
import struct
import subprocess
import sys
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


def _bind(dll: ctypes.WinDLL, name: str, argtypes: list, restype=ctypes.c_uint32):
    fn = getattr(dll, name, None)
    if fn is None:
        return None
    fn.argtypes = argtypes
    fn.restype = restype
    return fn


def _find_all(haystack: bytes, needle: bytes) -> list[int]:
    out: list[int] = []
    start = 0
    while True:
        i = haystack.find(needle, start)
        if i < 0:
            return out
        out.append(i)
        start = i + 1


def main() -> int:
    _ensure_32bit_python()

    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, required=True)
    ap.add_argument("--baud", type=int, default=9600)
    ap.add_argument("--api", type=lambda s: int(s, 0), default=0x0289)
    ap.add_argument("--setup", type=int, required=True)
    ap.add_argument("--sensor", type=int, required=True)
    ap.add_argument("--buf", type=int, default=256)
    ap.add_argument("--value", type=int, action="append", required=True)
    args = ap.parse_args()

    dll = ctypes.WinDLL(str(DLL_PATH))

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
    )
    DoPECloseLink = _bind(dll, "DoPECloseLink", [ctypes.c_void_p])
    DoPESelSetup = _bind(dll, "DoPESelSetup", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p])
    DoPEOpenSetupSync = _bind(dll, "DoPEOpenSetupSync", [ctypes.c_void_p, ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint16), ctypes.POINTER(ctypes.c_uint16)])
    DoPECloseSetupSync = _bind(dll, "DoPECloseSetupSync", [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.POINTER(ctypes.c_uint16)])
    DoPERdSensorDef = _bind(dll, "DoPERdSensorDef", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p])

    if DoPEOpenLink is None or DoPESelSetup is None or DoPEOpenSetupSync is None or DoPERdSensorDef is None:
        raise SystemExit("Missing required exports")

    hdl = ctypes.c_void_p(None)
    err = int(DoPEOpenLink(int(args.port), int(args.baud), 10, 10, 10, int(args.api), None, ctypes.byref(hdl)))
    print(f"DoPEOpenLink -> 0x{err:04x} (hdl={int(hdl.value) if hdl.value else 0})")
    if err != 0 or not hdl.value:
        return 10

    try:
        err = int(DoPESelSetup(hdl, int(args.setup), None, None, None))
        print(f"DoPESelSetup({args.setup}) -> 0x{err:04x}")
        if err != 0:
            return 11

        tf = ctypes.c_uint16(0)
        tl = ctypes.c_uint16(0)
        err = int(DoPEOpenSetupSync(hdl, int(args.setup), ctypes.byref(tf), ctypes.byref(tl)))
        print(f"DoPEOpenSetupSync({args.setup}) -> 0x{err:04x}")
        if err != 0:
            return 12

        buf = ctypes.create_string_buffer(int(args.buf))
        err = int(DoPERdSensorDef(hdl, int(args.sensor), ctypes.byref(buf)))
        print(f"DoPERdSensorDef(sensor={args.sensor}) -> 0x{err:04x}")
        if err != 0:
            return 13

        blob = bytes(buf.raw)

        def show(label: str, offsets: list[int], needle: bytes):
            if not offsets:
                return
            hx = needle.hex(" ")
            print(f"  {label} ({hx}): {offsets}")

        print("Matches:")
        for v in args.value:
            print(f"- value={v}")
            show("u16-le", _find_all(blob, struct.pack("<H", v & 0xFFFF)), struct.pack("<H", v & 0xFFFF))
            if -32768 <= v <= 32767:
                show("i16-le", _find_all(blob, struct.pack("<h", v)), struct.pack("<h", v))
            show("u32-le", _find_all(blob, struct.pack("<I", v & 0xFFFFFFFF)), struct.pack("<I", v & 0xFFFFFFFF))
            if -2**31 <= v <= 2**31 - 1:
                show("i32-le", _find_all(blob, struct.pack("<i", v)), struct.pack("<i", v))

        if DoPECloseSetupSync is not None:
            tf2 = ctypes.c_uint16(0)
            tl2 = ctypes.c_uint16(0)
            DoPECloseSetupSync(hdl, ctypes.byref(tf2), ctypes.byref(tl2))

        return 0

    finally:
        try:
            if DoPECloseLink is not None and hdl.value:
                DoPECloseLink(hdl)
        except Exception:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
