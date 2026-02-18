#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Keithley 2700 resistance logger (standalone).

Goal
- Connect to a Keithley 2700 over VISA (typically GPIB)
- Read multiple channels repeatedly for a fixed duration
- Write timestamped resistance values to CSV

Notes
- This script is "best effort" because exact SCPI behavior depends on options/cards.
- For reliable GPIB on Windows, install a VISA implementation (NI-VISA or Keysight VISA).
  PyVISA alone is not enough; it needs a backend.

Examples
  # Log channels 1,2,3 for 30 seconds (mapped to SCPI 101,102,103)
  python temp/keithley_2700_log.py --resource GPIB0::16::INSTR --channels 1,2,3 --duration 30 --interval 0.5

  # If your scanner uses native SCPI channel numbers already:
  python temp/keithley_2700_log.py --resource GPIB0::16::INSTR --channels 101,102,103 --duration 10 --no-map

  # List VISA resources (requires backend)
  python temp/keithley_2700_log.py --list
"""

from __future__ import annotations

import argparse
import csv
import sys
import time
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Optional


@dataclass(frozen=True)
class Config:
    resource: str
    channels: list[int]
    duration_s: float
    interval_s: float
    timeout_ms: int
    map_channels: bool
    map_base: int
    out_csv: Path
    backend: str  # "" (default), "@py" (pyvisa-py)


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


def _rm_open(backend: str):
    import pyvisa  # type: ignore

    if backend:
        return pyvisa.ResourceManager(backend)

    try:
        return pyvisa.ResourceManager()
    except Exception as e_default:
        # Fallback to pyvisa-py backend.
        try:
            rm = pyvisa.ResourceManager("@py")
        except Exception as e_py:
            raise RuntimeError(
                "Could not locate a VISA backend. Install NI-VISA/Keysight VISA (recommended for GPIB) "
                "or install pyvisa-py.\n"
                f"Default backend error: {e_default}\n"
                f"pyvisa-py backend error: {e_py}"
            )
        else:
            print(f"[info] Using pyvisa-py backend (@py); default backend failed: {e_default}")
            return rm


def _query_idn(inst) -> Optional[str]:
    for cmd in ("*IDN?",):
        try:
            resp = inst.query(cmd)
            s = str(resp).strip()
            return s if s else None
        except Exception:
            continue
    return None


def _read_resistance_best_effort(inst, scpi_ch: int) -> Optional[float]:
    # Try to close/select the channel (if supported)
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
    last_err: Optional[Exception] = None
    for cmd in cmds:
        try:
            resp = inst.query(cmd)
            if resp is None:
                continue
            s = str(resp).strip()
            if not s:
                continue

            # Sometimes returns comma-separated fields; take first token
            token = s.split(",")[0].strip()
            val = float(token)

            # Overrange sentinel
            if abs(val) > 9e36:
                return None
            return val
        except Exception as e:
            last_err = e
            continue

    if last_err is not None:
        raise last_err
    return None


def _build_scpi_channels(cfg: Config) -> list[int]:
    if not cfg.map_channels:
        return list(cfg.channels)
    # map 1..20 -> 100+index
    out = []
    for ch in cfg.channels:
        out.append(int(cfg.map_base) + int(ch))
    return out


def run(cfg: Config) -> int:
    try:
        import pyvisa  # noqa: F401  # type: ignore
    except Exception as e:
        print(f"[error] pyvisa import failed: {e}")
        print("Install in your env: pip install pyvisa")
        return 2

    rm = None
    inst = None

    scpi_channels = _build_scpi_channels(cfg)
    if len(scpi_channels) != len(cfg.channels):
        print("[error] Internal channel mapping mismatch")
        return 2

    cfg.out_csv.parent.mkdir(parents=True, exist_ok=True)

    try:
        rm = _rm_open(cfg.backend)
        inst = rm.open_resource(cfg.resource)
        try:
            inst.timeout = int(cfg.timeout_ms)
        except Exception:
            pass

        try:
            inst.write("*CLS")
        except Exception:
            pass

        idn = _query_idn(inst)
        if idn:
            print(f"[info] *IDN?: {idn}")
        else:
            print("[info] *IDN? not available (continuing)")

        print(
            f"[info] Logging: resource={cfg.resource!r}, duration={cfg.duration_s:.2f}s, interval={cfg.interval_s:.2f}s, "
            f"channels={cfg.channels} -> scpi={scpi_channels}"
        )
        print(f"[info] CSV: {cfg.out_csv}")

        with cfg.out_csv.open("w", newline="", encoding="utf-8") as fp:
            w = csv.writer(fp)
            header = ["wall_time_s", "iso_time"]
            for ch in cfg.channels:
                header.append(f"r_ch{int(ch)}_ohm")
            w.writerow(header)

            start = time.perf_counter()
            next_sample = start

            while True:
                now = time.perf_counter()
                wall = now - start
                if wall > cfg.duration_s:
                    break

                if now < next_sample:
                    time.sleep(min(0.02, next_sample - now))
                    continue

                iso = _now_iso()
                row = [f"{wall:.6f}", iso]

                # Read all channels for this sample
                for scpi_ch in scpi_channels:
                    try:
                        v = _read_resistance_best_effort(inst, scpi_ch)
                    except Exception as e:
                        # Put blank on error, but keep going
                        print(f"[warn] read failed on SCPI ch {scpi_ch}: {e}")
                        v = None

                    row.append("" if v is None else f"{float(v):.9f}")

                w.writerow(row)
                fp.flush()

                next_sample += max(0.01, cfg.interval_s)

        print("[info] Done")
        return 0

    except Exception as e:
        print(f"[error] {e}")
        return 1

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


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(add_help=True)
    ap.add_argument("--list", action="store_true", help="List VISA resources and exit")
    ap.add_argument("--resource", default="GPIB0::16::INSTR", help="VISA resource string")
    ap.add_argument("--channels", type=_parse_channels, default="1", help="Comma-separated channel list")
    ap.add_argument("--duration", type=float, default=10.0, help="Logging duration (seconds)")
    ap.add_argument("--interval", type=float, default=0.5, help="Sampling interval (seconds)")
    ap.add_argument("--timeout", type=int, default=2000, help="VISA timeout (ms)")
    ap.add_argument("--no-map", action="store_true", help="Do not map 1..20 to 101..120")
    ap.add_argument("--map-base", type=int, default=100, help="Mapping base (default 100 => 1->101)")
    ap.add_argument(
        "--backend",
        default="",
        help='Force backend, e.g. "@py" for pyvisa-py. Default: auto (try system VISA, then @py).',
    )
    ap.add_argument(
        "--out",
        default="",
        help="Output CSV path. Default: temp/keithley_2700_log_YYYYMMDD_HHMMSS.csv",
    )

    ns = ap.parse_args(argv)

    try:
        import pyvisa  # type: ignore
    except Exception as e:
        print(f"[error] pyvisa import failed: {e}")
        print("Install: pip install pyvisa")
        return 2

    if ns.list:
        try:
            rm = _rm_open(ns.backend)
            try:
                res = rm.list_resources()
            finally:
                rm.close()
            print("Resources:")
            for r in res:
                print(f"  {r}")
            if not res:
                print("  (none)")
            return 0
        except Exception as e:
            print(f"[error] list failed: {e}")
            return 1

    out = ns.out.strip() if isinstance(ns.out, str) else ""
    if out:
        out_csv = Path(out)
    else:
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        out_csv = Path(__file__).resolve().parent / f"keithley_2700_log_{ts}.csv"

    cfg = Config(
        resource=str(ns.resource).strip(),
        channels=list(ns.channels),
        duration_s=float(ns.duration),
        interval_s=max(0.01, float(ns.interval)),
        timeout_ms=int(ns.timeout),
        map_channels=(not bool(ns.no_map)),
        map_base=int(ns.map_base),
        out_csv=out_csv,
        backend=str(ns.backend or "").strip(),
    )

    if not cfg.resource:
        print("[error] --resource is required")
        return 2

    if cfg.duration_s <= 0:
        print("[error] --duration must be > 0")
        return 2

    return run(cfg)


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
