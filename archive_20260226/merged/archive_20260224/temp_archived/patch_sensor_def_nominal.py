#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Backup/patch/restore a sensor's DoPESenDef by editing the nominal value.

Why nominal?
- On your controller, the sensor range limits for the 1kN channel appear to be
  derived from the sensor's nominal value (often with a built-in tolerance like
  1.10x).
- `DoPERdSensorDef` for sensor 4 contains the double `1000.0` (nominal), but does
  NOT contain `1100.0`/`-1100.0` as raw doubles, suggesting limits are computed.

This tool:
- Opens the setup via DoPEOpenSetupSync (DoPEOpenSetup crashes on this DLL)
- Reads DoPERdSensorDef into a raw buffer
- Finds a *single* occurrence of nominal (default 1000.0) as a little-endian double
- Writes a patched SensorDef back via DoPEWrSensorDefSync
- Writes a JSON backup so you can restore exactly

Examples
  Apply 1k -> 1.5k (sensor 4, setup 1, COM7):
    .venv32\\Scripts\\python.exe .\\temp\\patch_sensor_def_nominal.py --port 7 --setup 1 --sensor 4 --apply --to 1500

  Restore:
    .venv32\\Scripts\\python.exe .\\temp\\patch_sensor_def_nominal.py --port 7 --setup 1 --sensor 4 --restore .\\temp\\backup_sensor4_setup1.json

