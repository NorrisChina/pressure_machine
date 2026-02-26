@echo off
setlocal

REM Run DoPE Control Panel (New) on Windows 7.
REM This project requires 32-bit Python because DoPE.dll is 32-bit.

cd /d %~dp0

if exist .venv32\Scripts\python.exe (
  echo [INFO] Using .venv32\Scripts\python.exe
  .venv32\Scripts\python.exe dope_ui_new.py
  exit /b %ERRORLEVEL%
)

echo [ERROR] .venv32 not found.
echo.
echo Install Python 3.8.x (32-bit / x86) on this Win7 machine, then run:
echo   python -m venv .venv32
echo   .venv32\Scripts\pip.exe install -r requirements_ui_min.txt
echo.
echo Then run this .bat again.
echo.
pause
exit /b 1
