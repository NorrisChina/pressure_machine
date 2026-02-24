Demo scripts

- `console_demo.py`: Polls `StubDopeDriver` and prints sample outputs to the console.
- `ui_demo.py`: Launches the PySide6 UI pre-wired to `StubDopeDriver`.

Run from project root using the venv python (PowerShell):

```powershell
& .\.venv\Scripts\Activate.ps1
& .\.venv\Scripts\python.exe demo\console_demo.py
```

Or to launch the GUI demo:

```powershell
& .\.venv\Scripts\python.exe demo\ui_demo.py
```

If the real DOPE DLL is available and you want to test the GUI with it,
replace the driver instantiation in `demo/ui_demo.py` or run:

```powershell
& .\.venv\Scripts\python.exe -c "from drivers.dope_driver import DopeDriver; from ui.app import run_app; run_app(driver=DopeDriver())"
```
