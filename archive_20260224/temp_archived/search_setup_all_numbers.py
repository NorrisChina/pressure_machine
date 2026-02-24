#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Search SetupAll blob for numeric patterns (float32/float64, little-endian).

Example:
  .venv32\\Scripts\\python.exe .\\temp\\search_setup_all_numbers.py --port 7 --setup 3 --value 1.1 --value 1.5

This is a read-only helper.
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


def _read_setup_all(dll: ctypes.WinDLL, hdl: ctypes.c_void_p, setup_no: int, buf_len: int) -> bytes:
    fn_name = "DoPERdSetupAllSync" if hasattr(dll, "DoPERdSetupAllSync") else "DoPERdSetupAll"
    Rd = _bind(dll, fn_name, [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p])
    if Rd is None:
        raise RuntimeError("DoPERdSetupAll(Sync) not found")
    buf = ctypes.create_string_buffer(int(buf_len))
    err = int(Rd(hdl, int(setup_no), ctypes.byref(buf)))
    if err != 0:
        raise RuntimeError(f"{fn_name}({setup_no}) failed: 0x{err:04x}")
    return bytes(buf.raw)


def _find_all(blob: bytes, pat: bytes) -> list[int]:
    out = []
    start = 0
    while True:
        i = blob.find(pat, start)
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
    ap.add_argument("--buf", type=int, default=16384)
    ap.add_argument("--setup", type=int, required=True)
    ap.add_argument("--value", type=float, action="append", required=True)
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

    hdl = ctypes.c_void_p(None)
    err = int(DoPEOpenLink(int(args.port), int(args.baud), 10, 10, 10, int(args.api), None, ctypes.byref(hdl)))
    print(f"DoPEOpenLink -> 0x{err:04x} (hdl={int(hdl.value) if hdl.value else 0})")
    if err != 0 or not hdl.value:
        return 10

    try:
        blob = _read_setup_all(dll, hdl, int(args.setup), int(args.buf))

        for v in args.value:
            f32 = struct.pack("<f", float(v))
            f64 = struct.pack("<d", float(v))
            o32 = _find_all(blob, f32)
            o64 = _find_all(blob, f64)
            print(f"value={v:g}")
            if o32:
                print(f"  float32 {f32.hex()} offs={o32[:40]}{' ...' if len(o32)>40 else ''}")
            if o64:
                print(f"  float64 {f64.hex()} offs={o64[:40]}{' ...' if len(o64)>40 else ''}")
            if not o32 and not o64:
                print("  (no matches)")

        return 0

    finally:
        try:
            if DoPECloseLink is not None and hdl.value:
                DoPECloseLink(hdl)
        except Exception:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
