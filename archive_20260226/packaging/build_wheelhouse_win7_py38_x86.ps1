param(
  [switch]$WithKeithley
)

$ErrorActionPreference = 'Stop'

# Build an offline wheelhouse for Windows 7 using Python 3.8 (32-bit / win32 wheels).
# Run this on a newer Windows machine that has Internet.
# Output folder: .\wheelhouse_win7_py38_x86

Set-Location -Path $PSScriptRoot

$dest = Join-Path $PSScriptRoot 'wheelhouse_win7_py38_x86'
New-Item -ItemType Directory -Force -Path $dest | Out-Null

# Choose requirements:
# - UI-only: PyQt5 only (smallest)
# - With Keithley: use requirements_ui_min.txt (PyQt5 + pyvisa)
$reqArgs = @()
if ($WithKeithley) {
  $reqFile = Join-Path $PSScriptRoot 'requirements_ui_min.txt'
  if (-not (Test-Path $reqFile)) { throw "Missing requirements file: $reqFile" }
  $reqArgs = @('-r', $reqFile)
} else {
  $reqArgs = @('PyQt5')
}

Write-Host "[INFO] Destination: $dest"
Write-Host "[INFO] Mode: " -NoNewline
if ($WithKeithley) { Write-Host "WithKeithley (PyQt5 + pyvisa)" } else { Write-Host "UI-only (PyQt5)" }

# Use pip download with target tags (no need to have Python 3.8 installed on this machine).
# Notes:
# - win32 wheels are required because Win7 will run 32-bit Python.
# - For CPython 3.8, tags are roughly: cp38-cp38-win32
# - If a package no longer provides win32/cp38 wheels, this will fail with
#   "No matching distribution".

$python = 'python'

$commonArgs = @(
  '-m','pip','download',
  '-d', $dest,
  '--only-binary', ':all:',
  '--platform', 'win32',
  '--python-version', '38',
  '--implementation', 'cp',
  '--abi', 'cp38'
)

Write-Host "[INFO] Running pip download..."
& $python @commonArgs @reqArgs

Write-Host "[OK] Wheelhouse ready: $dest"
Write-Host "[NEXT] Copy the repo folder + $dest to the Win7 machine."
