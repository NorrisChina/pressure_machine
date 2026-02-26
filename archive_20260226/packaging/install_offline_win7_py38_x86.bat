@echo off
setlocal

REM Offline install for Windows 7 using Python 3.8.x (32-bit / x86).
REM Prereq: Python 3.8.x (x86) installed and `python` available in PATH.

cd /d %~dp0

if not exist wheelhouse_win7_py38_x86 (
  echo [ERROR] Missing folder: wheelhouse_win7_py38_x86
  echo Build it on an online machine using:
  echo   powershell -ExecutionPolicy Bypass -File build_wheelhouse_win7_py38_x86.ps1
  echo Then copy repo + wheelhouse folder to this Win7 PC.
  pause
  exit /b 1
)

if not exist .venv32\Scripts\python.exe (
  echo [INFO] Creating .venv32 (32-bit)...
  python -m venv .venv32
)

echo [INFO] Installing packages from local wheelhouse...
echo [INFO] Default: UI-only (PyQt5)
.venv32\Scripts\pip.exe install --no-index --find-links wheelhouse_win7_py38_x86 PyQt5

echo.
set /p WITHKEI="Install Keithley dependencies too (pyvisa)? [y/N]: "
if /I "%WITHKEI%"=="y" (
  if exist requirements_ui_min.txt (
    echo [INFO] Installing from requirements_ui_min.txt...
    .venv32\Scripts\pip.exe install --no-index --find-links wheelhouse_win7_py38_x86 -r requirements_ui_min.txt
  ) else (
    echo [WARN] requirements_ui_min.txt not found; skipping.
  )
)

echo [INFO] Starting UI...
.venv32\Scripts\python.exe dope_ui_new.py

exit /b %ERRORLEVEL%
