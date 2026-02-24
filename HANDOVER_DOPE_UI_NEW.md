# DoPE Control Panel (New) — Handover Notes

Owner / Component
- File: `dope_ui_new.py`
- UI tech: PyQt5
- Hardware interface: `drivers/DoPE.dll` via `ctypes`
- Primary purpose: live monitoring + jogging + target cycles + optional Keithley 2700 logging + DigiPoti manual control

> This document is written for a new engineer who needs to run, debug, and safely modify the control panel.

## 1) Quick start

### 1.1 Preconditions
- Windows machine with access to the DoPE controller.
- `drivers/DoPE.dll` present and compatible with the controller firmware.
- Python environments:
  - **32-bit Python** to load the **32-bit DoPE.dll**.
  - Optionally a **64-bit Python** environment for Keithley/NI‑VISA (see section 6).

### 1.2 How to run
- Preferred: run the script directly; it will auto-relaunch with 32-bit Python if configured.

Commands (from repo root):
- 32-bit UI:
  - `./.venv32/Scripts/python.exe dope_ui_new.py`
- If you accidentally run with 64-bit Python:
  - the script attempts to re-launch itself via `./.venv32/Scripts/python.exe` and exits.

### 1.3 What to expect
- On success, the right pane shows live values:
  - SampleTime
  - Position (displayed in **mm**, relative to an auto-zero origin)
  - Force (value depends on selected range/channel)
  - Range
- All log messages also append to `dope_ui_new.log`.
- Fatal crashes (e.g., access violations) are captured in `dope_ui_new_faulthandler.log`.

## 2) UX overview (what each section does)

### Status (right side)
- Shows live values.
- Origin behavior:
  - On the **first valid sample**, the UI auto-sets the origin so displayed Position starts at **0 mm**.
  - You can later press **Set Origin** to reset origin at the current absolute position.

### Step1 Setup
- **Range**: 100 N / 1000 N / 10 kN
  - Range affects which sensor channel is treated as the force channel for supervision/logging.
  - 10 kN additionally triggers a **setup switch** via `DoPESelSetup(SETUP_10KN)`.
- **Apply Pull/Push Limits**:
  - Configures thresholds and enables **software auto-stop** in the sampling loop.
  - Convention used:
    - Pull (tension) is **positive**.
    - Push (compression) is **negative**.

### Press & Hold Move
- Press and hold **Move Up** / **Move Down**:
  - Calls `DoPEFMove(Direction, MoveCtrl=0, Speed)`.
  - Speed input is in **mm/s**, converted to **m/s** before calling the DLL.
- Releasing the button calls **Stop**, which halts motion.

### Target Move (Cycles)
- Inputs:
  - Target Position in **µm** (relative to origin)
  - Speed in **µm/s**
  - Cycles count
  - Frequency (Hz): affects the sampling/log density while cycles are active
- Behavior:
  - Runs a simple state machine: `origin -> target -> origin -> ...`
  - Uses `DoPEPos` (position move) if available.
  - Logs per-sample rows to `temp/target_cycles_YYYYmmdd_HHMMSS.csv`.

### Manual Move (DigiPoti)
- **Manual Speed**: speed mode (often EXT_SPEED_UP_DOWN / Mode=5)
  - Uses a two-stage “safe start” strategy:
    1) Wait until knob is centered & stable
    2) Arm speed mode with MaxSpeed=0
    3) After first intentional movement beyond DxTrigger, re-enable with the real MaxSpeed
- **Manual Position**: position mode
  - Tries Mode=0 then Mode=4 fallback (device config dependent)

### Stop / Disconnect
- **Stop**:
  - Cancels pending DigiPoti activation
  - Aborts cycles (and closes CSV logs)
  - Calls `DoPEHalt` (if available) and then `DoPEFMove(HALT)`
- **Disconnect**:
  - Stops motion and background sampling
  - Calls `DoPEHalt` (best-effort) and `DoPECloseLink`
  - Disables the UI

## 3) Data model and units (common source of bugs)

### 3.1 Sampling structure
- `DoPEGetData` writes a binary struct; this UI decodes it into `DoPEData`.
- To reduce crashes from ABI mismatches, reads go into a **1024-byte raw buffer** and then slice into the expected struct size.

### 3.2 Units
- Absolute position from DoPE is treated as **meters**.
- Displayed Position:
  - relative to origin
  - displayed as **mm** (meters * 1000)
- UI inputs:
  - Target Position: **µm**
  - Target Speed: **µm/s**
- DLL calls:
  - `DoPEPos(Destination)` uses absolute position in **meters**
  - `DoPEPos(Speed)` and `DoPEFMove(Speed)` use **m/s**

