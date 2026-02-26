#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Backup/patch/restore SetupAll bytes for a given setup.

This lets us do surgical edits to setup-wide parameters when we only know
specific byte offsets (e.g. a global cap stored as a double).

Examples:
  Apply byte patch:
    .venv32\\Scripts\\python.exe .\\temp\\patch_setup_all_bytes.py --port 7 --setup 3 --apply --set 6412=0x00

  Restore from backup JSON:
    .venv32\\Scripts\\python.exe .\\temp\\patch_setup_all_bytes.py --port 7 --setup 3 --restore .\\temp\\backup_setup3_setupall.json

Notes:
- Uses DoPERdSetupAllSync/DoPEWrSetupAllSync if exported, otherwise non-Sync.
- Opens setup via DoPEOpenSetupSync for safety, and commits via DoPECloseSetupSync.
"""

from __future__ import annotations

import argparse
import ctypes
import json
import re
import subprocess
import sys
from dataclasses import dataclass
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


@dataclass
class Backup:
    created_at: str
    port: int
    setup: int
    buf_len: int
    data_hex: str


def _parse_set_kv(s: str) -> tuple[int, int]:
    m = re.fullmatch(r"(\d+)=(0x[0-9a-fA-F]+|\d+)", s.strip())
    if not m:
        raise argparse.ArgumentTypeError("--set must be like OFFSET=VALUE (VALUE decimal or 0x..)")
    off = int(m.group(1))
    val = int(m.group(2), 0)
    if not (0 <= val <= 255):
        raise argparse.ArgumentTypeError("VALUE must be 0..255")
    return off, val


def main() -> int:
    _ensure_32bit_python()

    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, required=True)
    ap.add_argument("--baud", type=int, default=9600)
    ap.add_argument("--api", type=lambda s: int(s, 0), default=0x0289)
    ap.add_argument("--setup", type=int, required=True)
    ap.add_argument("--buf", type=int, default=16384)

    mode = ap.add_mutually_exclusive_group(required=True)
    mode.add_argument("--apply", action="store_true")
    mode.add_argument("--restore", type=str)

    ap.add_argument("--set", dest="sets", action="append", type=_parse_set_kv, default=[])
    ap.add_argument(
        "--backup",
        type=str,
        default=None,
        help="Backup JSON path (default: temp/backup_setup<setup>_setupall.json)",
    )

    args = ap.parse_args()

    if args.apply and not args.sets:
        raise SystemExit("--apply requires at least one --set OFFSET=VALUE")

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

    rd_name = "DoPERdSetupAllSync" if hasattr(dll, "DoPERdSetupAllSync") else "DoPERdSetupAll"
    wr_name = "DoPEWrSetupAllSync" if hasattr(dll, "DoPEWrSetupAllSync") else "DoPEWrSetupAll"
    DoPERdSetupAll = _bind(dll, rd_name, [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p])
    DoPEWrSetupAll = _bind(dll, wr_name, [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p])

    if DoPEOpenLink is None or DoPERdSetupAll is None or DoPEWrSetupAll is None:
        raise SystemExit("Missing required exports (OpenLink, RdSetupAll, WrSetupAll)")

    hdl = ctypes.c_void_p(None)
    err = int(DoPEOpenLink(int(args.port), int(args.baud), 10, 10, 10, int(args.api), None, ctypes.byref(hdl)))
    print(f"DoPEOpenLink(port={args.port}) -> 0x{err:04x} (hdl={int(hdl.value) if hdl.value else 0})")
    if err != 0 or not hdl.value:
        return 10

    try:
        if DoPESelSetup is not None:
            err = int(DoPESelSetup(hdl, int(args.setup), None, None, None))
            print(f"DoPESelSetup({args.setup}) -> 0x{err:04x}")

        if DoPEOpenSetupSync is not None:
            tf = ctypes.c_uint16(0)
            tl = ctypes.c_uint16(0)
            err = int(DoPEOpenSetupSync(hdl, int(args.setup), ctypes.byref(tf), ctypes.byref(tl)))
            print(f"DoPEOpenSetupSync({args.setup}) -> 0x{err:04x}")

        buf = ctypes.create_string_buffer(int(args.buf))
        err = int(DoPERdSetupAll(hdl, int(args.setup), ctypes.byref(buf)))
        print(f"{rd_name}({args.setup}) -> 0x{err:04x}")
        if err != 0:
            return 11
        orig = bytes(buf.raw)

        backup_path = Path(args.backup) if args.backup else (Path(__file__).parent / f"backup_setup{args.setup}_setupall.json")

        if args.restore:
            bk = json.loads(Path(args.restore).read_text(encoding="utf-8"))
            raw = bytes.fromhex(str(bk["data_hex"]))
            if len(raw) != len(orig):
                print(f"Backup len={len(raw)} differs from current --buf={len(orig)}; rerun with --buf {len(raw)}")
                return 20
            wbuf = ctypes.create_string_buffer(raw, len(raw))
            errw = int(DoPEWrSetupAll(hdl, int(args.setup), ctypes.byref(wbuf)))
            print(f"{wr_name}(restore) -> 0x{errw:04x}")
        else:
            bk = Backup(
                created_at=datetime.now().isoformat(timespec="seconds"),
                port=int(args.port),
                setup=int(args.setup),
                buf_len=len(orig),
                data_hex=orig.hex(),
            )
            backup_path.write_text(json.dumps(bk.__dict__, indent=2), encoding="utf-8")
            print(f"Backup written: {backup_path}")

            patched = bytearray(orig)
            for off, val in args.sets:
                if not (0 <= off < len(patched)):
                    raise SystemExit(f"Offset {off} out of range (0..{len(patched)-1})")
                patched[off] = int(val)

            print("Patches:")
            for off, val in args.sets:
                print(f"  off {off}: 0x{orig[off]:02x} -> 0x{val:02x}")

            wbuf = ctypes.create_string_buffer(bytes(patched), len(patched))
            errw = int(DoPEWrSetupAll(hdl, int(args.setup), ctypes.byref(wbuf)))
            print(f"{wr_name}(apply) -> 0x{errw:04x}")

        if DoPECloseSetupSync is not None:
            tf2 = ctypes.c_uint16(0)
            tl2 = ctypes.c_uint16(0)
            errc = int(DoPECloseSetupSync(hdl, ctypes.byref(tf2), ctypes.byref(tl2)))
            print(f"DoPECloseSetupSync -> 0x{errc:04x}")

        if DoPESelSetup is not None:
            errr = int(DoPESelSetup(hdl, int(args.setup), None, None, None))
            print(f"DoPESelSetup(reload {args.setup}) -> 0x{errr:04x}")

        return 0

    finally:
        try:
            if DoPECloseLink is not None and hdl.value:
                DoPECloseLink(hdl)
        except Exception:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
