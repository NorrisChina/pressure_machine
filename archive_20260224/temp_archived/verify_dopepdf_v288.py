"""Minimal smoke test for the DoPE.pdf-aligned ctypes interface.

This script does *not* require any of the UI code.

Examples:
  # Legacy COM/serial style open
  C:/Users/cho77175/Desktop/code/.venv/Scripts/python.exe temp/verify_dopepdf_v288.py --mode openlink --port 7 --baud 115200

  # Newer USB/LAN scan style open (DeviceID=0 opens the first responding EDC)
  C:/Users/cho77175/Desktop/code/.venv/Scripts/python.exe temp/verify_dopepdf_v288.py --mode deviceid --device-id 0

Notes:
- `--port` is 0-based for DoPEOpenLink (0=COM1, 7=COM8).
"""

from __future__ import annotations

import argparse
from pathlib import Path
import sys

# Ensure repo root is on sys.path when running from temp/
REPO_ROOT = Path(__file__).resolve().parent.parent
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from drivers.dope_dll_interface_dopepdf import DoPEDLLDoPEPdf


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--dll",
        type=Path,
        default=Path(__file__).resolve().parent.parent / "drivers" / "DoPE.dll",
        help="Path to DoPE.dll (default: drivers/DoPE.dll)",
    )
    ap.add_argument(
        "--mode",
        choices=["openlink", "deviceid", "functionid"],
        default="openlink",
        help="Which open function to use",
    )
    ap.add_argument("--port", type=int, default=7, help="0-based COM port (0=COM1)")
    ap.add_argument("--baud", type=int, default=115200, help="Baud rate")
    ap.add_argument("--device-id", type=int, default=0, help="EDC DeviceID (0 = first responding)")
    ap.add_argument("--function-id", type=int, default=0, help="EDC FunctionID")
    ap.add_argument("--setup", type=int, default=1, help="SetupNo for DoPESelSetup")
    args = ap.parse_args()

    dope = DoPEDLLDoPEPdf(str(args.dll))
    if not dope.loaded:
        print("DLL not loaded. Check --dll path.")
        return 2

    if args.mode == "openlink":
        print(f"Opening via DoPEOpenLink: port={args.port} (COM{args.port+1}), baud={args.baud}")
        err, hdl = dope.DoPEOpenLink(args.port, args.baud)
    elif args.mode == "deviceid":
        print(f"Opening via DoPEOpenDeviceID: device_id={args.device_id}")
        err, hdl = dope.DoPEOpenDeviceID(args.device_id)
    else:
        print(f"Opening via DoPEOpenFunctionID: function_id={args.function_id}")
        err, hdl = dope.DoPEOpenFunctionID(args.function_id)

    print(f"Open result: err=0x{err:04X}, hdl={hdl}")
    if err != 0 or not hdl:
        return 1

    try:
        err_init = dope.DoPEInitialize(hdl)
        print(f"DoPEInitialize: 0x{err_init:04X}")

        err_setup = dope.DoPESelSetup(hdl, args.setup)
        print(f"DoPESelSetup({args.setup}): 0x{err_setup:04X}")
    finally:
        err_close = dope.DoPECloseLink(hdl)
        print(f"DoPECloseLink: 0x{err_close:04X}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
