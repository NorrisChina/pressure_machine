#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Probe DoPEOpenSetup/DoPEOpenSetupSync signatures in an isolated process.

Why this exists
- Some DoPE DLL calls crash Python with access violations if the signature/handle
  type is wrong.
- This script is intended to be run as a subprocess with one variant at a time.

Usage examples
  .venv32\\Scripts\\python.exe .\\temp\\probe_open_setup_sig.py --port 7 --setup 1 --variant opensetup_voidp
  .venv32\\Scripts\\python.exe .\\temp\\probe_open_setup_sig.py --port 7 --setup 1 --variant opensetup_ulong
  .venv32\\Scripts\\python.exe .\\temp\\probe_open_setup_sig.py --port 7 --setup 1 --variant opensetup_sync_tans

Exit codes
- 0: call returned successfully (even if DoPERR != 0)
- 10x: could not open link
- 20x: function missing
- 30x: exception thrown by ctypes

"""

from __future__ import annotations

import argparse
import ctypes
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


def _bind(dll: ctypes.WinDLL, name: str, argtypes: list, restype=ctypes.c_uint32):
    fn = getattr(dll, name, None)
    if fn is None:
        return None
    fn.argtypes = argtypes
    fn.restype = restype
    return fn


def main() -> int:
    _ensure_32bit_python()

    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, required=True)
    ap.add_argument("--baud", type=int, default=9600)
    ap.add_argument("--api", type=lambda x: int(x, 0), default=0x0289)
    ap.add_argument("--setup", type=int, required=True)
    ap.add_argument(
        "--variant",
        type=str,
        required=True,
        choices=[
            "opensetup_voidp",
            "opensetup_ulong",
            "opensetup_sync_tans",
            "opensetup_sync_voidp",
        ],
    )
    args = ap.parse_args()

    dll = ctypes.WinDLL(str(DLL_PATH))

    # Open link (use void* handle to match many PDF-aligned bindings)
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

    if DoPEOpenLink is None:
        print("DoPEOpenLink not exported")
        return 201

    hdl = ctypes.c_void_p(None)
    err = int(DoPEOpenLink(args.port, args.baud, 10, 10, 10, int(args.api), None, ctypes.byref(hdl)))
    print(
        f"[{datetime.now().isoformat(timespec='seconds')}] DoPEOpenLink(port={args.port}) -> 0x{err:04x}, hdl={int(hdl.value) if hdl.value else 0}"
    )
    if err != 0 or not hdl.value:
        return 101

    try:
        # Always select setup first (this part is known-good)
        DoPESelSetup = _bind(
            dll,
            "DoPESelSetup",
            [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p],
            restype=ctypes.c_uint32,
        )
        if DoPESelSetup is None:
            print("DoPESelSetup not exported")
            return 202
        err_sel = int(DoPESelSetup(hdl, int(args.setup), None, None, None))
        print(f"DoPESelSetup({args.setup}) -> 0x{err_sel:04x}")

        time.sleep(0.05)

        if args.variant == "opensetup_voidp":
            fn = _bind(dll, "DoPEOpenSetup", [ctypes.c_void_p, ctypes.c_uint16], restype=ctypes.c_uint32)
            if fn is None:
                print("DoPEOpenSetup not exported")
                return 203
            err_os = int(fn(hdl, int(args.setup)))
            print(f"DoPEOpenSetup(voidp, u16) -> 0x{err_os:04x}")
            return 0

        if args.variant == "opensetup_ulong":
            # Some older code uses unsigned long handles.
            fn = _bind(dll, "DoPEOpenSetup", [ctypes.c_uint32, ctypes.c_uint16], restype=ctypes.c_uint32)
            if fn is None:
                print("DoPEOpenSetup not exported")
                return 203
            err_os = int(fn(ctypes.c_uint32(int(hdl.value)), int(args.setup)))
            print(f"DoPEOpenSetup(ulong, u16) -> 0x{err_os:04x}")
            return 0

        if args.variant == "opensetup_sync_tans":
            fn = _bind(
                dll,
                "DoPEOpenSetupSync",
                [ctypes.c_void_p, ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint16), ctypes.POINTER(ctypes.c_uint16)],
                restype=ctypes.c_uint32,
            )
            if fn is None:
                print("DoPEOpenSetupSync not exported")
                return 204
            tan_first = ctypes.c_uint16(0)
            tan_last = ctypes.c_uint16(0)
            err_os = int(fn(hdl, int(args.setup), ctypes.byref(tan_first), ctypes.byref(tan_last)))
            print(f"DoPEOpenSetupSync(voidp,u16,tans) -> 0x{err_os:04x} (tan_first={tan_first.value}, tan_last={tan_last.value})")
            return 0

        if args.variant == "opensetup_sync_voidp":
            # Maybe Sync has only 2 args
            fn = _bind(dll, "DoPEOpenSetupSync", [ctypes.c_void_p, ctypes.c_uint16], restype=ctypes.c_uint32)
            if fn is None:
                print("DoPEOpenSetupSync not exported")
                return 204
            err_os = int(fn(hdl, int(args.setup)))
            print(f"DoPEOpenSetupSync(voidp,u16) -> 0x{err_os:04x}")
            return 0

        return 0

    except Exception as e:
        print(f"ctypes exception: {e}")
        return 301

    finally:
        try:
            if DoPECloseLink is not None:
                DoPECloseLink(hdl)
        except Exception:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
