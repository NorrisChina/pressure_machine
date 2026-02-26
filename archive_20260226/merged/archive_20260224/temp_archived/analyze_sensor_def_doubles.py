#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Scan a SensorDef blob for plausible double fields.

This helps identify scaling/correction factors inside DoPERdSensorDef without
knowing the full C struct layout.

Example:
  .venv32\\Scripts\\python.exe .\\temp\\analyze_sensor_def_doubles.py --port 7 --setup 3 --sensor 1 --buf 256
"""

from __future__ import annotations

import argparse
import ctypes
import math
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
        raise AttributeError(f"DoPE.dll does not export {name}")
    fn.argtypes = argtypes
    fn.restype = restype
    return fn


def _read_sensordef(port: int, baud: int, api: int, setup: int, sensor: int, buf_len: int) -> bytes:
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
    DoPECloseSetup = _bind(dll, "DoPECloseSetup", [ctypes.c_void_p])
    DoPERdSensorDef = _bind(dll, "DoPERdSensorDef", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p])

    hdl = ctypes.c_void_p(None)
    err = int(DoPEOpenLink(int(port), int(baud), 10, 10, 10, int(api), None, ctypes.byref(hdl)))
    if err != 0 or not hdl.value:
        raise RuntimeError(f"DoPEOpenLink failed: 0x{err:04x}")

    try:
        err = int(DoPESelSetup(hdl, int(setup), None, None, None))
        if err != 0:
            raise RuntimeError(f"DoPESelSetup failed: 0x{err:04x}")

        tf = ctypes.c_uint16(0)
        tl = ctypes.c_uint16(0)
        err = int(DoPEOpenSetupSync(hdl, int(setup), ctypes.byref(tf), ctypes.byref(tl)))
        if err != 0:
            raise RuntimeError(f"DoPEOpenSetupSync failed: 0x{err:04x}")

        buf = ctypes.create_string_buffer(int(buf_len))
        err = int(DoPERdSensorDef(hdl, int(sensor), ctypes.byref(buf)))
        if err != 0:
            raise RuntimeError(f"DoPERdSensorDef failed: 0x{err:04x}")

        return bytes(buf.raw)
    finally:
        # NOTE: Some DLL builds crash on DoPECloseSetup/DoPECloseLink after setup access.
        # This tool is read-only and short-lived; we intentionally skip closing calls
        # to avoid an access violation that would hide the analysis output.
        _ = DoPECloseSetup
        _ = DoPECloseLink
        pass


def main() -> int:
    _ensure_32bit_python()

    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, required=True)
    ap.add_argument("--baud", type=int, default=9600)
    ap.add_argument("--api", type=lambda s: int(s, 0), default=0x0289)
    ap.add_argument("--setup", type=int, required=True)
    ap.add_argument("--sensor", type=int, required=True)
    ap.add_argument("--buf", type=int, default=256)
    ap.add_argument("--min", dest="minv", type=float, default=0.01)
    ap.add_argument("--max", dest="maxv", type=float, default=10.0)
    args = ap.parse_args()

    blob = _read_sensordef(args.port, args.baud, args.api, args.setup, args.sensor, args.buf)

    hits: list[tuple[int, float]] = []
    for off in range(0, len(blob) - 7):
        # only aligned offsets are a good signal; but we scan all and later filter duplicates
        try:
            v = struct.unpack_from("<d", blob, off)[0]
        except struct.error:
            continue
        if not math.isfinite(v):
            continue
        if args.minv <= abs(v) <= args.maxv:
            hits.append((off, float(v)))

    # de-dup near-identical float patterns by offset
    print(f"SensorDef setup={args.setup} sensor={args.sensor} len={len(blob)}")
    print(f"raw[0:64]={blob[:64].hex()}")
    print(f"Candidate doubles with |v| in [{args.minv}, {args.maxv}]: {len(hits)}")

    # show aligned hits first
    aligned = [(o, v) for (o, v) in hits if o % 2 == 0]
    aligned.sort(key=lambda t: (t[0]))
    for o, v in aligned[:120]:
        print(f"  off={o:4d}  v={v:+.6g}")

    # Also explicitly show exact matches for common factors
    for target in (0.5, 1.0, 2.0, -0.5, -1.0, -2.0):
        pat = struct.pack("<d", target)
        start = 0
        offs = []
        while True:
            idx = blob.find(pat, start)
            if idx < 0:
                break
            offs.append(idx)
            start = idx + 1
        if offs:
            print(f"exact double {target:+g} at offsets: {offs}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
