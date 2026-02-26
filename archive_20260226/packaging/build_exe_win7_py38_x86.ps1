param(
  [switch]$WithKeithley,
  [switch]$OneFile,
  [string]$PythonExe
)

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

# Build a Windows 7 compatible EXE (no Python needed on target).
# IMPORTANT:
# - Must be built with Python 3.8 x86 (32-bit), because:
#   - Win7 does not support Python 3.12+
#   - DoPE.dll is 32-bit
#
# Prereqs on THIS build machine:
# - A Python 3.8.x (x86 / 32-bit) interpreter available.
#   - Either installed (via `py -3.8-32`)
#   - Or a portable interpreter passed via -PythonExe

$pyCmd = $null
if ($PythonExe -and $PythonExe.Trim().Length -gt 0) {
  $pyCmd = $PythonExe
} else {
  $pyCmd = 'py -3.8-32'
}

Write-Host "[INFO] Checking Python 3.8 x86 availability..."
try {
  $out = & $pyCmd -c "import sys,struct; print('OK %d.%d %d' % (sys.version_info[0], sys.version_info[1], 8*struct.calcsize('P')))" 2>&1
  if ($LASTEXITCODE -ne 0 -or -not ($out -match '^OK 3\.8 32')) {
    throw "Python 3.8 x86 check failed: $out"
  }
  $out | Out-String | Write-Host
} catch {
  Write-Host "[ERROR] Could not run a valid Python 3.8 x86 interpreter." -ForegroundColor Red
  Write-Host "Tried: $pyCmd" -ForegroundColor Yellow
  Write-Host "Provide -PythonExe <path-to-python.exe> (3.8 32-bit) or install Python 3.8 x86 so `py -3.8-32` works." -ForegroundColor Yellow
  exit 1
}

if ($PythonExe -and $PythonExe.Trim().Length -gt 0) {
  # Portable/embeddable Python path provided. Do not use venv (embeddable may not include it).
  $python = $pyCmd

  Write-Host "[INFO] Installing build dependencies (PyInstaller) into portable Python..."
  & $python -m pip install --upgrade pip
  & $python -m pip install "pyinstaller>=5,<6"

  Write-Host "[INFO] Installing runtime dependencies into portable Python..."
  & $python -m pip install PyQt5
  if ($WithKeithley) {
    & $python -m pip install pyvisa
  }
} else {
  # Installed Python via py launcher: use an isolated venv.
  $venv = Join-Path $PSScriptRoot '.venv_build_py38_x86'
  if (-not (Test-Path $venv)) {
    Write-Host "[INFO] Creating build venv: $venv"
    & $pyCmd -m venv $venv
  }

  $pip = Join-Path $venv 'Scripts\pip.exe'
  $python = Join-Path $venv 'Scripts\python.exe'

  Write-Host "[INFO] Installing build dependencies (PyInstaller)..."
  & $pip install --upgrade pip
  & $pip install "pyinstaller>=5,<6"

  Write-Host "[INFO] Installing runtime dependencies into build venv..."
  & $pip install PyQt5
  if ($WithKeithley) {
    & $pip install pyvisa
  }
}

# Ensure temp output folder exists at runtime (next to exe)
New-Item -ItemType Directory -Force -Path (Join-Path $PSScriptRoot 'temp') | Out-Null

$modeArgs = @('--noconfirm', '--clean')
if ($OneFile) {
  $modeArgs += @('--onefile')
} else {
  $modeArgs += @('--onedir')
}

# Keithley support relies on dynamic import of pyvisa inside a worker thread.
# Help PyInstaller include it reliably when requested.
$hiddenImports = @()
if ($WithKeithley) {
  $hiddenImports += @('--hidden-import', 'pyvisa')
}

# Bundle vendor DLLs and helper script.
$addData = @(
  '--add-data', 'drivers\DoPE.dll;drivers',
  '--add-data', 'drivers\DoDpx.dll;drivers',
  '--add-data', 'temp\keithley_2700_stream.py;temp'
)

Write-Host "[INFO] Building EXE via PyInstaller..."
& $python -m PyInstaller @modeArgs @hiddenImports @addData --name dope_ui_new dope_ui_new.py

Write-Host "[OK] Build complete. Output in .\dist\dope_ui_new\ (or .\dist\dope_ui_new.exe for onefile)."
Write-Host "[NEXT] Copy dist output to Win7; install VC++ x86 runtime if needed; run the EXE."
