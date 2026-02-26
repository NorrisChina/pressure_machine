@echo off
setlocal
cd /d %~dp0

echo === DoPE UI NEW debug launcher ===
echo Folder: %CD%
echo.

set QT_DEBUG_PLUGINS=1

echo Running dope_ui_new.exe ...
echo Output will be saved to: run_debug_output.txt
echo.

dope_ui_new.exe --port 3 1>run_debug_output.txt 2>&1

echo.
echo ExitCode: %ERRORLEVEL%
echo.
echo Check: run_debug_output.txt
echo And logs: dope_ui_new_faulthandler.log, dope_ui_new.log
echo.
pause
