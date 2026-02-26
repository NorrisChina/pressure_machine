#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Fix/override force zero (tare) for a DoPE sensor channel.

Problem this targets
- After an overload/emergency stop, the force reading at idle can start at a large non-zero value
  (e.g. -1374 N). This can be caused by a real mechanical offset (damage/permanent deformation)
  or an electronics drift/offset.

What this script can do
- Read current force from DoPEGetData
- Optionally run DoPEZeroCal (zero-offset drift compensation)
- Apply a working tare (DoPESetTare) so the current displayed force becomes ~0
- Optionally apply a persistent basic tare (DoPESetBasicTare) (stored in setup, survives power cycle)

Safety
- Only run this while the machine is unloaded (no external force).
- If the sensor is physically damaged, software tare only hides the offset; it does NOT restore accuracy.

Run (recommended)
- `.venv32\\Scripts\\python.exe .\\temp\\fix_force_zero.py --port 7 --sensor 1`

"""

from __future__ import annotations

import argparse
import ctypes
import os
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


class DoPEData(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Time", ctypes.c_double),
        ("SampleTime", ctypes.c_double),
        ("Position", ctypes.c_double),
        ("Force", ctypes.c_double),
        ("Extension", ctypes.c_double),
        ("SensorD", ctypes.c_double),
        ("Sensor4", ctypes.c_double),
        ("Sensor5", ctypes.c_double),
        ("Sensor6", ctypes.c_double),
        ("Sensor7", ctypes.c_double),
        ("Sensor8", ctypes.c_double),
        ("Sensor9", ctypes.c_double),
        ("Sensor10", ctypes.c_double),
        ("Status", ctypes.c_long),
        ("KeyActive", ctypes.c_uint16),
        ("KeyNew", ctypes.c_uint16),
        ("KeyGone", ctypes.c_uint16),
        ("Reserved", ctypes.c_byte * 64),
    ]


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


def _bind(dll: ctypes.WinDLL, name: str, argtypes: list, restype=ctypes.c_ulong):
    fn = getattr(dll, name, None)
    if fn is None:
        raise AttributeError(f"DoPE.dll does not export {name}")
    fn.argtypes = argtypes
    fn.restype = restype
    return fn


@dataclass
class DoPEApi:
    dll: ctypes.WinDLL

    DoPEOpenLink: ctypes._CFuncPtr
    DoPECloseLink: ctypes._CFuncPtr | None
    DoPESetNotification: ctypes._CFuncPtr | None
    DoPESelSetup: ctypes._CFuncPtr | None
    DoPEOn: ctypes._CFuncPtr | None
    DoPECtrlTestValues: ctypes._CFuncPtr | None
    DoPETransmitData: ctypes._CFuncPtr | None
    DoPEGetData: ctypes._CFuncPtr

    DoPEZeroCal: ctypes._CFuncPtr | None
    DoPESetTare: ctypes._CFuncPtr | None
    DoPEGetTare: ctypes._CFuncPtr | None
    DoPESetBasicTare: ctypes._CFuncPtr | None
    DoPEGetBasicTare: ctypes._CFuncPtr | None

    DoPERdSensorInfo: ctypes._CFuncPtr | None


def _load_api() -> DoPEApi:
    if not DLL_PATH.exists():
        raise FileNotFoundError(f"DLL not found: {DLL_PATH}")

    dll = ctypes.WinDLL(str(DLL_PATH))

    DoPEOpenLink = _bind(
        dll,
        "DoPEOpenLink",
        [
            ctypes.c_ulong,
            ctypes.c_ulong,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_ulong),
        ],
    )

    DoPECloseLink = None
    if hasattr(dll, "DoPECloseLink"):
        DoPECloseLink = _bind(dll, "DoPECloseLink", [ctypes.c_ulong])

    DoPESetNotification = None
    if hasattr(dll, "DoPESetNotification"):
        DoPESetNotification = _bind(
            dll,
            "DoPESetNotification",
            [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint],
        )

    DoPESelSetup = None
    if hasattr(dll, "DoPESelSetup"):
        DoPESelSetup = _bind(
            dll,
            "DoPESelSetup",
            [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_void_p,
                ctypes.POINTER(ctypes.c_ushort),
                ctypes.POINTER(ctypes.c_ushort),
            ],
        )

    DoPEOn = None
    if hasattr(dll, "DoPEOn"):
        # Working signature used elsewhere in this repo: (hdl, WORD* tan)
        DoPEOn = _bind(dll, "DoPEOn", [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)])

    DoPECtrlTestValues = None
    if hasattr(dll, "DoPECtrlTestValues"):
        DoPECtrlTestValues = _bind(dll, "DoPECtrlTestValues", [ctypes.c_ulong, ctypes.c_ushort])

    DoPETransmitData = None
    if hasattr(dll, "DoPETransmitData"):
        # Working signature used elsewhere in this repo: (hdl, enable, time, WORD* tan)
        DoPETransmitData = _bind(
            dll,
            "DoPETransmitData",
            [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_double, ctypes.POINTER(ctypes.c_ushort)],
        )

    DoPEGetData = _bind(dll, "DoPEGetData", [ctypes.c_ulong, ctypes.c_void_p])

    DoPEZeroCal = None
    if hasattr(dll, "DoPEZeroCal"):
        # Best-effort: match the pattern used by other DoPE exports (TAN pointer optional/nullable).
        # DoPE.pdf text says TAN is "not for Sync", but in practice many functions still accept it.
        DoPEZeroCal = _bind(dll, "DoPEZeroCal", [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_ushort)])

    DoPESetTare = None
    if hasattr(dll, "DoPESetTare"):
        DoPESetTare = _bind(dll, "DoPESetTare", [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_double])

    DoPEGetTare = None
    if hasattr(dll, "DoPEGetTare"):
        DoPEGetTare = _bind(dll, "DoPEGetTare", [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_double)])

    DoPESetBasicTare = None
    if hasattr(dll, "DoPESetBasicTare"):
        # DoPE.pdf: (hdl, sensorNo, mode, basicTare, tanFirst*, tanLast*)
        DoPESetBasicTare = _bind(
            dll,
            "DoPESetBasicTare",
            [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_ushort,
                ctypes.c_double,
                ctypes.POINTER(ctypes.c_ushort),
                ctypes.POINTER(ctypes.c_ushort),
            ],
        )

    DoPEGetBasicTare = None
    if hasattr(dll, "DoPEGetBasicTare"):
        DoPEGetBasicTare = _bind(
            dll,
            "DoPEGetBasicTare",
            [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_double)],
        )

    DoPERdSensorInfo = None
    if hasattr(dll, "DoPERdSensorInfo"):
        # Use safe raw-buffer calling style.
        DoPERdSensorInfo = _bind(dll, "DoPERdSensorInfo", [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p])

    return DoPEApi(
        dll=dll,
        DoPEOpenLink=DoPEOpenLink,
        DoPECloseLink=DoPECloseLink,
        DoPESetNotification=DoPESetNotification,
        DoPESelSetup=DoPESelSetup,
        DoPEOn=DoPEOn,
        DoPECtrlTestValues=DoPECtrlTestValues,
        DoPETransmitData=DoPETransmitData,
        DoPEGetData=DoPEGetData,
        DoPEZeroCal=DoPEZeroCal,
        DoPESetTare=DoPESetTare,
        DoPEGetTare=DoPEGetTare,
        DoPESetBasicTare=DoPESetBasicTare,
        DoPEGetBasicTare=DoPEGetBasicTare,
        DoPERdSensorInfo=DoPERdSensorInfo,
    )


def _basic_init(api: DoPEApi, hdl: ctypes.c_ulong, setup_no: int | None) -> None:
    if api.DoPESetNotification is not None:
        api.DoPESetNotification(hdl, 0xFFFFFFFF, None, None, 0)

    if setup_no is not None and api.DoPESelSetup is not None:
        tan_first = ctypes.c_ushort(0)
        tan_last = ctypes.c_ushort(0)
        err = int(api.DoPESelSetup(hdl, int(setup_no), None, ctypes.byref(tan_first), ctypes.byref(tan_last)))
        if err != 0:
            raise RuntimeError(f"DoPESelSetup({setup_no}) failed: 0x{err:04x}")

    if api.DoPEOn is not None:
        api.DoPEOn(hdl, None)

    if api.DoPECtrlTestValues is not None:
        api.DoPECtrlTestValues(hdl, 0)

    if api.DoPETransmitData is not None:
        err = int(api.DoPETransmitData(hdl, 1, 0.0, None))
        if err != 0:
            raise RuntimeError(f"DoPETransmitData failed: 0x{err:04x}")


def _read_sample(api: DoPEApi, hdl: ctypes.c_ulong) -> DoPEData:
    # Safe raw buffer read (avoid struct size mismatch crash)
    buf = ctypes.create_string_buffer(2048)
    api.DoPEGetData(hdl, ctypes.byref(buf))
    return DoPEData.from_buffer_copy(buf.raw[: ctypes.sizeof(DoPEData)])


def _value_for_sensor(data: DoPEData, sensor_no: int) -> float | None:
    """Best-effort mapping from SensorNo to DoPEData field.

    Notes
    - In DoPE.pdf/Delphi examples, the measuring data record has named channels
      (Position/Force/Extension and additional Sensor4..Sensor10 and SensorD).
    - Sensor numbering used by DoPESetTare/DoPERdSensorInfo is not always 1:1 with
      these fields; however in practice Sensor4..Sensor10 match their numbers.
    """

    sensor_no = int(sensor_no)
    if sensor_no == 0:
        return float(data.Position)
    if sensor_no == 1:
        # Common convention in this controller family: sensor 1 is the main force channel.
        return float(data.Force)
    if 4 <= sensor_no <= 10:
        return float(getattr(data, f"Sensor{sensor_no}"))
    if sensor_no in (13, 0x0D):
        return float(data.SensorD)
    return None


def _read_tare(api: DoPEApi, hdl: ctypes.c_ulong, sensor_no: int) -> tuple[float | None, float | None]:
    tare = None
    basic = None

    if api.DoPEGetTare is not None:
        val = ctypes.c_double(0.0)
        err = int(api.DoPEGetTare(hdl, int(sensor_no), ctypes.byref(val)))
        if err == 0:
            tare = float(val.value)

    if api.DoPEGetBasicTare is not None:
        val = ctypes.c_double(0.0)
        err = int(api.DoPEGetBasicTare(hdl, int(sensor_no), ctypes.byref(val)))
        if err == 0:
            basic = float(val.value)

    return tare, basic


def _read_sensor_info(api: DoPEApi, hdl: ctypes.c_ulong, sensor_no: int) -> DoPESumSenInfo | None:
    if api.DoPERdSensorInfo is None:
        return None
    buf = ctypes.create_string_buffer(256)
    err = int(api.DoPERdSensorInfo(hdl, int(sensor_no), ctypes.byref(buf)))
    if err != 0:
        return None
    return DoPESumSenInfo.from_buffer_copy(buf.raw[: ctypes.sizeof(DoPESumSenInfo)])


def _scan_sensors(api: DoPEApi, hdl: ctypes.c_ulong, max_sensors: int = 16) -> list[tuple[int, DoPESumSenInfo]]:
    out: list[tuple[int, DoPESumSenInfo]] = []
    for sensor_no in range(max_sensors):
        info = _read_sensor_info(api, hdl, sensor_no)
        if info is None:
            continue
        if float(info.UpperLimit) == 0.0 and float(info.LowerLimit) == 0.0 and float(info.NominalValue) == 0.0:
            continue
        out.append((sensor_no, info))
    return out


def main() -> int:
    _ensure_32bit_python()

    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, default=None, help="COM port number for DoPEOpenLink (e.g. 8 for COM8)")
    ap.add_argument(
        "--ports",
        type=str,
        default="8,7,6,5",
        help="Comma list of ports to try when --port is omitted (default: 8,7,6,5)",
    )
    ap.add_argument("--baud", type=int, default=9600, help="Baud rate")
    ap.add_argument("--api", type=lambda x: int(x, 0), default=0x0289, help="APIVersion (hex allowed)")
    ap.add_argument("--setup", type=int, default=None, help="Optional: call DoPESelSetup(setup) during init")

    ap.add_argument("--sensor", type=int, default=None, help="SensorNo to tare (0..15). If omitted, will scan and ask you to re-run with the right one.")
    ap.add_argument("--scan", action="store_true", help="Scan SensorInfo(0..15) and print limits/units.")

    ap.add_argument("--samples", type=int, default=10, help="Number of samples to average for baseline")
    ap.add_argument("--sleep", type=float, default=0.05, help="Sleep between samples (seconds)")

    ap.add_argument(
        "--print-samples",
        action="store_true",
        help="Print each sampled value for the selected sensor (useful to spot limit faults).",
    )

    ap.add_argument("--zero-cal", action="store_true", help="Call DoPEZeroCal for this sensor bit before taring")

    ap.add_argument("--set-tare", action="store_true", help="Apply working tare so current force becomes ~0")
    ap.add_argument("--tare", type=float, default=None, help="Explicit tare value to set (if omitted: use measured baseline)")
    ap.add_argument("--clear-tare", action="store_true", help="Set tare to 0")

    ap.add_argument("--set-basic-tare", action="store_true", help="Apply BasicTare (persistent). Use with care.")
    ap.add_argument("--basic-mode", type=int, default=1, help="BasicTare mode numeric (unknown from extracted PDF). Common guess: 0=SET, 1=SUBTRACT")
    ap.add_argument("--basic", type=float, default=None, help="BasicTare value (if omitted: use measured baseline)")

    args = ap.parse_args()

    api = _load_api()

    def _err_hint(code: int) -> str:
        # From extracted DoPE.pdf text (temp/DoPE_pdf_text.txt): low level comm errors
        hints = {
            0x8006: "Port open failed (invalid/blocked COM port)",
            0x8007: "Not enough heap memory (unlikely here)",
            0x8008: "Bad port / invalid device ID",
            0x8009: "Invalid baud rate",
            0x800A: "Device already in use (another app may be connected)",
            0x800B: "Device not present / no response (power/cable/port mismatch)",
            0x800C: "Connection not open",
        }
        if code in hints:
            return hints[code]
        if code == 5:
            # Sometimes returned on Windows as ACCESS_DENIED
            return "Windows error 5 (ACCESS_DENIED): port likely in use / permission"
        return ""

    ports_to_try: list[int]
    if args.port is not None:
        ports_to_try = [int(args.port)]
    else:
        ports_to_try = [int(p.strip()) for p in str(args.ports).split(",") if p.strip()]
        if not ports_to_try:
            ports_to_try = [8, 7, 6, 5]

    hdl = ctypes.c_ulong(0)
    last_err = None
    opened_port = None
    for p in ports_to_try:
        hdl = ctypes.c_ulong(0)
        err = int(api.DoPEOpenLink(p, args.baud, 10, 10, 10, int(args.api), None, ctypes.byref(hdl)))
        hint = _err_hint(err)
        msg = f"[{datetime.now().isoformat(timespec='seconds')}] DoPEOpenLink(port={p}, baud={args.baud}, api=0x{int(args.api):04x}) -> 0x{err:04x}, hdl={hdl.value}"
        if hint:
            msg += f"  ({hint})"
        print(msg)

        if err == 0 and hdl.value:
            opened_port = p
            break
        last_err = err

    if opened_port is None:
        print("\nFAILED to open DoPE link.")
        print("- If you see 0x800A: close any DoPE/EDC/TestCenter software and unplug/replug the USB-serial adapter.")
        print("- If you see 0x800B: check controller power, serial cable, and that you're using the correct COM port (often FTDI COMx).")
        return 1

    try:
        _basic_init(api, hdl, args.setup)

        # Let data pipeline settle.
        time.sleep(0.2)

        if args.scan:
            rows = _scan_sensors(api, hdl)
            print("\n[scan] Sensors with non-zero info:")
            for sensor_no, info in rows:
                print(
                    f"  sensor={sensor_no:2d} connector={int(info.Connector):3d} unit={int(info.Unit):3d} "
                    f"nom={float(info.NominalValue):g} upper={float(info.UpperLimit):g} lower={float(info.LowerLimit):g} "
                    f"offset={float(info.Offset):g} basicTare={float(info.BasicTare):g}"
                )
            print("\nTip: force channel is usually the one with plausible upper limit (100 / 1000 / 10000 N).")

        if args.sensor is None:
            if args.scan:
                return 0
            print("\nERROR: --sensor is required (or run with --scan first).")
            return 2

        sensor_no = int(args.sensor)

        info = _read_sensor_info(api, hdl, sensor_no)
        if info is not None:
            print(
                f"[info] sensor={sensor_no} connector={int(info.Connector)} unit={int(info.Unit)} "
                f"nom={float(info.NominalValue):g} upper={float(info.UpperLimit):g} lower={float(info.LowerLimit):g}"
            )

        old_tare, old_basic = _read_tare(api, hdl, sensor_no)
        print(f"[before] sensor={sensor_no} tare={old_tare} basicTare={old_basic}")

        # Baseline averaging
        forces: list[float] = []
        for _ in range(max(1, int(args.samples))):
            s = _read_sample(api, hdl)
            v = _value_for_sensor(s, sensor_no)
            if v is None:
                raise RuntimeError(
                    f"Cannot map --sensor {sensor_no} to a DoPEData field. "
                    "Try --scan to identify a sensor number in 0,1,4..10,13."
                )
            forces.append(float(v))
            if args.print_samples:
                status = int(getattr(s, "Status", 0))
                print(f"  sample value={float(v):.6f}  (Status={status})")
            time.sleep(max(0.0, float(args.sleep)))
        baseline = sum(forces) / len(forces)
        print(f"[before] baseline_avg={baseline:.6f} (from {len(forces)} samples)")

        if info is not None:
            upper = float(info.UpperLimit)
            lower = float(info.LowerLimit)
            if baseline > upper or baseline < lower:
                print(f"[warn] baseline is outside limits: {lower:g} .. {upper:g}")

        if args.zero_cal:
            if api.DoPEZeroCal is None:
                print("[zero-cal] DoPEZeroCal not exported by DLL")
            else:
                sensor_bits = 1 << sensor_no
                err_z = int(api.DoPEZeroCal(hdl, int(sensor_bits), None))
                print(f"[zero-cal] DoPEZeroCal(sensorBits=0x{sensor_bits:04x}) -> 0x{err_z:04x}")
                time.sleep(0.3)

        if args.clear_tare:
            if api.DoPESetTare is None:
                print("[tare] DoPESetTare not exported by DLL")
            else:
                err_t = int(api.DoPESetTare(hdl, sensor_no, 0.0))
                print(f"[tare] DoPESetTare(sensor={sensor_no}, tare=0.0) -> 0x{err_t:04x}")

        if args.set_tare:
            if api.DoPESetTare is None:
                print("[tare] DoPESetTare not exported by DLL")
            else:
                tare_to_set = float(args.tare) if args.tare is not None else float(baseline)
                err_t = int(api.DoPESetTare(hdl, sensor_no, tare_to_set))
                print(f"[tare] DoPESetTare(sensor={sensor_no}, tare={tare_to_set:.6f}) -> 0x{err_t:04x}")

        if args.set_basic_tare:
            if api.DoPESetBasicTare is None:
                print("[basic-tare] DoPESetBasicTare not exported by DLL")
            else:
                basic_to_set = float(args.basic) if args.basic is not None else float(baseline)
                mode = int(args.basic_mode)
                err_b = int(api.DoPESetBasicTare(hdl, sensor_no, mode, basic_to_set, None, None))
                print(
                    f"[basic-tare] DoPESetBasicTare(sensor={sensor_no}, mode={mode}, basic={basic_to_set:.6f}) -> 0x{err_b:04x}"
                )

        # Re-read
        time.sleep(0.2)
        new_tare, new_basic = _read_tare(api, hdl, sensor_no)
        print(f"[after] sensor={sensor_no} tare={new_tare} basicTare={new_basic}")

        forces2: list[float] = []
        for _ in range(max(1, int(args.samples))):
            s = _read_sample(api, hdl)
            v = _value_for_sensor(s, sensor_no)
            if v is None:
                break
            forces2.append(float(v))
            if args.print_samples:
                status = int(getattr(s, "Status", 0))
                print(f"  sample value={float(v):.6f}  (Status={status})")
            time.sleep(max(0.0, float(args.sleep)))
        baseline2 = sum(forces2) / len(forces2)
        print(f"[after] baseline_avg={baseline2:.6f} (from {len(forces2)} samples)")

        if info is not None and forces2:
            upper = float(info.UpperLimit)
            lower = float(info.LowerLimit)
            if baseline2 > upper or baseline2 < lower:
                print(f"[warn] after baseline is outside limits: {lower:g} .. {upper:g}")

        return 0

    finally:
        try:
            if api.DoPECloseLink is not None and hdl.value:
                api.DoPECloseLink(hdl)
        except Exception:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
