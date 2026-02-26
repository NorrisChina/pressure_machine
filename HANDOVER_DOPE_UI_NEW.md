# DoPE UI (Win7) — Handover

This handover is for **running the packaged EXE** on an offline Windows 7 machine. No Python installation is required.

## Deliverable

Copy the entire folder:

- `bundle_win7_no_python/`

Key files inside:

- `dope_ui_new.exe`
- `RUN_DOPE_UI_NEW.bat` (normal start)
- `RUN_DOPE_UI_NEW_DEBUG.bat` (captures console output)
- `drivers/DoPE.dll` and `drivers/DoDpx.dll`
- Logs written next to the EXE:
  - `dope_ui_new.log`
  - `dope_ui_new_faulthandler.log`

## Run (normal)

1) Power on the DoPE controller and connect the cable.
2) Double-click:
   - `RUN_DOPE_UI_NEW.bat`

Default is set to COM3 (`--port 3`).

## If UI does not open / flashes

1) Run:
   - `RUN_DOPE_UI_NEW_DEBUG.bat`
2) Check:
   - `run_debug_output.txt`
   - `dope_ui_new.log`
   - `dope_ui_new_faulthandler.log`

Typical cause on Win7 is missing VC++ runtime. Install **Visual C++ 2015–2022 Redistributable (x86)**.

## If connection fails (OpenLink failed)

Most common cause is wrong COM port. Try ports **1..8** manually.

Option A (recommended): edit the BAT

- Open `RUN_DOPE_UI_NEW.bat` in Notepad
- Change `--port 3` to `--port N` and save
- Try N = 1..8

Option B: run from a Command Prompt

- In `bundle_win7_no_python/`, run:
  - `dope_ui_new.exe --port 1`
  - `dope_ui_new.exe --port 2`
  - ...
  - `dope_ui_new.exe --port 8`

## Keithley (optional)

Keithley logging only starts when you:

- Enable the Keithley checkbox
- Select at least one channel
- Start the target cycles (logging is tied to cycles)

Quick health check (no UI):

- `dope_ui_new.exe --keithley-import-test`

If the Keithley CSV has only headers and no values:

- Check `dope_ui_new.log` for `[keithley]` errors
- Verify VISA is installed on the Win7 machine (NI-VISA / Keysight VISA)
- Verify the VISA resource string (example: `GPIB0::16::INSTR`)

## Notes for maintainers (archived)

Build/offline packaging scripts are archived under `archive_*/` on the build machine. The Win7 target machine only needs `bundle_win7_no_python/`.

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

## Author connetion: github.com:NorrisChina/pressure_machine.git

## Author Email: zcy1174955817@gmail.com