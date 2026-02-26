param(
  [switch]$WithKeithley
)

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

function Get-Py38x86Command {
  # Prefer Python Launcher
  try {
    $out = & py -3.8-32 -c "import sys,struct; print('OK %d.%d %d' % (sys.version_info[0], sys.version_info[1], 8*struct.calcsize('P')))" 2>&1
    if ($LASTEXITCODE -eq 0 -and ($out -match '^OK 3\.8 32')) {
      return 'py -3.8-32'
    }
  } catch {
  }

  $candidates = @(
    "$env:LocalAppData\Programs\Python\Python38-32\python.exe",
    "C:\Python38-32\python.exe"
  )
  foreach ($p in $candidates) {
    if (Test-Path $p) {
      return ('"' + $p + '"')
    }
  }

  return $null
}

function Ensure-Python38x86 {
  $cmd = Get-Py38x86Command
  if ($cmd) { return $cmd }

  Write-Host "[WARN] Python 3.8 (32-bit) not installed. Using embeddable Python (no-install) for packaging..." -ForegroundColor Yellow

  $toolsDir = Join-Path $PSScriptRoot 'tools'
  New-Item -ItemType Directory -Force -Path $toolsDir | Out-Null

  $embedDir = Join-Path $toolsDir 'python38-embed-win32'
  $pythonExe = Join-Path $embedDir 'python.exe'

  if (-not (Test-Path $pythonExe)) {
    # Download embeddable zip
    $zipUrl = 'https://www.python.org/ftp/python/3.8.10/python-3.8.10-embed-win32.zip'
    $zipPath = Join-Path $toolsDir 'python-3.8.10-embed-win32.zip'
    Write-Host "[INFO] Downloading embeddable Python: $zipUrl"
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

    if (Test-Path $embedDir) { Remove-Item -Recurse -Force $embedDir }
    New-Item -ItemType Directory -Force -Path $embedDir | Out-Null

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $embedDir)

    # Enable site-packages by uncommenting 'import site' in python38._pth
    $pth = Join-Path $embedDir 'python38._pth'
    if (Test-Path $pth) {
      $lines = Get-Content $pth
      $lines = $lines | ForEach-Object { $_ -replace '^#import site$', 'import site' }
      Set-Content -Encoding ASCII -Path $pth -Value $lines
    }

    # Bootstrap pip
    $getPipUrl = 'https://bootstrap.pypa.io/pip/3.8/get-pip.py'
    $getPip = Join-Path $toolsDir 'get-pip-3.8.py'
    Write-Host "[INFO] Downloading get-pip: $getPipUrl"
    Invoke-WebRequest -Uri $getPipUrl -OutFile $getPip
    Write-Host "[INFO] Installing pip into embeddable Python..."
    & $pythonExe $getPip
  }

  # Validate interpreter
  $out = & $pythonExe -c "import sys,struct; print('OK %d.%d %d' % (sys.version_info[0], sys.version_info[1], 8*struct.calcsize('P')))" 2>&1
  if ($LASTEXITCODE -ne 0 -or -not ($out -match '^OK 3\.8 32')) {
    throw "Embeddable Python validation failed: $out"
  }

  return ('"' + $pythonExe + '"')
}

Write-Host "[INFO] Preparing Win7 no-Python bundle..."
$py38 = Ensure-Python38x86
Write-Host "[OK] Using: $py38"

Write-Host "[INFO] Building EXE (PyInstaller)..."
$buildArgs = @('-ExecutionPolicy','Bypass','-File','build_exe_win7_py38_x86.ps1','-PythonExe', $py38)
if ($WithKeithley) { $buildArgs += '-WithKeithley' }

powershell @buildArgs

# Create a clean bundle folder for copying to offline Win7.
$src = Join-Path $PSScriptRoot 'dist\dope_ui_new'
if (-not (Test-Path $src)) {
  # onefile case
  $srcExe = Join-Path $PSScriptRoot 'dist\dope_ui_new.exe'
  if (Test-Path $srcExe) {
    $bundle = Join-Path $PSScriptRoot 'bundle_win7_no_python'
    New-Item -ItemType Directory -Force -Path $bundle | Out-Null
    Copy-Item -Force $srcExe (Join-Path $bundle 'dope_ui_new.exe')
  } else {
    throw "Build output not found under dist/."
  }
} else {
  $bundle = Join-Path $PSScriptRoot 'bundle_win7_no_python'
  if (Test-Path $bundle) { Remove-Item -Recurse -Force $bundle }
  Copy-Item -Recurse -Force $src $bundle
}

# Add a simple run helper.
$runBat = Join-Path $bundle 'RUN_DOPE_UI_NEW.bat'
@'
@echo off
setlocal
cd /d %~dp0
dope_ui_new.exe --port 3
'@ | Set-Content -Encoding ASCII -Path $runBat

# Add a debug run helper (captures output so the window does not disappear).
$runDebugBat = Join-Path $bundle 'RUN_DOPE_UI_NEW_DEBUG.bat'
@'
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
'@ | Set-Content -Encoding ASCII -Path $runDebugBat

Write-Host "[OK] Bundle ready: $bundle"
Write-Host "[NEXT] Copy the whole folder to the offline Win7 machine and run RUN_DOPE_UI_NEW.bat (or dope_ui_new.exe)."
