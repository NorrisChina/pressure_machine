#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Find candidate offsets in SetupAll that might represent a cap/max-percent.

Heuristic: show offsets where setup B has a given byte value (e.g. 110)
while setup A has a different value.

Example:
  .venv32\\Scripts\\python.exe .\\temp\\find_setup_all_byte_candidates.py --port 7 --a-setup 1 --b-setup 3 --byte 110
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


def main() -> int:
    _ensure_32bit_python()

    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, required=True)
    ap.add_argument("--baud", type=int, default=9600)
    ap.add_argument("--api", type=lambda s: int(s, 0), default=0x0289)
    ap.add_argument("--buf", type=int, default=16384)
    ap.add_argument("--a-setup", type=int, required=True)
    ap.add_argument("--b-setup", type=int, required=True)
    ap.add_argument("--byte", type=lambda s: int(s, 0), required=True)
    ap.add_argument("--max", type=int, default=200)
    args = ap.parse_args()

    target = int(args.byte) & 0xFF

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
        a = _read_setup_all(dll, hdl, int(args.a_setup), int(args.buf))
        b = _read_setup_all(dll, hdl, int(args.b_setup), int(args.buf))
        n = min(len(a), len(b))

        hits = [i for i in range(n) if b[i] == target and a[i] != target]
        print(f"Offsets where b==0x{target:02x} and a!=0x{target:02x}: {len(hits)}")
        for off in hits[: int(args.max)]:
            print(f"  off={off:05d}: a=0x{a[off]:02x} b=0x{b[off]:02x}")
        if len(hits) > int(args.max):
            print(f"  ... {len(hits) - int(args.max)} more")
        return 0

    finally:
        try:
            if DoPECloseLink is not None and hdl.value:
                DoPECloseLink(hdl)
        except Exception:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
