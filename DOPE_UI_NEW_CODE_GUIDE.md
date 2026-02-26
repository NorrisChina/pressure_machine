# DoPE UI (Win7) — Code Guide

Scope
- This document explains how `dope_ui_new.py` works at a code-structure level.
- The runtime deliverable is the packaged folder `bundle_win7_no_python/`.

## 1) Entry points and runtime layout

### Source entry
- `dope_ui_new.py` is the application entry.
- It builds a PyQt5 UI and talks to the vendor DLL via `ctypes`.

### Frozen (EXE) runtime
- When built with PyInstaller, the code runs in “frozen” mode.
- The base directory for runtime IO is:
  - script run: the folder containing `dope_ui_new.py`
  - frozen run: the folder containing `dope_ui_new.exe`

Key helper:
- `_app_base_dir()` → `APP_DIR`

Files written at runtime (next to EXE):
- `dope_ui_new.log`
- `dope_ui_new_faulthandler.log`
- CSV outputs under `temp/`

## 2) Hardware connection (DoPE)

### DLL loading
- Vendor DLL is expected at: `APP_DIR/drivers/DoPE.dll`.
- The DLL is treated as not thread-safe; all calls are serialized with a re-entrant lock.

### Connection parameters
- The DoPE link is opened via `DoPEOpenLink(port, baud, api, ...)`.
- Startup parameters are resolved by `_startup_connection_params(argv)`:
  1) CLI args: `--port`, `--baud`, `--api`
  2) Environment: `DOPE_PORT`, `DOPE_BAUD`, `DOPE_API`
  3) Defaults: `port=3`, `baud=9600`, `api=0x0289`

Port parsing supports `3` or `COM3`.

## 3) Threading model

Two main execution contexts:

### UI thread (Qt)
- Owns all widgets.
- Receives samples via a Qt signal and updates labels.
- Runs the cycle state machine per sample during automated motion.

### Background sampler thread
- Continuously calls the DLL polling function (DoPEGetData) to receive new samples.
- Emits the latest decoded data to the UI thread.

Safety rule:
- Any call into the vendor DLL must be under `self._dll_lock`.

## 4) Target cycles + CSV logging

The cycle feature implements an “origin ↔ target” loop.

Flow (high-level):
1) User starts cycles from the UI.
2) A per-run CSV is created under `temp/`.
3) Each valid sample appends one CSV row.
4) The state machine switches between phases `to_target` and `to_origin` when the position is within a tolerance for N consecutive samples.

Key methods:
- `start_target_cycles()`
- `_cycle_on_sample(...)`
- `_stop_target_cycles(aborted=...)`

## 5) Keithley 2700 logging

Keithley logging is optional and “best-effort”. It is tied to cycles:
- It starts only when cycles start AND Keithley is enabled AND at least one channel is selected.

Two modes exist:

### Preferred: 64-bit helper subprocess
- Helper script: `temp/keithley_2700_stream.py`
- Intended to be launched using a 64-bit Python (`.venv/Scripts/python.exe`) so NI-VISA 64-bit can be used.
- The helper prints one JSON line per sample to stdout.
- The UI reads those JSON lines, writes a Keithley CSV, and also keeps an in-memory “latest value” snapshot.

### Fallback: in-process polling
- Runs inside the same process (32-bit) and uses `pyvisa` directly.
- Requires:
  - `pyvisa` to be present in the packaged EXE
  - a working VISA backend on the machine (NI-VISA / Keysight VISA)

Self-test (packaged EXE):
- `dope_ui_new.exe --keithley-import-test` verifies `pyvisa` is importable.

## 6) Common failure signatures

### DoPE connection failures
- Often caused by wrong COM port selection.
- Resolution is operational (try port 1..8), not code changes.

### Keithley CSV has headers only
Typical causes:
- Keithley logging not started (checkbox/channels/cycles not enabled)
- VISA resource string empty or wrong
- VISA backend missing on the machine
- `pyvisa` missing from the packaged EXE (fixed by building with Keithley support)

## 7) Packaging notes (for maintainers)

The Win7 deliverable is produced via PyInstaller (Python 3.8 x86).
- All packaging scripts and older experiments are archived under `archive_20260226/`.
- The target Win7 machine should only need the folder `bundle_win7_no_python/`.