WARNING
- This changes configuration used by other software.
- Always keep the backup JSON. Restoring writes the original bytes back.
"""

from __future__ import annotations

import argparse
import ctypes
import json
import struct
import subprocess
import sys
import time
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


def _find_double_offsets(blob: bytes, value: float) -> list[int]:
    pat = struct.pack("<d", float(value))
    out: list[int] = []
    start = 0
    while True:
        idx = blob.find(pat, start)
        if idx < 0:
            return out
        out.append(idx)
        start = idx + 1


@dataclass
class Backup:
    created_at: str
    dll: str
    port: int
    setup: int
    sensor: int
    buf_len: int
    data_hex: str
    note: str = ""


def main() -> int:
    _ensure_32bit_python()

    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, required=True)
    ap.add_argument("--baud", type=int, default=9600)
    ap.add_argument("--api", type=lambda x: int(x, 0), default=0x0289)
    ap.add_argument("--setup", type=int, required=True)
    ap.add_argument("--sensor", type=int, required=True)
    ap.add_argument("--buf", type=int, default=4096)

    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument("--apply", action="store_true")
    g.add_argument("--restore", type=str, default=None)

    ap.add_argument("--from", dest="from_value", type=float, default=1000.0, help="Nominal value to search for")
    ap.add_argument("--to", dest="to_value", type=float, default=1500.0, help="Nominal value to write")
    ap.add_argument("--backup", type=str, default=None, help="Backup JSON path (created on --apply)")
    ap.add_argument("--clear-basic-tare", action="store_true", help="Clear BasicTare on this sensor (recommended)")

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
        restype=ctypes.c_uint32,
    )
    DoPECloseLink = _bind(dll, "DoPECloseLink", [ctypes.c_void_p], restype=ctypes.c_uint32)

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

    DoPECloseSetupSync = _bind(
        dll,
        "DoPECloseSetupSync",
        [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.POINTER(ctypes.c_uint16)],
        restype=ctypes.c_uint32,
    )

    DoPERdSensorDef = _bind(dll, "DoPERdSensorDef", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p], restype=ctypes.c_uint32)
    DoPEWrSensorDefSync = _bind(dll, "DoPEWrSensorDefSync", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p], restype=ctypes.c_uint32)

    DoPERdSensorInfo = _bind(dll, "DoPERdSensorInfo", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p], restype=ctypes.c_uint32)

    DoPESetBasicTare = _bind(
        dll,
        "DoPESetBasicTare",
        [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_uint16, ctypes.c_double, ctypes.c_void_p, ctypes.c_void_p],
        restype=ctypes.c_uint32,
    )

    if DoPEOpenLink is None or DoPESelSetup is None or DoPEOpenSetupSync is None or DoPERdSensorDef is None or DoPEWrSensorDefSync is None:
        print("Missing required DLL exports")
        return 200

    hdl = ctypes.c_void_p(None)
    err = int(DoPEOpenLink(args.port, args.baud, 10, 10, 10, int(args.api), None, ctypes.byref(hdl)))
    print(f"DoPEOpenLink(port={args.port}) -> 0x{err:04x} (hdl={int(hdl.value) if hdl.value else 0})")
    if err != 0 or not hdl.value:
        return 101

    try:
        err = int(DoPESelSetup(hdl, int(args.setup), None, None, None))
        print(f"DoPESelSetup({args.setup}) -> 0x{err:04x}")
        if err != 0:
            return 102

        tan_first = ctypes.c_uint16(0)
        tan_last = ctypes.c_uint16(0)
        err = int(DoPEOpenSetupSync(hdl, int(args.setup), ctypes.byref(tan_first), ctypes.byref(tan_last)))
        print(f"DoPEOpenSetupSync({args.setup}) -> 0x{err:04x}")
        if err != 0:
            return 103

        if args.clear_basic_tare and DoPESetBasicTare is not None:
            # clear persistent basic tare via SUBTRACT mode with 0
            BASICTARE_SUBTRACT = 1
            err_bt = int(DoPESetBasicTare(hdl, int(args.sensor), BASICTARE_SUBTRACT, 0.0, None, None))
            print(f"DoPESetBasicTare(clear sensor={args.sensor}) -> 0x{err_bt:04x}")
            time.sleep(0.05)

        buf = ctypes.create_string_buffer(int(args.buf))
        err = int(DoPERdSensorDef(hdl, int(args.sensor), ctypes.byref(buf)))
        print(f"DoPERdSensorDef(sensor={args.sensor}) -> 0x{err:04x}")
        if err != 0:
            return 104

        blob = bytes(buf.raw)

        if args.restore:
            backup_path = Path(args.restore)
            bk = json.loads(backup_path.read_text(encoding="utf-8"))
            raw = bytes.fromhex(str(bk["data_hex"]))
            if len(raw) != int(args.buf):
                print(f"Backup buf_len={len(raw)} differs from current --buf={args.buf}; use the same --buf.")
                return 110
            buf2 = ctypes.create_string_buffer(raw, len(raw))
            err = int(DoPEWrSensorDefSync(hdl, int(args.sensor), ctypes.byref(buf2)))
            print(f"DoPEWrSensorDefSync(restore sensor={args.sensor}) -> 0x{err:04x}")
            if DoPECloseSetupSync is not None:
                tf = ctypes.c_uint16(0)
                tl = ctypes.c_uint16(0)
                errc = int(DoPECloseSetupSync(hdl, ctypes.byref(tf), ctypes.byref(tl)))
                print(f"DoPECloseSetupSync -> 0x{errc:04x}")
            # Re-select to apply edited setup to runtime
            err2 = int(DoPESelSetup(hdl, int(args.setup), None, None, None))
            print(f"DoPESelSetup(reload {args.setup}) -> 0x{err2:04x}")
            return 0 if (err == 0 and err2 == 0) else 111

        # apply
        offs = _find_double_offsets(blob, float(args.from_value))
        print(f"found nominal {args.from_value:g} at offsets: {offs}")
        if len(offs) != 1:
            print("Refusing to patch: expected exactly 1 occurrence of the nominal value.")
            return 120

        # write backup
        backup_path = Path(args.backup) if args.backup else (Path(__file__).with_name(f"backup_sensor{args.sensor}_setup{args.setup}.json"))
        backup = Backup(
            created_at=datetime.now().isoformat(timespec="seconds"),
            dll=str(DLL_PATH),
            port=int(args.port),
            setup=int(args.setup),
            sensor=int(args.sensor),
            buf_len=int(args.buf),
            data_hex=blob.hex(),
            note=f"Before patch nominal {args.from_value:g} -> {args.to_value:g}",
        )
        backup_path.write_text(json.dumps(backup.__dict__, indent=2), encoding="utf-8")
        print(f"Backup written: {backup_path}")

        patched = bytearray(blob)
        patched[offs[0] : offs[0] + 8] = struct.pack("<d", float(args.to_value))
        buf3 = ctypes.create_string_buffer(bytes(patched), len(patched))
        err = int(DoPEWrSensorDefSync(hdl, int(args.sensor), ctypes.byref(buf3)))
        print(f"DoPEWrSensorDefSync(patch sensor={args.sensor}) -> 0x{err:04x}")
        if err != 0:
            print("Patch failed; restoring original...")
            buf_restore = ctypes.create_string_buffer(blob, len(blob))
            err2 = int(DoPEWrSensorDefSync(hdl, int(args.sensor), ctypes.byref(buf_restore)))
            print(f"DoPEWrSensorDefSync(restore) -> 0x{err2:04x}")
            return 130

        # Close setup to commit changes
        if DoPECloseSetupSync is not None:
            tf = ctypes.c_uint16(0)
            tl = ctypes.c_uint16(0)
            errc = int(DoPECloseSetupSync(hdl, ctypes.byref(tf), ctypes.byref(tl)))
            print(f"DoPECloseSetupSync -> 0x{errc:04x}")

        # Re-select to apply edited setup to runtime
        err_sel2 = int(DoPESelSetup(hdl, int(args.setup), None, None, None))
        print(f"DoPESelSetup(reload {args.setup}) -> 0x{err_sel2:04x}")

        # verify via SensorInfo
        if DoPERdSensorInfo is not None:
            info_buf = ctypes.create_string_buffer(256)
            erri = int(DoPERdSensorInfo(hdl, int(args.sensor), ctypes.byref(info_buf)))
            print(f"DoPERdSensorInfo(sensor={args.sensor}) -> 0x{erri:04x}")
            if erri == 0:
                # parse the first few fields: WORD Connector; double NominalValue; WORD Unit; ... double UpperLimit; double LowerLimit
                # Layout matches DoPESumSenInfo.
                connector = struct.unpack_from("<H", info_buf.raw, 0)[0]
                nominal = struct.unpack_from("<d", info_buf.raw, 2)[0]
                unit = struct.unpack_from("<H", info_buf.raw, 10)[0]
                upper = struct.unpack_from("<d", info_buf.raw, 20)[0]
                lower = struct.unpack_from("<d", info_buf.raw, 28)[0]
                print(f"[verify] connector={connector} unit={unit} nominal={nominal:g} upper={upper:g} lower={lower:g}")

        return 0

    finally:
        # NOTE: DoPECloseSetup has crashed in some signature mismatches; do not call it here.
        # CloseLink is generally safe.
        try:
            if DoPECloseLink is not None:
                DoPECloseLink(hdl)
        except Exception:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
