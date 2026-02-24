#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Diff two SensorDef blobs byte-by-byte.

Example:
  .venv32\\Scripts\\python.exe .\\temp\\diff_sensor_def.py --port 7 \
    --a-setup 1 --a-sensor 4 --b-setup 3 --b-sensor 1 --buf 256
"""

from __future__ import annotations

import argparse
import ctypes
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
        raise AttributeError(f"DoPE.dll does not export {name}")
    fn.argtypes = argtypes
    fn.restype = restype
    return fn


def _read_two_sensordefs(
    port: int,
    baud: int,
    api: int,
    a_setup: int,
    a_sensor: int,
    b_setup: int,
    b_sensor: int,
    buf_len: int,
) -> tuple[bytes, bytes]:
    """Open the link once, read both SensorDefs, then close.

    Opening the link twice back-to-back often fails with 'device in use' (0x800a).
    """

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
    DoPEOpenSetupSync = _bind(
        dll,
        "DoPEOpenSetupSync",
        [ctypes.c_void_p, ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint16), ctypes.POINTER(ctypes.c_uint16)],
    )
    # Prefer Sync close (some builds are unstable with DoPECloseSetup)
    DoPECloseSetupSync = _bind(
        dll,
        "DoPECloseSetupSync",
        [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.POINTER(ctypes.c_uint16)],
    )
    DoPECloseSetup = _bind(dll, "DoPECloseSetup", [ctypes.c_void_p])
    DoPERdSensorDef = _bind(dll, "DoPERdSensorDef", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p])

    hdl = ctypes.c_void_p(None)
    err = int(DoPEOpenLink(int(port), int(baud), 10, 10, 10, int(api), None, ctypes.byref(hdl)))
    if err != 0 or not hdl.value:
        raise RuntimeError(f"DoPEOpenLink failed: 0x{err:04x}")

    def _read_one(setup: int, sensor: int) -> bytes:
        err2 = int(DoPESelSetup(hdl, int(setup), None, None, None))
        if err2 != 0:
            raise RuntimeError(f"DoPESelSetup({setup}) failed: 0x{err2:04x}")

        tf = ctypes.c_uint16(0)
        tl = ctypes.c_uint16(0)
        err3 = int(DoPEOpenSetupSync(hdl, int(setup), ctypes.byref(tf), ctypes.byref(tl)))
        if err3 != 0:
            raise RuntimeError(f"DoPEOpenSetupSync({setup}) failed: 0x{err3:04x}")

        try:
            buf = ctypes.create_string_buffer(int(buf_len))
            err4 = int(DoPERdSensorDef(hdl, int(sensor), ctypes.byref(buf)))
            if err4 != 0:
                raise RuntimeError(f"DoPERdSensorDef(sensor={sensor}) failed: 0x{err4:04x}")
            return bytes(buf.raw)
        finally:
            # Close setup to avoid leaving the device busy
            try:
                if DoPECloseSetupSync is not None:
                    tf2 = ctypes.c_uint16(0)
                    tl2 = ctypes.c_uint16(0)
                    DoPECloseSetupSync(hdl, ctypes.byref(tf2), ctypes.byref(tl2))
                else:
                    DoPECloseSetup(hdl)
            except Exception:
                pass

    try:
        a = _read_one(a_setup, a_sensor)
        b = _read_one(b_setup, b_sensor)
        return a, b
    finally:
        try:
            DoPECloseLink(hdl)
        except Exception:
            pass


def main() -> int:
    _ensure_32bit_python()

    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, required=True)
    ap.add_argument("--baud", type=int, default=9600)
    ap.add_argument("--api", type=lambda s: int(s, 0), default=0x0289)
    ap.add_argument("--buf", type=int, default=256)

    ap.add_argument("--a-setup", type=int, required=True)
    ap.add_argument("--a-sensor", type=int, required=True)
    ap.add_argument("--b-setup", type=int, required=True)
    ap.add_argument("--b-sensor", type=int, required=True)

    args = ap.parse_args()

    a, b = _read_two_sensordefs(
        args.port,
        args.baud,
        args.api,
        args.a_setup,
        args.a_sensor,
        args.b_setup,
        args.b_sensor,
        args.buf,
    )

    if len(a) != len(b):
        print(f"len differs: a={len(a)} b={len(b)}")
        return 2

    diffs = [(i, a[i], b[i]) for i in range(len(a)) if a[i] != b[i]]
    print(f"Diff a(setup={args.a_setup},sensor={args.a_sensor}) vs b(setup={args.b_setup},sensor={args.b_sensor}) len={len(a)}")
    print(f"Different bytes: {len(diffs)}")

    for i, av, bv in diffs[:200]:
        print(f"  off={i:3d}: a=0x{av:02x} b=0x{bv:02x}")

    if len(diffs) > 200:
        print("  ...")

    # Show first 64 bytes for visual comparison
    print("a[0:64]=" + a[:64].hex())
    print("b[0:64]=" + b[:64].hex())

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