## 4) Threading and re-entrancy

- Background thread: `update_data_loop`
  - Polls `DoPEGetData`
  - Emits `sig_data` (Qt signal) for UI updates
  - Applies software force limit auto-stop
  - Implements DigiPoti arming logic
- UI thread:
  - Updates labels
  - Runs cycle state machine (`_cycle_on_sample`) when samples arrive

**Rule:** treat the vendor DLL as not thread-safe. Every DLL call must be under `self._dll_lock`.

## 5) Range selection + force channel selection

Why this exists:
- Different setups expose different sensor channels.
- Software limits and “Force:” display should use the force-like sensor.

Mechanism:
- Calls `DoPERdSensorInfo` for channels 0..15.
- Chooses the channel whose `UpperLimit` best matches the chosen range.
- Stores it in `self._force_sensor_no`.

If selection fails:
- Falls back to `data.Force`.

## 6) Keithley 2700 logging

Goal:
- Log resistance values from Keithley 2700 during target cycles.

Two modes:
1) Preferred: 64-bit helper subprocess (works with NI-VISA 64-bit)
   - Looks for helper at: `temp/keithley_2700_stream.py`
   - Uses 64-bit python at: `./.venv/Scripts/python.exe`
   - Helper emits JSON lines to stdout; UI reads them and writes `temp/keithley_*.csv`

2) Fallback: in-process polling (32-bit)
   - Requires `pyvisa` (and a working VISA backend in 32-bit)
   - Uses best-effort SCPI commands (`MEAS:RES?`, `MEAS:FRES?`, `READ?`)

Typical problems:
- VISA resource string wrong (e.g. `GPIB0::17::INSTR`).
- NI-VISA not installed / driver mismatch.
- SCPI commands differ by installed Keithley option cards.

## 7) Force limits and auto-stop

This UI implements **software supervision** in `update_data_loop`:
- After each sample:
  - if pull limit reached (Force >= pull_set): auto-stop
  - if push limit reached (Force <= push_set): auto-stop
- Uses hysteresis (reset threshold is 2% closer to zero).

Important:
- This is *not* a certified safety function.
- It is intended as a convenience stop to prevent overshoot.

## 8) DigiPoti details (manual control)

Key facts:
- Uses `DoPEFDPoti`.
- Uses `SensorD` as the knob feedback channel.

Why “safe start” exists for speed mode:
- Without it, switching to speed mode can immediately cause motion if the knob is not exactly centered.

If you need to change behavior:
- The arming logic lives in `update_data_loop`.
- Keep the principle: **never start speed mode with non-zero velocity unless the operator intentionally moves the knob**.

## 9) Files and artifacts

- Runtime logs:
  - `dope_ui_new.log` — UI log (append-only)
  - `dope_ui_new_faulthandler.log` — crash/traceback log for fatal faults
- Output CSV:
  - `temp/target_cycles_*.csv` — per-sample position/force during cycles
  - `temp/keithley_*.csv` — Keithley resistance samples (if enabled)

## 10) Troubleshooting checklist

### UI starts but shows no data
- Confirm DoPE controller connected and correct COM settings.
- Check UI log for `DoPEOpenLink` error codes.

### Crash / access violation
- Check `dope_ui_new_faulthandler.log`.
- Confirm you are using 32-bit Python and the correct DLL.
- Suspect struct/packing mismatch if crash occurs near `DoPEGetData`.

### Motion commands do nothing
- Confirm `DoPEOn` succeeded.
- Confirm correct setup selected.
- Check return codes from `DoPEFMove` / `DoPEPos`.

### DigiPoti speed causes immediate motion
- Verify the two-stage safe start is still active.
- Confirm `DPOT_DEAD_ZONE_SPEED` is not set to 0.

### Keithley logging does not work
- Confirm VISA resource string.
- Confirm NI-VISA/Keysight VISA installation.
- Confirm helper script exists if you expect subprocess mode.

## 11) Safe modification guidelines

- Keep DLL calls under `self._dll_lock`.
- Don’t tighten polling intervals aggressively.
- When adding new DLL bindings, define `argtypes` and `restype` explicitly.
- Prefer raw-buffer decoding for DLL structs when unsure about ABI.
- Treat `Stop` as sacred: modifications must not make it less reliable.
https://download.tek.com/manual/2700-900-01K_Feb_2016.pdf

## 12) Open items / suggested follow-ups (optional)

- Add a short README explaining how `.venv32` is created and pinned.
- Provide / check-in `temp/keithley_2700_stream.py` if Keithley logging is required.
- Consider moving COM/baud/settings into a config file to avoid hard-coding.
