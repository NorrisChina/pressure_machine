#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Keithley 2700 resistance streamer (stdout JSON lines).

Designed to be launched from a 32-bit UI process as a 64-bit subprocess.
It repeatedly reads resistance on multiple channels and prints JSON per sample.

Example:
  python temp/keithley_2700_stream.py --resource GPIB0::17::INSTR --channels 1,2,3,4 --frequency 2

Output format (one line per sample):
  {"wall_time_s": 0.500123, "iso_time": "...", "values": {"1": 12.3, "2": null, ...}}
"""

from __future__ import annotations

import argparse
import json
import sys
import time
from datetime import datetime
from typing import Optional


def _parse_channels(text: str) -> list[int]:
    parts = [p.strip() for p in (text or "").split(",") if p.strip()]
    out: list[int] = []
    for p in parts:
        try:
            out.append(int(p))
        except Exception:
            raise argparse.ArgumentTypeError(f"Invalid channel: {p!r}")
    out = sorted(set(out))
    if not out:
        raise argparse.ArgumentTypeError("No channels provided")
    return out


def _now_iso() -> str:
    return datetime.now().isoformat(timespec="milliseconds")


def _read_resistance_best_effort(inst, scpi_ch: int) -> Optional[float]:
    try:
        inst.write(f"ROUT:CLOS (@{int(scpi_ch)})")
    except Exception:
        pass

    cmds = [
        f"MEAS:RES? (@{int(scpi_ch)})",
        "MEAS:RES?",
        f"MEAS:FRES? (@{int(scpi_ch)})",
        "MEAS:FRES?",
        "READ?",
    ]

    for cmd in cmds:
        try:
            resp = inst.query(cmd)
            if resp is None:
                continue
            s = str(resp).strip()
            if not s:
                continue
            token = s.split(",")[0].strip()
            val = float(token)
            if abs(val) > 9e36:
                return None
            return val
        except Exception:
            continue

    return None


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(add_help=True)
    ap.add_argument("--resource", required=True, help="VISA resource string")
    ap.add_argument("--channels", type=_parse_channels, required=True, help="Comma-separated channels")
    ap.add_argument("--frequency", type=float, default=2.0, help="Sampling frequency (Hz)")
    ap.add_argument("--duration", type=float, default=0.0, help="Duration (s). 0 = run until killed")
    ap.add_argument("--timeout", type=int, default=2000, help="VISA timeout (ms)")
    ap.add_argument("--no-map", action="store_true", help="Do not map 1..20 to 101..120")
    ap.add_argument("--map-base", type=int, default=100, help="Mapping base (default 100 => 1->101)")
    ns = ap.parse_args(argv)

    try:
        import pyvisa  # type: ignore
    except Exception as e:
        sys.stderr.write(f"pyvisa import failed: {e}\n")
        return 2

    freq = float(ns.frequency)
    if freq <= 0:
        sys.stderr.write("frequency must be > 0\n")
        return 2
    period = 1.0 / freq

    channels = list(ns.channels)
    if not ns.no_map:
        scpi_channels = [int(ns.map_base) + int(ch) for ch in channels]
    else:
        scpi_channels = [int(ch) for ch in channels]

    rm = None
    inst = None
    start = time.perf_counter()
    next_sample = start

    try:
        rm = pyvisa.ResourceManager()
        inst = rm.open_resource(str(ns.resource).strip())
        try:
            inst.timeout = int(ns.timeout)
        except Exception:
            pass

        try:
            inst.write("*CLS")
        except Exception:
            pass

        # identify (optional)
        try:
            idn = str(inst.query("*IDN?")).strip()
            if idn:
                sys.stderr.write(f"IDN: {idn}\n")
        except Exception:
            pass

        while True:
            now = time.perf_counter()
            wall = now - start
            if ns.duration and wall >= float(ns.duration):
                break

            if now < next_sample:
                time.sleep(min(0.02, next_sample - now))
                continue

            values = {}
            for ch_ui, ch_scpi in zip(channels, scpi_channels):
                v = _read_resistance_best_effort(inst, int(ch_scpi))
                values[str(int(ch_ui))] = v

            obj = {
                "wall_time_s": float(wall),
                "iso_time": _now_iso(),
                "values": values,
            }
            sys.stdout.write(json.dumps(obj, ensure_ascii=False) + "\n")
            sys.stdout.flush()

            next_sample += max(0.01, period)

        return 0

    finally:
        try:
            if inst is not None:
                inst.close()
        except Exception:
            pass
        try:
            if rm is not None:
                rm.close()
        except Exception:
            pass


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
