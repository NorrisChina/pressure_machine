"""Patch analogue sensor EEPROM limits (reversible).

Goal: widen the allowed range on an analogue sensor by adjusting NegLimit/PosLimit
(percent of nominal) in the sensor plug EEPROM.

This is meant for emergency recovery and MUST be used carefully.

Example (X21B connector=85, COM7):
  .venv32\\Scripts\\python.exe .\\temp\\patch_sensor_eeprom_analogue_limits.py \
    --port 7 --connector 85 --apply --neglimit 150 --poslimit 150 --force

Rollback:
  .venv32\\Scripts\\python.exe .\\temp\\patch_sensor_eeprom_analogue_limits.py \
    --port 7 --connector 85 --restore .\\temp\\backup_connector85_analogue.json
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
from typing import Optional

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


def _load_dll() -> ctypes.WinDLL:
    # Prefer the repo-local DLL to avoid PATH issues.
    for candidate in (DLL_PATH, Path(__file__).resolve().parents[1] / "drivers" / "DoDpx.dll", Path("DoPE.dll"), Path("DoDpx.dll")):
        try:
            return ctypes.WinDLL(str(candidate))
        except OSError:
            continue
    raise SystemExit("Cannot load DoPE/DoDpx DLL. Expected at drivers/DoPE.dll (repo root).")


def _open_link(dll: ctypes.WinDLL, port: int, baud: int, api_version: int) -> ctypes.c_void_p:
    DoPEOpenLink = _bind(
        dll,
        "DoPEOpenLink",
        [
            ctypes.c_ulong,
            ctypes.c_ulong,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_ulong,
            ctypes.c_ushort,
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_ulong),
        ],
    )
    if DoPEOpenLink is None:
        raise SystemExit("DoPEOpenLink not found in DLL")
    hdl = ctypes.c_ulong(0)
    err = int(DoPEOpenLink(int(port), int(baud), 10, 10, 10, int(api_version), None, ctypes.byref(hdl)))
    print(f"DoPEOpenLink(port={port}) -> 0x{err:04x} (hdl={int(hdl.value) if hdl.value else 0})")
    if err != 0 or not hdl.value:
        raise SystemExit(f"DoPEOpenLink failed: 0x{err:04x}")
    return ctypes.c_void_p(int(hdl.value))


def _unpack_u16_at(buf: bytes, offset: int) -> int:
    return int(struct.unpack_from("<H", buf, offset)[0])


def _pack_u16(value: int) -> bytes:
    return struct.pack("<H", int(value) & 0xFFFF)


def _pack_f32(value: float) -> bytes:
    return struct.pack("<f", float(value))


def _find_candidate_offsets(blob: bytes, nominal_f32: float, unit_u16: int, neg_u16: int, pos_u16: int) -> list[tuple[int, int, int]]:
    """Heuristically locate Unit/NegLimit/PosLimit words inside the AnalogueData blob.

    Returns list of candidates as tuples:
      (nominal_offset, neg_offset, pos_offset)

    The EEPROM structs are C-compiled and may include padding; we avoid hard-coding offsets.
    """

    nominal_pat = _pack_f32(nominal_f32)
    candidates: list[tuple[int, int, int]] = []

    start = 0
    while True:
        idx = blob.find(nominal_pat, start)
        if idx < 0:
            break
        # search forward in a small window for Unit and the two limit words
        win = blob[idx : idx + 64]
        # find unit
        unit_pat = _pack_u16(unit_u16)
        unit_rel = win.find(unit_pat)
        if unit_rel >= 0:
            # from unit onward, search for Neg/Pos as adjacent words (often back-to-back)
            post = win[unit_rel :]
            neg_pat = _pack_u16(neg_u16)
            pos_pat = _pack_u16(pos_u16)
            neg_rel = post.find(neg_pat)
            if neg_rel >= 0:
                # check immediate next word or find separately
                after_neg = post[neg_rel + 2 :]
                pos_rel2 = after_neg.find(pos_pat)
                if pos_rel2 == 0:
                    neg_off = idx + unit_rel + neg_rel
                    pos_off = neg_off + 2
                    candidates.append((idx, neg_off, pos_off))
                else:
                    # try find pos within next 8 bytes
                    pos_rel = post.find(pos_pat, max(0, neg_rel - 4), neg_rel + 12)
                    if pos_rel >= 0:
                        neg_off = idx + unit_rel + neg_rel
                        pos_off = idx + unit_rel + pos_rel
                        candidates.append((idx, neg_off, pos_off))
        start = idx + 1

    return candidates


@dataclass
class Backup:
    created_at: str
    connector: int
    port: int
    setup: Optional[int]
    header_hex: str
    analogue_hex: str
    parsed_hint: dict


def main() -> int:
    _ensure_32bit_python()
    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, required=True, help="DoPEOpenLink port number (e.g. 7 for COM7)")
    ap.add_argument("--baud", type=int, default=9600)
    ap.add_argument("--api", type=lambda s: int(s, 0), default=0x0289)
    ap.add_argument("--setup", type=int, default=None, help="Optional: DoPESelSetup number (1..4)")

    ap.add_argument("--connector", type=int, required=True, help="Sensor connector number (e.g. 85 for X21B)")
    ap.add_argument("--buf", type=int, default=8192, help="Raw buffer size for AnalogueData (must be large enough)")

    mode = ap.add_mutually_exclusive_group(required=True)
    mode.add_argument("--apply", action="store_true")
    mode.add_argument("--restore", type=str)

    ap.add_argument("--neglimit", type=int, default=150, help="New negative limit percent (WORD), e.g. 150")
    ap.add_argument("--poslimit", type=int, default=150, help="New positive limit percent (WORD), e.g. 150")
    ap.add_argument(
        "--nominal",
        type=float,
        default=None,
        help="Optional: set nominal (float32) in AnalogueData at the detected nominal offset",
    )

    ap.add_argument("--expect-nominal", type=float, default=1000.0, help="Expected nominal (float) to help locate fields")
    ap.add_argument("--expect-unit", type=int, default=7, help="Expected unit (WORD) to help locate fields")
    ap.add_argument("--expect-neglimit", type=int, default=110, help="Expected current NegLimit percent to help locate fields")
    ap.add_argument("--expect-poslimit", type=int, default=110, help="Expected current PosLimit percent to help locate fields")

    ap.add_argument("--backup", type=str, default=None, help="Backup JSON path (default: temp/backup_connector<id>_analogue.json)")
    ap.add_argument("--force", action="store_true", help="Write even if sensor key not pressed")
    ap.add_argument("--wait-key", action="store_true", help="Poll DoPERdSensorConKey until KeyPressed==1 before writing")

    args = ap.parse_args()

    dll = _load_dll()

    DoPESelSetup = _bind(dll, "DoPESelSetup", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.POINTER(ctypes.c_uint16)])

    DoPERdSensorConKey = _bind(
        dll,
        "DoPERdSensorConKey",
        [ctypes.c_void_p, ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint16), ctypes.POINTER(ctypes.c_uint16)],
    )
    DoPERdSensorHeaderData = _bind(dll, "DoPERdSensorHeaderData", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p])
    DoPERdSensorAnalogueData = _bind(dll, "DoPERdSensorAnalogueData", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p])
    DoPEWrSensorAnalogueData = _bind(dll, "DoPEWrSensorAnalogueData", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p])

    if DoPERdSensorConKey is None:
        raise SystemExit("DoPERdSensorConKey not found")
    if DoPERdSensorHeaderData is None:
        raise SystemExit("DoPERdSensorHeaderData not found")
    if DoPERdSensorAnalogueData is None or DoPEWrSensorAnalogueData is None:
        raise SystemExit("DoPERd/WrSensorAnalogueData not found")

    hdl = _open_link(dll, port=args.port, baud=args.baud, api_version=args.api)

    if args.setup is not None and DoPESelSetup is not None:
        err = int(DoPESelSetup(hdl, int(args.setup), None, None, None))
        print(f"DoPESelSetup({args.setup}) -> 0x{err:04x}")

    connected = ctypes.c_uint16(0)
    key = ctypes.c_uint16(0)
    err = int(DoPERdSensorConKey(hdl, int(args.connector), ctypes.byref(connected), ctypes.byref(key)))
    print(f"DoPERdSensorConKey(connector={args.connector}) -> 0x{err:04x} (connected={int(connected.value)}, key={int(key.value)})")

    # Read header (12 bytes is the typical aligned layout; we keep raw)
    hdr_buf = ctypes.create_string_buffer(64)
    errh = int(DoPERdSensorHeaderData(hdl, int(args.connector), ctypes.byref(hdr_buf)))
    print(f"DoPERdSensorHeaderData(connector={args.connector}) -> 0x{errh:04x}")

    # Parse header best-effort: <H B x I H B x (12 bytes)
    header_bytes = bytes(hdr_buf.raw[:12])
    parsed_header = {}
    try:
        partno, version, serno, klass, datver = struct.unpack("<H B x I H B x", header_bytes)
        parsed_header = {"PartNo": int(partno), "Version": int(version), "SerNo": int(serno), "Class": int(klass), "DatVersion": int(datver)}
        print(f"[hdr] {parsed_header}")
    except struct.error:
        print("[hdr] Could not parse header reliably; continuing with raw header bytes")

    # Read analogue data into a large raw buffer
    ana_buf = ctypes.create_string_buffer(int(args.buf))
    erra = int(DoPERdSensorAnalogueData(hdl, int(args.connector), ctypes.byref(ana_buf)))
    print(f"DoPERdSensorAnalogueData(connector={args.connector}) -> 0x{erra:04x}")
    if erra != 0:
        print("Analogue read failed; likely not an analogue sensor class.")
        return 30

    ana_blob = bytes(ana_buf.raw)

    backup_path = Path(args.backup) if args.backup else (Path(__file__).parent / f"backup_connector{args.connector}_analogue.json")

    if args.restore:
        bk = json.loads(Path(args.restore).read_text(encoding="utf-8"))
        ana_restore = bytes.fromhex(str(bk["analogue_hex"]))
        if len(ana_restore) != len(ana_blob):
            print(f"Backup analogue size={len(ana_restore)} differs from current buffer size={len(ana_blob)}; rerun with --buf {len(ana_restore)}")
            return 31
        ana_buf2 = ctypes.create_string_buffer(ana_restore, len(ana_restore))
        if args.wait_key and not args.force:
            print("Waiting for KeyPressed==1...")
            while True:
                connected = ctypes.c_uint16(0)
                key = ctypes.c_uint16(0)
                DoPERdSensorConKey(hdl, int(args.connector), ctypes.byref(connected), ctypes.byref(key))
                if int(key.value) == 1:
                    break
                time.sleep(0.1)
        errw = int(DoPEWrSensorAnalogueData(hdl, int(args.connector), ctypes.byref(ana_buf2)))
        print(f"DoPEWrSensorAnalogueData(restore connector={args.connector}) -> 0x{errw:04x}")
        return 0 if errw == 0 else 32

    # Apply: backup first
    bk = Backup(
        created_at=datetime.now().isoformat(timespec="seconds"),
        connector=int(args.connector),
        port=int(args.port),
        setup=int(args.setup) if args.setup is not None else None,
        header_hex=bytes(hdr_buf.raw).hex(),
        analogue_hex=ana_blob.hex(),
        parsed_hint={
            "expected": {
                "nominal": float(args.expect_nominal),
                "unit": int(args.expect_unit),
                "neglimit": int(args.expect_neglimit),
                "poslimit": int(args.expect_poslimit),
            },
            "header": parsed_header,
        },
    )
    backup_path.write_text(json.dumps(bk.__dict__, indent=2), encoding="utf-8")
    print(f"Backup written: {backup_path}")

    candidates = _find_candidate_offsets(
        ana_blob,
        nominal_f32=float(args.expect_nominal),
        unit_u16=int(args.expect_unit),
        neg_u16=int(args.expect_neglimit),
        pos_u16=int(args.expect_poslimit),
    )

    if not candidates:
        print("Could not locate NegLimit/PosLimit offsets in analogue blob (heuristic failed). No write performed.")
        return 40

    # If multiple, pick first but print all
    print("Candidates (nominal_off, neg_off, pos_off):", candidates[:8], ("..." if len(candidates) > 8 else ""))
    nominal_off, neg_off, pos_off = candidates[0]

    # Sanity: print current values
    cur_neg = _unpack_u16_at(ana_blob, neg_off)
    cur_pos = _unpack_u16_at(ana_blob, pos_off)
    cur_nom = float(struct.unpack_from("<f", ana_blob, nominal_off)[0])
    print(f"[before] Nominal={cur_nom:g} (at offset {nominal_off})")
    print(f"[before] NegLimit={cur_neg} PosLimit={cur_pos} (at offsets {neg_off}/{pos_off})")

    patched = bytearray(ana_blob)
    if args.nominal is not None:
        patched[nominal_off : nominal_off + 4] = _pack_f32(float(args.nominal))
    patched[neg_off : neg_off + 2] = _pack_u16(int(args.neglimit))
    patched[pos_off : pos_off + 2] = _pack_u16(int(args.poslimit))

    if args.nominal is not None:
        new_nom = float(struct.unpack_from("<f", patched, nominal_off)[0])
        print(f"[after ] Nominal={new_nom:g}")
    print(f"[after ] NegLimit={_unpack_u16_at(patched, neg_off)} PosLimit={_unpack_u16_at(patched, pos_off)}")

    # Optional: require key pressed unless --force
    if not args.force and int(key.value) != 1:
        print("KeyPressed is not 1; refusing to write without --force (or use --wait-key).")
        return 41

    if args.wait_key and int(key.value) != 1:
        print("Waiting for KeyPressed==1...")
        while True:
            connected = ctypes.c_uint16(0)
            key = ctypes.c_uint16(0)
            DoPERdSensorConKey(hdl, int(args.connector), ctypes.byref(connected), ctypes.byref(key))
            if int(key.value) == 1:
                break
            time.sleep(0.1)

    ana_buf3 = ctypes.create_string_buffer(bytes(patched), len(patched))
    errw = int(DoPEWrSensorAnalogueData(hdl, int(args.connector), ctypes.byref(ana_buf3)))
    print(f"DoPEWrSensorAnalogueData(apply connector={args.connector}) -> 0x{errw:04x}")
    if errw != 0:
        print(f"Write failed. You can restore later using the backup: {backup_path}")
        return 50

    # Re-read sensor info (if available) as a sanity check: nominal/limits should change
    DoPERdSensorInfo = _bind(dll, "DoPERdSensorInfo", [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_void_p])
    if DoPERdSensorInfo is not None:
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

        # In this project, force sensor on X21B is SensorNo=4.
        info_buf = ctypes.create_string_buffer(ctypes.sizeof(DoPESumSenInfo))
        erri = int(DoPERdSensorInfo(hdl, 4, ctypes.byref(info_buf)))
        print(f"DoPERdSensorInfo(sensor=4) -> 0x{erri:04x}")
        if erri == 0:
            info = DoPESumSenInfo.from_buffer_copy(info_buf.raw)
            print(
                f"[verify] connector={int(info.Connector)} unit={int(info.Unit)} "
                f"nominal={float(info.NominalValue):g} upper={float(info.UpperLimit):g} lower={float(info.LowerLimit):g}"
            )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
