#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DoPE control panel (new).

This file implements a PyQt5-based control panel for a DoPE controller via
`drivers/DoPE.dll` using `ctypes`.

High-level goals
----------------
- Provide a small, self-contained UI for:
    - live status (sample time, position, force)
    - press-and-hold jogging (up/down)
    - target position cycles with CSV recording
    - optional Keithley 2700 resistance logging (best-effort)
    - DigiPoti manual control (speed/position) with a "safe start" strategy

Key safety and reliability notes
-------------------------------
- The vendor DLL is treated as *not thread-safe*. All DLL calls are serialized
    with a re-entrant lock (`self._dll_lock`).
- The DLL is 32-bit. If this script runs under 64-bit Python, it will try to
    re-launch itself with `./.venv32/Scripts/python.exe` and exit.
- `faulthandler` is enabled to capture fatal crashes (e.g. access violations)
    caused by bad struct layouts or DLL bugs. Logs go to
    `dope_ui_new_faulthandler.log`.
- Units are easy to mix up:
    - DoPE position values are treated as meters (m) as returned by the DLL.
    - UI displays millimeters (mm) and micrometers (µm) depending on the widget.
    - DoPE speeds are passed as meters/second (m/s) to the DLL.

Operating model
---------------
- UI thread:
    - owns all widgets
    - processes samples via a Qt signal (`sig_data`) and updates labels
    - runs the cycle-state machine (`_cycle_on_sample`) on each sample
- Background thread (`update_data_loop`):
    - polls `DoPEGetData` at a low rate by default
    - polls faster while cycles are active
    - enforces software force limits and handles DigiPoti "arming" logic

Handover
--------
See the handover document generated for this component for setup, workflows,
and troubleshooting guidance.
"""

from __future__ import annotations

import sys
import os
import subprocess
import ctypes
import csv
import threading
import time
import json
import faulthandler
import argparse
from pathlib import Path
from datetime import datetime
from PyQt5 import QtWidgets, QtCore

def _app_base_dir() -> Path:
    """Return the directory used for runtime file IO.

    - Normal script run: repo root (this file's directory)
    - PyInstaller frozen build: directory containing the executable
    """
    if getattr(sys, "frozen", False):
        return Path(sys.executable).resolve().parent
    return Path(__file__).resolve().parent


APP_DIR = _app_base_dir()
DLL_PATH = APP_DIR / "drivers" / "DoPE.dll"


def _parse_com_port(value: str) -> int:
    v = str(value).strip()
    if not v:
        raise ValueError("empty port")
    if v.upper().startswith("COM"):
        v = v[3:]
    return int(v)


def _startup_connection_params(argv: list[str]) -> tuple[int, int, int]:
    """Resolve connection parameters for DoPEOpenLink.

    Priority:
    1) CLI args: --port / --baud / --api
    2) Environment: DOPE_PORT / DOPE_BAUD / DOPE_API
    3) Defaults: port=7 baud=9600 api=0x0289
    """
    default_port = 3
    default_baud = 9600
    default_api = 0x0289

    ap = argparse.ArgumentParser(add_help=False)
    ap.add_argument("--port", type=str, default=None)
    ap.add_argument("--baud", type=int, default=None)
    ap.add_argument("--api", type=str, default=None)

    try:
        ns, _ = ap.parse_known_args(argv)
    except Exception:
        ns = argparse.Namespace(port=None, baud=None, api=None)

    port_raw = ns.port or os.environ.get("DOPE_PORT")
    baud_raw = ns.baud or os.environ.get("DOPE_BAUD")
    api_raw = ns.api or os.environ.get("DOPE_API")

    port = default_port
    if port_raw is not None:
        try:
            port = _parse_com_port(str(port_raw))
        except Exception:
            port = default_port

    baud = default_baud
    if baud_raw is not None:
        try:
            baud = int(baud_raw)
        except Exception:
            baud = default_baud

    api = default_api
    if api_raw is not None:
        try:
            api = int(str(api_raw), 0)
        except Exception:
            api = default_api

    return int(port), int(baud), int(api)

# Capture fatal crashes (e.g. access violation from ctypes/DLL) to a log file.
try:
    _fh_path = APP_DIR / "dope_ui_new_faulthandler.log"
    faulthandler.enable(open(_fh_path, "a", buffering=1), all_threads=True)
except Exception:
    pass

# Prefer 32-bit Python for the 32-bit DoPE.dll.
# When running as a PyInstaller-frozen EXE, do not attempt any Python relaunch.
if (not getattr(sys, "frozen", False)) and sys.maxsize > 2**32:
    venv32_python = os.path.join(os.path.dirname(__file__), ".venv32", "Scripts", "python.exe")
    if os.path.exists(venv32_python):
        subprocess.call([venv32_python, __file__] + sys.argv[1:])
        raise SystemExit(0)

class DoPEData(ctypes.Structure):
    """Raw sample structure returned by `DoPEGetData`.

    Important:
    - `_pack_ = 1` is required to match the vendor ABI.
    - This layout is based on the working manual DigiPoti scripts in this repo
      and has been verified on the target device (Position/Force/SensorD).
    - Do **not** reorder or change field types unless you also validate against
      the actual DLL/firmware; a mismatch can cause wrong readings or crashes.
    """
    _pack_ = 1
    _fields_ = [
           # NOTE: This layout matches the working manual DigiPoti scripts in this repo.
           # It has been verified on your device to read correct Position/Force/SensorD.
           ("Time", ctypes.c_double),
           ("SampleTime", ctypes.c_double),
           ("Position", ctypes.c_double),
           ("Force", ctypes.c_double),
           ("Extension", ctypes.c_double),
           ("SensorD", ctypes.c_double),
           ("Sensor4", ctypes.c_double),
           ("Sensor5", ctypes.c_double),
           ("Sensor6", ctypes.c_double),
           ("Sensor7", ctypes.c_double),
           ("Sensor8", ctypes.c_double),
           ("Sensor9", ctypes.c_double),
           ("Sensor10", ctypes.c_double),
           ("Status", ctypes.c_long),
           ("KeyActive", ctypes.c_uint16),
           ("KeyNew", ctypes.c_uint16),
           ("KeyGone", ctypes.c_uint16),
           ("Reserved", ctypes.c_byte * 64),
    ]


class DoPESumSenInfo(ctypes.Structure):
    """Sensor metadata returned by `DoPERdSensorInfo`.

    Used primarily for:
    - scanning candidate force channels (by UpperLimit)
    - reading configured limits for the X21B autofix logic

    The DLL call is bound as `void*` and then decoded from a raw buffer to
    reduce the chance of ctypes ABI mismatches crashing the process.
    """
    _pack_ = 1
    _fields_ = [
        ("Connector", ctypes.c_uint16),
        ("NominalValue", ctypes.c_double),
        ("Unit", ctypes.c_uint16),
        ("Offset", ctypes.c_double),
        ("UpperLimit", ctypes.c_double),
        ("LowerLimit", ctypes.c_double),
        ("SensorState", ctypes.c_uint16),
        ("McType", ctypes.c_uint16),
        ("UpperSoftLimit", ctypes.c_double),
        ("LowerSoftLimit", ctypes.c_double),
        ("SoftLimitReaction", ctypes.c_uint16),
        ("BasicTare", ctypes.c_double),
    ]

class DopeUINew(QtWidgets.QWidget):
    """Main Qt widget implementing the DoPE control panel.

    Signals
    -------
    sig_log: str
        Thread-safe logging. Background threads emit log lines via this signal.
    sig_data: object, object, object
        Emits `(sample_time_s, position_abs_m, force_value)` and is handled on
        the UI thread.

    Concurrency model
    -----------------
    - The DoPE vendor DLL is assumed not to be thread-safe. All access is
      serialized via `self._dll_lock`.
    - A background thread polls the controller and emits `sig_data`.
    - All widget updates must happen on the UI thread.

    Safety
    ------
    - `Stop` halts motion, aborts cycles, and exits DigiPoti modes.
    - Software force limits can auto-stop motion (Halt + Move=HALT).
    """
    sig_log = QtCore.pyqtSignal(str)
    sig_data = QtCore.pyqtSignal(object, object, object)  # sample_time, position, force

    def __init__(self):
        super().__init__()
        self.setWindowTitle("DoPE Control Panel (New)")
        self.setGeometry(100, 100, 700, 400)

        # Setup numbers (adjust to match your EDC configuration)
        self.SETUP_10KN = 1

        # DoPE.dll calls are not guaranteed thread-safe; serialize all calls.
        self._dll_lock = threading.RLock()

        # Movement constants (used by stop_move/apply_range_selection even during init).
        # DoPE manual: Direction: 0=halt, 1=up, 2=down (as used in this project)
        self.MOVE_HALT = 0
        self.MOVE_UP = 1
        self.MOVE_DOWN = 2
        # MoveCtrl: 0 = position control (used throughout this UI)
        self.CTRL_POS = 0

        # Position origin (absolute position at which UI displays 0)
        self._pos_zero_abs = None
        self._last_position_abs = None

        # Target Move cycles + logging
        self._cycle_active = False
        self._cycle_total = 0
        self._cycle_index = 0
        self._cycle_phase = ""
        self._cycle_target_rel_mm = 0.0
        self._cycle_speed_mm_s = 0.0
        self._cycle_origin_abs_m = 0.0
        self._cycle_start_perf = 0.0
        self._cycle_tol_mm = 0.10
        self._cycle_settle_samples = 3
        self._cycle_settle_count = 0
        self._cycle_log_fp = None
        self._cycle_log_writer = None
        self._cycle_log_path = None
        self._cycle_log_last_flush_perf = 0.0
        self._cycle_freq_hz = 2.0

        # Keithley 2700 (GPIB/VISA) logging (best-effort)
        self._kei_thread = None
        self._kei_stop_evt = None
        self._kei_latest_lock = threading.Lock()
        self._kei_latest = {}  # channel_index(1-20) -> resistance_ohm
        self._kei_channels_active: list[int] = []
        self._kei_last_err_log_ts = 0.0
        self._kei_proc = None
        self._kei_proc_reader_thread = None
        self._kei_proc_stderr_thread = None

        self._kei_log_fp = None
        self._kei_log_writer = None
        self._kei_log_path = None
        self._kei_start_perf = 0.0
        self._kei_log_last_flush_perf = 0.0

        # Runtime state (for sampling + DigiPoti safe activation)
        self._last_sensor_d = None
        # Force-channel sensor number (best-effort; set by range scan)
        self._force_sensor_no = None
        self._range_selection = None  # "100N" | "1kN" | "10kN"
        # Software force limits (auto stop)
        self._force_limit_enabled = False
        self._force_pull_set = 0.0
        self._force_pull_reset = 0.0
        self._force_push_set = 0.0   # negative value
        self._force_push_reset = 0.0 # negative value
        self._force_limit_tripped = False
        self._force_limit_last_trip_ts = 0.0
        self._dpot_speed_pending = False
        self._dpot_speed_pending_baseline = None
        self._dpot_speed_pending_max_speed_m_s = None
        self._dpot_speed_pending_dz = None
        self._dpot_speed_pending_started_at = None
        # Two-stage activation for speed mode:
        # 1) Arm DoPEFDPoti with MaxSpeed=0 to avoid initial movement.
        # 2) After the knob moves beyond DxTrigger, re-issue DoPEFDPoti with target MaxSpeed.
        self._dpot_speed_armed = False
        self._dpot_speed_armed_baseline = None
        self._dpot_speed_armed_dz = None
        self._dpot_speed_armed_target_max_speed_m_s = None
        self._dpot_speed_last_log_ts = 0.0
        self._sensor_d_history: list[float] = []

        # Connection parameters (overridable via CLI/env)
        self._conn_port, self._conn_baud, self._conn_api = _startup_connection_params(sys.argv[1:])

        self.init_ui()
        self.sig_log.connect(self.log)
        self.sig_data.connect(self._update_labels)
        try:
            ok = self.init_dope()
        except Exception as e:
            ok = False
            try:
                self.log(f"[init] init_dope crashed: {e}")
            except Exception:
                pass
            try:
                QtWidgets.QMessageBox.critical(self, "Initialization failed", f"init_dope crashed:\n{e}")
            except Exception:
                pass
        self._running = bool(ok)
        if ok:
            self._thread = threading.Thread(target=self.update_data_loop, daemon=True)
            self._thread.start()
        else:
            self._thread = None

    def _update_labels(self, dt_s, position, load):
        """Update UI labels from the latest sample.

        This method is executed on the UI thread because it is connected to the
        `sig_data` Qt signal.

        Parameters
        ----------
        dt_s:
            SampleTime as reported by DoPE (seconds). Can be None on errors.
        position:
            Absolute position from DoPE (meters). Displayed as relative mm.
        load:
            Force value (engineering units depend on selected sensor). The UI
            treats it as a float and prints it; it may be N for typical setups.
        """
        try:
            if dt_s is None:
                self.lbl_sampletime.setText("SampleTime: --")
            else:
                self.lbl_sampletime.setText(f"SampleTime: {float(dt_s):.2f}")
        except Exception:
            self.lbl_sampletime.setText("SampleTime: --")

        try:
            if position is None:
                self.lbl_position.setText("Position: -- mm")
            else:
                pos_abs = float(position)
                self._last_position_abs = pos_abs
                # Auto-zero on first valid sample so UI starts at Position=0
                if self._pos_zero_abs is None:
                    self._pos_zero_abs = pos_abs
                pos_rel = pos_abs - float(self._pos_zero_abs or 0.0)
                pos_rel_mm = pos_rel * 1000.0
                self.lbl_position.setText(f"Position: {pos_rel_mm:.3f} mm")
        except Exception:
            self.lbl_position.setText("Position: -- mm")

        try:
            if load is None:
                self.lbl_force.setText("Force: --")
            else:
                self.lbl_force.setText(f"Force: {float(load):.4f}")
        except Exception:
            self.lbl_force.setText("Force: --")

        # Cycle runner + recording (runs on UI thread via signal)
        try:
            self._cycle_on_sample(position, load)
        except Exception:
            pass

    def init_ui(self):
        """Build the UI layout and bind all button callbacks.

        The panel is organized into:
        - Step1 Setup: select range and force limits
        - Press & Hold Move: jogging at a given speed
        - Target Move: cycle runner (target <-> origin) with CSV logging
        - Manual Move: DigiPoti speed/position modes
        - Status + Log: live values and persistent logging
        """
        main_layout = QtWidgets.QHBoxLayout()
        left_col = QtWidgets.QVBoxLayout()
        right_col = QtWidgets.QVBoxLayout()

        # Status
        param_group = QtWidgets.QGroupBox("Status")
        param_layout = QtWidgets.QGridLayout()
        self.lbl_sampletime = QtWidgets.QLabel("SampleTime: --")
        self.lbl_position = QtWidgets.QLabel("Position: -- mm")
        self.lbl_force = QtWidgets.QLabel("Force: --")
        self.lbl_range = QtWidgets.QLabel("Range: --")
        param_layout.addWidget(self.lbl_sampletime, 0, 0)
        param_layout.addWidget(self.lbl_position, 1, 0)
        param_layout.addWidget(self.lbl_force, 2, 0)
        param_layout.addWidget(self.lbl_range, 3, 0)
        param_group.setLayout(param_layout)
        right_col.addWidget(param_group)

        # Log
        self.log_label = QtWidgets.QLabel("Log")
        self.log_label.setStyleSheet("font-weight: bold;")
        self.log_text = QtWidgets.QTextEdit()
        self.log_text.setReadOnly(True)
        self.log_text.setMinimumWidth(320)
        right_col.addWidget(self.log_label)
        right_col.addWidget(self.log_text)

        # Step1 Setup: range + pull/push limits
        setup_group = QtWidgets.QGroupBox("Step1 Setup")
        setup_layout = QtWidgets.QGridLayout()
        setup_layout.addWidget(QtWidgets.QLabel("Range:"), 0, 0)
        self.range_combo = QtWidgets.QComboBox()
        self.range_combo.addItems(["100 N", "1000 N", "10 kN"])
        setup_layout.addWidget(self.range_combo, 0, 1)
        self.btn_apply_range = QtWidgets.QPushButton("Apply Range")
        self.btn_apply_range.clicked.connect(self.apply_range_selection)
        setup_layout.addWidget(self.btn_apply_range, 0, 2)

        setup_layout.addWidget(QtWidgets.QLabel("Max Pull (+):"), 1, 0)
        self.pull_limit_input = QtWidgets.QDoubleSpinBox()
        self.pull_limit_input.setRange(0.0, 1e9)
        self.pull_limit_input.setDecimals(3)
        self.pull_limit_input.setValue(0.0)
        setup_layout.addWidget(self.pull_limit_input, 1, 1)

        setup_layout.addWidget(QtWidgets.QLabel("Max Push (-):"), 2, 0)
        self.push_limit_input = QtWidgets.QDoubleSpinBox()
        self.push_limit_input.setRange(0.0, 1e9)
        self.push_limit_input.setDecimals(3)
        self.push_limit_input.setValue(0.0)
        setup_layout.addWidget(self.push_limit_input, 2, 1)

        self.btn_apply_force_limits = QtWidgets.QPushButton("Apply Pull/Push Limits")
        self.btn_apply_force_limits.clicked.connect(self.apply_force_limits)
        setup_layout.addWidget(self.btn_apply_force_limits, 3, 0, 1, 3)

        setup_group.setLayout(setup_layout)
        left_col.addWidget(setup_group)

        # Press & hold move
        speed_group = QtWidgets.QGroupBox("Press & Hold Move")
        speed_layout = QtWidgets.QGridLayout()
        speed_layout.addWidget(QtWidgets.QLabel("Speed (mm/s):"), 0, 0)
        self.speed_input = QtWidgets.QSpinBox()
        self.speed_input.setRange(1, 100)
        self.speed_input.setValue(10)
        speed_layout.addWidget(self.speed_input, 0, 1)

        self.btn_up = QtWidgets.QPushButton("▲ Move Up")
        self.btn_down = QtWidgets.QPushButton("▼ Move Down")
        self.btn_up.pressed.connect(self.move_up)
        self.btn_down.pressed.connect(self.move_down)
        self.btn_up.released.connect(self.stop_move)
        self.btn_down.released.connect(self.stop_move)
        speed_layout.addWidget(self.btn_up, 1, 0, 1, 2)
        speed_layout.addWidget(self.btn_down, 2, 0, 1, 2)
        speed_group.setLayout(speed_layout)
        left_col.addWidget(speed_group)

        # Target move
        pos_group = QtWidgets.QGroupBox("Target Move")
        pos_layout = QtWidgets.QGridLayout()
        pos_layout.addWidget(QtWidgets.QLabel("Target Position (µm):"), 0, 0)
        self.pos_input = QtWidgets.QDoubleSpinBox()
        # Keep the same physical range as before (±100 mm) but expose it as µm.
        self.pos_input.setRange(-100_000, 100_000)
        self.pos_input.setValue(0)
        self.pos_input.setSingleStep(100)
        self.pos_input.setDecimals(0)
        pos_layout.addWidget(self.pos_input, 0, 1)
        pos_layout.addWidget(QtWidgets.QLabel("Speed (µm/s):"), 1, 0)
        self.pos_speed_input = QtWidgets.QSpinBox()
        # Keep same defaults as before (20 mm/s) but expose it as µm/s.
        self.pos_speed_input.setRange(1, 500_000)
        self.pos_speed_input.setValue(20_000)
        pos_layout.addWidget(self.pos_speed_input, 1, 1)

        pos_layout.addWidget(QtWidgets.QLabel("Cycles:"), 2, 0)
        self.cycle_input = QtWidgets.QSpinBox()
        self.cycle_input.setRange(1, 999)
        self.cycle_input.setValue(1)
        pos_layout.addWidget(self.cycle_input, 2, 1)

        self.btn_move_to = QtWidgets.QPushButton("Start Cycles")
        self.btn_move_to.clicked.connect(self.start_target_cycles)
        pos_layout.addWidget(self.btn_move_to, 3, 0, 1, 1)

        pos_layout.addWidget(QtWidgets.QLabel("Frequency (Hz):"), 3, 1)
        self.freq_input = QtWidgets.QDoubleSpinBox()
        self.freq_input.setRange(0.1, 200.0)
        self.freq_input.setDecimals(2)
        self.freq_input.setSingleStep(0.10)
        self.freq_input.setValue(2.0)
        pos_layout.addWidget(self.freq_input, 3, 2)
        self.btn_home = QtWidgets.QPushButton("Set Origin")
        self.btn_home.clicked.connect(self.set_origin)
        pos_layout.addWidget(self.btn_home, 4, 0, 1, 3)

        # Keithley 2700 logging (starts with Start Cycles)
        self.chk_keithley = QtWidgets.QCheckBox("Log Keithley 2700 (GPIB)")
        self.chk_keithley.setChecked(False)
        pos_layout.addWidget(self.chk_keithley, 5, 0, 1, 3)

        pos_layout.addWidget(QtWidgets.QLabel("VISA Resource:"), 6, 0)
        self.keithley_resource_input = QtWidgets.QLineEdit()
        self.keithley_resource_input.setPlaceholderText("e.g. GPIB0::16::INSTR")
        self.keithley_resource_input.setText("GPIB0::17::INSTR")
        pos_layout.addWidget(self.keithley_resource_input, 6, 1, 1, 2)

        pos_layout.addWidget(QtWidgets.QLabel("Channels (1–20):"), 7, 0)
        self.keithley_channels_list = QtWidgets.QListWidget()
        self.keithley_channels_list.setSelectionMode(QtWidgets.QAbstractItemView.MultiSelection)
        for i in range(1, 21):
            self.keithley_channels_list.addItem(str(i))
        # Default: channel 1 selected
        try:
            self.keithley_channels_list.item(0).setSelected(True)
        except Exception:
            pass
        self.keithley_channels_list.setMaximumHeight(90)
        pos_layout.addWidget(self.keithley_channels_list, 7, 1, 1, 2)

        note = QtWidgets.QLabel("Note: channel n maps to SCPI channel 100+n (101–120)")
        note.setWordWrap(True)
        pos_layout.addWidget(note, 8, 0, 1, 3)
        pos_group.setLayout(pos_layout)
        left_col.addWidget(pos_group)

        # Manual move
        dpot_group = QtWidgets.QGroupBox("Manual Move")
        dpot_layout = QtWidgets.QGridLayout()
        self.btn_dpot_speed = QtWidgets.QPushButton("Manual Speed")
        self.btn_dpot_pos = QtWidgets.QPushButton("Manual Position")
        self.btn_dpot_speed.clicked.connect(self.start_digipoti_speed)
        self.btn_dpot_pos.clicked.connect(self.start_digipoti_position)
        dpot_layout.addWidget(self.btn_dpot_speed, 0, 0, 1, 2)
        dpot_layout.addWidget(self.btn_dpot_pos, 1, 0, 1, 2)
        dpot_group.setLayout(dpot_layout)
        left_col.addWidget(dpot_group)

        # Control buttons
        ctrl_layout = QtWidgets.QHBoxLayout()
        self.btn_stop = QtWidgets.QPushButton("Stop")
        self.btn_stop.setStyleSheet("background-color: #ff4444; color: white; font-weight: bold;")
        self.btn_stop.clicked.connect(self.stop_move)
        ctrl_layout.addWidget(self.btn_stop)
        self.btn_disconnect = QtWidgets.QPushButton("Disconnect")
        self.btn_disconnect.clicked.connect(self.disconnect)
        ctrl_layout.addWidget(self.btn_disconnect)
        left_col.addLayout(ctrl_layout)
        left_col.addStretch()

        main_layout.addLayout(left_col, 2)
        main_layout.addLayout(right_col, 3)
        self.setLayout(main_layout)

    def _scan_force_sensor_candidates(self):
        """Scan sensor channels and return basic metadata.

        Returns
        -------
        list[tuple[int, float, int, int, int]]
            Tuples of `(sensor_no, upper_limit, unit, connector, state)`.

        Notes
        -----
        - This is a lightweight best-effort call used for range selection.
        - Any sensor info call failure simply results in fewer candidates.
        """
        if not getattr(self, 'hdl', None) or self.hdl.value == 0:
            return []
        candidates = []
        for sn in range(0, 16):
            err, info = self._rd_sensor_info(sn)
            if err != 0x0000 or info is None:
                continue
            upper = float(info.UpperLimit)
            if not (upper == upper):
                continue
            candidates.append((sn, upper, int(info.Unit), int(info.Connector), int(info.SensorState)))
        return candidates

    def apply_range_selection(self):
        """Apply the selected range and pick a force channel for supervision.

                Behavior
                --------
                - "10 kN":
                    - switches controller setup via `DoPESelSetup(SETUP_10KN)`
                    - then re-enables data transmit
                - "100 N" / "1000 N":
                    - *does not* switch controller setup
                    - chooses a force-like sensor channel based on closest `UpperLimit`

                Side effects
                ------------
                - Updates `self._range_selection` and the UI label.
                - Updates `self._force_sensor_no` so sampling + force limits can use the
                    selected channel.

                Rationale
                ---------
                Many DoPE setups expose multiple sensor channels. This UI chooses the
                channel that best matches the intended range so that software limit
                supervision is applied to the right measurement.
                """
        if not getattr(self, 'hdl', None) or self.hdl.value == 0:
            self.log("[setup] Not connected")
            return

        text = str(self.range_combo.currentText()).strip()
        if text.startswith("1000"):
            sel = "1kN"
            target = 1200.0
        elif text.startswith("10"):
            sel = "10kN"
            target = 12000.0
        else:
            sel = "100N"
            target = 120.0

        # Switch setup only for 10kN
        if sel == "10kN":
            if not hasattr(self.do_ctrl, 'DoPESelSetup'):
                self.log("[setup] DoPESelSetup not available")
                return
            try:
                with self._dll_lock:
                    self.stop_move()
                    tan_first = ctypes.c_ushort(0)
                    tan_last = ctypes.c_ushort(0)
                    err = int(
                        self.do_ctrl.DoPESelSetup(
                            self.hdl,
                            int(self.SETUP_10KN),
                            None,
                            ctypes.byref(tan_first),
                            ctypes.byref(tan_last),
                        )
                    )
                    self.log(
                        f"[setup] DoPESelSetup({self.SETUP_10KN}) -> 0x{err:04x} (tan_first={tan_first.value}, tan_last={tan_last.value})"
                    )
                    if err != 0x0000:
                        return
                    # Re-enable transmit after setup change
                    try:
                        if hasattr(self.do_ctrl, 'DoPECtrlTestValues'):
                            self.do_ctrl.DoPECtrlTestValues(self.hdl, 0)
                        if hasattr(self.do_ctrl, 'DoPETransmitData'):
                            self.do_ctrl.DoPETransmitData(self.hdl, 1, 0.0, None)
                    except Exception:
                        pass
            except Exception as e:
                self.log(f"[setup] Setup switch error: {e}")
                return

        # Select force sensor channel based on closest UpperLimit
        candidates = self._scan_force_sensor_candidates()
        if not candidates:
            self.log("[setup] No sensor info available")
            self.lbl_range.setText(f"Range: {text}")
            self._range_selection = sel
            return

        def rel(a: float, b: float) -> float:
            return abs(a - b) / max(abs(b), 1e-9)

        best = None
        for sn, upper, unit, conn, state in candidates:
            au = abs(float(upper))
            # accept a broad window to cover calibration differences
            if sel == "100N" and not (50.0 <= au <= 300.0):
                continue
            if sel == "1kN" and not (500.0 <= au <= 3000.0):
                continue
            if sel == "10kN" and not (3000.0 <= au <= 30000.0):
                continue
            score = rel(au, float(target))
            if best is None or score < best[0]:
                best = (score, sn, au, unit, conn, state)

        if best is None:
            # Fallback: choose the largest range as force-like
            sn, upper, unit, conn, state = max(candidates, key=lambda x: abs(x[1]))
            self._force_sensor_no = int(sn)
            self.log(
                f"[setup] Range={text}: no close match; fallback SensorNo={sn}, Upper≈{abs(float(upper)) :g}, Unit={unit}, Conn={conn}, State={state}"
            )
        else:
            _, sn, au, unit, conn, state = best
            self._force_sensor_no = int(sn)
            self.log(
                f"[setup] Range={text}: selected SensorNo={sn}, Upper≈{au:g}, Unit={unit}, Conn={conn}, State={state}"
            )

        self._range_selection = sel
        self.lbl_range.setText(f"Range: {text}")

    def log(self, message):
        """Append a timestamped log line to the UI and to a local file.

        Log file location: `dope_ui_new.log` next to this script/exe.
        """
        from datetime import datetime
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_line = f"[{timestamp}] {message}"
        self.log_text.append(log_line)
        self.log_text.verticalScrollBar().setValue(self.log_text.verticalScrollBar().maximum())
        # Write to local log file
        try:
            log_path = APP_DIR / "dope_ui_new.log"
            with open(log_path, "a", encoding="utf-8") as f:
                f.write(log_line + "\n")
        except Exception as e:
            # Avoid a log-write failure causing a loop
            pass

    def _log_async(self, message: str):
        """Thread-safe logging helper.

        Use this from background threads. It emits `sig_log` which is connected
        to `log()` on the UI thread.
        """
        # Keep name for backward compatibility inside this file.
        try:
            self.sig_log.emit(message)
        except Exception:
            pass

    def init_dope(self) -> bool:
        """Load the DLL and initialize the controller connection.

        Sequence (best-effort)
        ----------------------
        1) Load `drivers/DoPE.dll`.
        2) `DoPEOpenLink` to open the serial link (parameters are project
           specific; currently hard-coded).
        3) `DoPESetNotification` (used here as a standard init step).
        4) `DoPESelSetup(1)` select a default setup on connect.
        5) `DoPEOn` start controller.
        6) `DoPECtrlTestValues(0)` and `DoPETransmitData(Enable=1)` to enable
           live streaming.
        7) Bind ctypes signatures for the subset of APIs used by this UI.

        Return
        ------
        bool
            True on successful connect + setup selection.

        Notes
        -----
        - All calls are wrapped with `self._dll_lock`.
        - Several APIs are optional; we guard with `hasattr`/`getattr`.
        """
        self.log("[init] Loading DLL...")
        self.do_ctrl = ctypes.WinDLL(str(DLL_PATH))
        self.hdl = ctypes.c_ulong(0)
        # OpenLink
        self.log("[init] Calling DoPEOpenLink...")
        self.do_ctrl.DoPEOpenLink.argtypes = [
            ctypes.c_ulong, ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort,
            ctypes.c_ushort, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ulong)
        ]
        self.do_ctrl.DoPEOpenLink.restype = ctypes.c_ulong
        self.log(f"[init] DoPEOpenLink params: port={self._conn_port} (COM{self._conn_port}), baud={self._conn_baud}, api=0x{int(self._conn_api):04x}")
        with self._dll_lock:
            err = self.do_ctrl.DoPEOpenLink(self._conn_port, self._conn_baud, 10, 10, 10, int(self._conn_api), None, ctypes.byref(self.hdl))
        self.log(f"[init] DoPEOpenLink returned: 0x{err:04x}, hdl={self.hdl.value}")
        if err != 0x0000:
            self.log(f"OpenLink failed: 0x{err:04x}")
            hint = "\n\nHint: 0x800B usually means device not present / no response. Check power, cable, correct COM port, and that no other program is using the port."
            QtWidgets.QMessageBox.critical(self, "Connection failed", f"OpenLink failed: 0x{err:04x}{hint}")
            self.hdl = ctypes.c_ulong(0)
            return False
        self.log("Connected")
        # SetNotification
        self.log("[init] Calling DoPESetNotification...")
        self.do_ctrl.DoPESetNotification.argtypes = [
            ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint
        ]
        self.do_ctrl.DoPESetNotification.restype = ctypes.c_ulong
        with self._dll_lock:
            err = self.do_ctrl.DoPESetNotification(self.hdl, 0xffffffff, None, None, 0)
        self.log(f"[init] DoPESetNotification returned: 0x{err:04x}")
        # SelSetup
        self.log("[init] Calling DoPESelSetup...")
        self.do_ctrl.DoPESelSetup.argtypes = [
            ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)
        ]
        self.do_ctrl.DoPESelSetup.restype = ctypes.c_ulong
        tan_first = ctypes.c_ushort(0)
        tan_last = ctypes.c_ushort(0)
        with self._dll_lock:
            err = self.do_ctrl.DoPESelSetup(self.hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
        self.log(f"[init] DoPESelSetup returned: 0x{err:04x}, tan_first={tan_first.value}, tan_last={tan_last.value}")
        if err != 0x0000:
            self.log(f"SelSetup failed: 0x{err:04x}")
            QtWidgets.QMessageBox.critical(self, "Connection failed", f"SelSetup failed: 0x{err:04x}")
            self.hdl = ctypes.c_ulong(0)
            return False
        # Start controller
        self.log("[init] Calling DoPEOn...")
        self.do_ctrl.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
        self.do_ctrl.DoPEOn.restype = ctypes.c_ulong
        with self._dll_lock:
            err = self.do_ctrl.DoPEOn(self.hdl, None)
        self.log(f"[init] DoPEOn returned: 0x{err:04x}")
        self.log("[init] Calling DoPECtrlTestValues...")
        self.do_ctrl.DoPECtrlTestValues.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
        self.do_ctrl.DoPECtrlTestValues.restype = ctypes.c_ulong
        with self._dll_lock:
            err = self.do_ctrl.DoPECtrlTestValues(self.hdl, 0)
        self.log(f"[init] DoPECtrlTestValues returned: 0x{err:04x}")
        self.log("[init] Calling DoPETransmitData...")
        # DoPE.pdf V2.88: DoPETransmitData(DoPE_HANDLE, unsigned short Enable, double Time, WORD *lpusTAN)
        self.do_ctrl.DoPETransmitData.argtypes = [
            ctypes.c_ulong,
            ctypes.c_ushort,
            ctypes.c_double,
            ctypes.POINTER(ctypes.c_ushort),
        ]
        self.do_ctrl.DoPETransmitData.restype = ctypes.c_ulong
        # Use Time=0.0 (default) and no TAN
        with self._dll_lock:
            err = self.do_ctrl.DoPETransmitData(self.hdl, 1, 0.0, None)
        self.log(f"[init] DoPETransmitData returned: 0x{err:04x}")
        # Control API
        # DoPE.pdf V2.88: DoPEFMove(DoPE_HANDLE, unsigned short Direction, unsigned short MoveCtrl, double Speed, WORD *lpusTAN)
        self.do_ctrl.DoPEFMove.argtypes = [
            ctypes.c_ulong,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_double,
            ctypes.POINTER(ctypes.c_ushort),
        ]
        self.do_ctrl.DoPEFMove.restype = ctypes.c_ulong
        # Bind GetData as void* and decode from a raw buffer to avoid struct size/packing mismatch crashes.
        self.do_ctrl.DoPEGetData.argtypes = [ctypes.c_ulong, ctypes.c_void_p]
        self.do_ctrl.DoPEGetData.restype = ctypes.c_ulong

        # DoPE.pdf V2.88: DoPERdSensorInfo(DoPE_HANDLE, unsigned short SensorNo, DoPESumSenInfo *Info)
        if hasattr(self.do_ctrl, "DoPERdSensorInfo"):
            # Bind as void* and decode from a raw buffer to avoid struct size/packing mismatch crashes.
            self.do_ctrl.DoPERdSensorInfo.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_void_p,
            ]
            self.do_ctrl.DoPERdSensorInfo.restype = ctypes.c_ulong

        # Tare / BasicTare (persistent)
        if hasattr(self.do_ctrl, "DoPESetBasicTare"):
            self.do_ctrl.DoPESetBasicTare.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_ushort,
                ctypes.c_double,
                ctypes.POINTER(ctypes.c_ushort),
                ctypes.POINTER(ctypes.c_ushort),
            ]
            self.do_ctrl.DoPESetBasicTare.restype = ctypes.c_ulong
        if hasattr(self.do_ctrl, "DoPEGetBasicTare"):
            self.do_ctrl.DoPEGetBasicTare.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.POINTER(ctypes.c_double),
            ]
            self.do_ctrl.DoPEGetBasicTare.restype = ctypes.c_ulong

        # Try to pick a sensible default range based on available sensors.
        try:
            cands = self._scan_force_sensor_candidates()
            # Prefer 1kN if a ~1000N channel exists, otherwise 10kN.
            has_1kn = any(500.0 <= abs(float(u)) <= 3000.0 for _, u, *_ in cands)
            has_10kn = any(3000.0 <= abs(float(u)) <= 30000.0 for _, u, *_ in cands)
            if has_1kn:
                try:
                    self.range_combo.setCurrentText("1000 N")
                except Exception:
                    pass
            elif has_10kn:
                try:
                    self.range_combo.setCurrentText("10 kN")
                except Exception:
                    pass
        except Exception:
            pass

        # Apply range selection once on connect so _force_sensor_no is set.
        try:
            self.apply_range_selection()
        except Exception:
            pass

        # If X21B (sensor 4) is already outside configured limits, persistently compensate
        # via BasicTare so other software (LabMaster) won't hit SYSTEM_MSG_LOWER_SENLIMIT (10006).
        try:
            self._autofix_x21b_basic_tare()
        except Exception as e:
            self.log(f"[autofix] exception: {e}")

        # DoPE.pdf V2.88: DoPESetCheckLimit(DoPE_HANDLE, unsigned short SensorNo,
        #   double UprLimitSet, double UprLimitReset, double LwrLimitReset, double LwrLimitSet, WORD *lpusTAN)
        if hasattr(self.do_ctrl, "DoPESetCheckLimit"):
            self.do_ctrl.DoPESetCheckLimit.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_double,
                ctypes.c_double,
                ctypes.c_double,
                ctypes.c_double,
                ctypes.POINTER(ctypes.c_ushort),
            ]
            self.do_ctrl.DoPESetCheckLimit.restype = ctypes.c_ulong

        # DoPE.pdf V2.88: DoPEClrCheckLimit(DoPE_HANDLE, WORD *lpusTAN)
        if hasattr(self.do_ctrl, "DoPEClrCheckLimit"):
            self.do_ctrl.DoPEClrCheckLimit.argtypes = [
                ctypes.c_ulong,
                ctypes.POINTER(ctypes.c_ushort),
            ]
            self.do_ctrl.DoPEClrCheckLimit.restype = ctypes.c_ulong
        self.do_ctrl.DoPEPos = getattr(self.do_ctrl, 'DoPEPos', None)
        if self.do_ctrl.DoPEPos:
            # DoPE.pdf V2.88: DoPEPos(DoPE_HANDLE, unsigned short MoveCtrl, double Speed, double Destination, WORD *lpusTAN)
            self.do_ctrl.DoPEPos.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_double,
                ctypes.c_double,
                ctypes.POINTER(ctypes.c_ushort),
            ]
            self.do_ctrl.DoPEPos.restype = ctypes.c_ulong


        # DoPE.pdf V2.88: DoPEHalt(DoPE_HANDLE, unsigned short MoveCtrl, WORD *lpusTAN)
        if hasattr(self.do_ctrl, "DoPEHalt"):
            self.do_ctrl.DoPEHalt.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.POINTER(ctypes.c_ushort),
            ]
            self.do_ctrl.DoPEHalt.restype = ctypes.c_ulong

        # DigiPoti (manual knob)
        # DoPEFDPoti(Hdl, MoveCtrl, MaxSpeed, SensorNo, DxTrigger, Mode, Scale, *Tan)
        self.do_ctrl.DoPEFDPoti = getattr(self.do_ctrl, 'DoPEFDPoti', None)
        if self.do_ctrl.DoPEFDPoti:
            self.do_ctrl.DoPEFDPoti.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_double,
                ctypes.c_ushort,
                ctypes.c_ushort,
                ctypes.c_ushort,
                ctypes.c_double,
                ctypes.POINTER(ctypes.c_ushort),
            ]
            self.do_ctrl.DoPEFDPoti.restype = ctypes.c_ulong

        # DigiPoti default parameters (mapped/verified on your device)
        self.DPOT_SENSOR_NO = 3
        # DxTrigger: encoder has to change this many digits before command becomes active.
        # PDF suggests 2/3; using 0 in speed mode risks "move immediately".
        self.DPOT_DEAD_ZONE_SPEED = 3
        self.DPOT_DEAD_ZONE_POS = 0
        self.DPOT_SCALE = 1.0
        # PDF v2.24: EXT_SPEED_UP_DOWN=5, EXT_POSITION=0, EXT_POS_UP_DOWN=4
        self.DPOT_MODE_SPEED = 5
        self.DPOT_MODE_POS = 0
        self.DPOT_MODE_POS_FALLBACK = 4

        # MOVE_* and CTRL_POS are initialized in __init__ (must exist early).

        return True

    def _value_for_sensor_no(self, data: DoPEData, sensor_no: int) -> float | None:
        """Map a "sensor number" to a numeric value within `DoPEData`.

        This mapping is project-specific and matches how other scripts in this
        repo interpret the sample buffer.

        Mapping
        -------
        - 0 -> Position
        - 1 -> Force
        - 3 -> SensorD (DigiPoti feedback)
        - 4..10 -> Sensor4..Sensor10

        Returns None if the sensor number is unsupported.
        """
        sensor_no = int(sensor_no)
        if sensor_no == 0:
            return float(data.Position)
        if sensor_no == 1:
            return float(data.Force)
        if 4 <= sensor_no <= 10:
            return float(getattr(data, f"Sensor{sensor_no}"))
        if sensor_no == 3:
            return float(data.SensorD)
        return None

    def _read_one_sample(self) -> DoPEData | None:
        """Read a single sample using `DoPEGetData`.

        Implementation detail:
        - Reads into a raw 1024-byte buffer and then slices into `DoPEData`.
          This reduces the chance of crashes if the DLL writes a larger struct
          than expected.
        """
        buf = ctypes.create_string_buffer(1024)
        with self._dll_lock:
            err = int(self.do_ctrl.DoPEGetData(self.hdl, ctypes.byref(buf)))
        if err != 0x0000:
            return None
        try:
            return DoPEData.from_buffer_copy(buf.raw[: ctypes.sizeof(DoPEData)])
        except Exception:
            return None

    def _read_avg_sensor(self, sensor_no: int, n: int = 10, sleep_s: float = 0.05) -> float | None:
        """Read `n` samples and return the average value for a given sensor."""
        vals = []
        for _ in range(max(1, int(n))):
            s = self._read_one_sample()
            if s is None:
                continue
            v = self._value_for_sensor_no(s, sensor_no)
            if v is None:
                continue
            vals.append(float(v))
            time.sleep(max(0.0, float(sleep_s)))
        if not vals:
            return None
        return sum(vals) / len(vals)

    def _get_basic_tare(self, sensor_no: int) -> float | None:
        """Get the persistent BasicTare value for a sensor (if supported)."""
        if not hasattr(self.do_ctrl, "DoPEGetBasicTare"):
            return None
        val = ctypes.c_double(0.0)
        with self._dll_lock:
            err = int(self.do_ctrl.DoPEGetBasicTare(self.hdl, int(sensor_no), ctypes.byref(val)))
        if err != 0x0000:
            return None
        return float(val.value)

    def _set_basic_tare_clear(self, sensor_no: int) -> int:
        """Clear persistent BasicTare compensation (if supported)."""
        if not hasattr(self.do_ctrl, "DoPESetBasicTare"):
            return 0xFFFF
        # SUBTRACT mode with BasicTare=0 clears persistent compensation.
        BASICTARE_SUBTRACT = 1
        with self._dll_lock:
            err = int(self.do_ctrl.DoPESetBasicTare(self.hdl, int(sensor_no), BASICTARE_SUBTRACT, 0.0, None, None))
        return err

    def _set_basic_tare_desired_zero(self, sensor_no: int) -> int:
        """Set persistent BasicTare so that the measured value becomes ~0."""
        if not hasattr(self.do_ctrl, "DoPESetBasicTare"):
            return 0xFFFF
        # SET mode: pass desired measuring value (0) and controller computes the needed offset.
        BASICTARE_SET = 0
        with self._dll_lock:
            err = int(self.do_ctrl.DoPESetBasicTare(self.hdl, int(sensor_no), BASICTARE_SET, 0.0, None, None))
        return err

    def _autofix_x21b_basic_tare(self):
        """Auto-fix X21B baseline out-of-range via persistent BasicTare.

                Context
                -------
                On some rigs the X21B (sensor 4) baseline can start outside the
                configured upper/lower limits. Downstream tools (e.g. LabMaster) may
                then immediately report a system message / limit error.

                Strategy
                --------
                - If BasicTare is currently unset (0), read a baseline average.
                - If baseline is outside limits, apply `DoPESetBasicTare(SET desired=0)`
                    so the controller persists an offset.

                This is best-effort and logs what it did.
                """
        sensor_no = 4  # X21B 1kN force channel
        err, info = self._rd_sensor_info(sensor_no)
        if err != 0x0000 or info is None:
            self.log(f"[autofix] no SensorInfo for sensor {sensor_no} (err=0x{err:04x})")
            return

        upper = float(info.UpperLimit)
        lower = float(info.LowerLimit)
        cur_basic = self._get_basic_tare(sensor_no)
        if cur_basic is not None and abs(cur_basic) > 1e-9:
            self.log(f"[autofix] BasicTare already set for sensor {sensor_no}: {cur_basic:g}")
            return

        baseline = self._read_avg_sensor(sensor_no, n=15, sleep_s=0.05)
        if baseline is None:
            self.log(f"[autofix] cannot read baseline for sensor {sensor_no}")
            return

        out_of_range = (baseline < lower) or (baseline > upper)
        if not out_of_range:
            self.log(f"[autofix] sensor {sensor_no} baseline within limits: {baseline:.3f} (limits {lower:g}..{upper:g})")
            return

        self.log(
            f"[autofix] sensor {sensor_no} baseline OUTSIDE limits: {baseline:.3f} (limits {lower:g}..{upper:g}); applying BasicTare(SET desired=0)"
        )
        err_set = self._set_basic_tare_desired_zero(sensor_no)
        self.log(f"[autofix] DoPESetBasicTare(sensor={sensor_no}, mode=SET, desired=0) -> 0x{err_set:04x}")

    def update_data_loop(self):
        """Background polling loop for DoPE samples.

                Responsibilities
                ----------------
                - Poll `DoPEGetData` and emit `sig_data` (UI update).
                - Apply software force limits (auto-stop) when enabled.
                - Maintain SensorD history for DigiPoti safe activation.
                - Increase polling rate while cycles are active.

                Important constraints
                ---------------------
                - Avoid polling too fast. Over-aggressive polling can destabilize some
                    vendor DLLs (including potential crashes).
                - All DLL calls are serialized via `self._dll_lock`.
                """
        # Use a large buffer to protect against DLL writing a bigger struct than we expect.
        buf = ctypes.create_string_buffer(1024)
        while self._running:
            try:
                with self._dll_lock:
                    err = self.do_ctrl.DoPEGetData(self.hdl, ctypes.byref(buf))
                if err == 0x0000:
                    data = DoPEData.from_buffer_copy(buf.raw[: ctypes.sizeof(DoPEData)])
                    # Select force channel based on scanned/selected sensor number.
                    try:
                        sn = int(self._force_sensor_no) if self._force_sensor_no is not None else 1
                    except Exception:
                        sn = 1
                    force_val = self._value_for_sensor_no(data, sn)
                    if force_val is None:
                        force_val = float(data.Force)
                    try:
                        self.sig_data.emit(float(data.SampleTime), float(data.Position), float(force_val))
                    except Exception:
                        self.sig_data.emit(None, None, None)

                    # Auto-stop on force limits (software supervision)
                    try:
                        if self._force_limit_enabled:
                            f = float(force_val)
                            # Trip conditions
                            over_pull = (self._force_pull_set > 0.0) and (f >= float(self._force_pull_set))
                            over_push = (self._force_push_set < 0.0) and (f <= float(self._force_push_set))

                            if (not self._force_limit_tripped) and (over_pull or over_push):
                                now = time.time()
                                self._force_limit_tripped = True
                                self._force_limit_last_trip_ts = now
                                which = "pull" if over_pull else "push"
                                limit_val = float(self._force_pull_set) if over_pull else float(self._force_push_set)
                                self._log_async(
                                    f"[limit] ⚠ {which} limit reached: Force={f:.4f}, Limit={limit_val:g}. Auto-stop (Halt)"
                                )

                                # Issue stop directly (avoid re-entrancy surprises)
                                with self._dll_lock:
                                    try:
                                        if hasattr(self.do_ctrl, 'DoPEHalt'):
                                            self.do_ctrl.DoPEHalt(self.hdl, 0, None)
                                    except Exception:
                                        pass
                                    try:
                                        if hasattr(self.do_ctrl, 'DoPEFMove'):
                                            self.do_ctrl.DoPEFMove(self.hdl, self.MOVE_HALT, self.CTRL_POS, 0.0, None)
                                    except Exception:
                                        pass

                            # Reset trip only when back inside reset band (hysteresis)
                            if self._force_limit_tripped:
                                inside_pull = (self._force_pull_set <= 0.0) or (f <= float(self._force_pull_reset))
                                inside_push = (self._force_push_set >= 0.0) or (f >= float(self._force_push_reset))
                                if inside_pull and inside_push:
                                    self._force_limit_tripped = False
                    except Exception:
                        pass

                    # Cache DigiPoti channel for safe activation logic
                    try:
                        self._last_sensor_d = float(data.SensorD)
                        self._sensor_d_history.append(self._last_sensor_d)
                        if len(self._sensor_d_history) > 30:
                            self._sensor_d_history = self._sensor_d_history[-30:]
                    except Exception:
                        self._last_sensor_d = None

                    # If speed mode is pending, enable only when the knob is back at baseline and stable.
                    if self._dpot_speed_pending and self._dpot_speed_pending_baseline is not None:
                        try:
                            cur = float(data.SensorD)
                            base = float(self._dpot_speed_pending_baseline)
                            delta = cur - base

                            # Estimate noise from recent history
                            hist = self._sensor_d_history[-10:]
                            noise = (max(hist) - min(hist)) if len(hist) >= 2 else 0.0
                            center_band = max(0.5, noise * 6.0)
                            stable_band = max(0.3, noise * 3.0)

                            in_center = abs(delta) <= center_band
                            stable = False
                            if len(hist) >= 5:
                                stable = (max(hist) - min(hist)) <= stable_band

                            # Enable when knob is centered and stable for a short duration
                            if in_center and stable:
                                if self._dpot_speed_pending_started_at is None:
                                    self._dpot_speed_pending_started_at = time.time()
                                elif (time.time() - float(self._dpot_speed_pending_started_at)) >= 0.25:
                                    dz = int(self._dpot_speed_pending_dz or 3)
                                    target_max_speed_m_s = float(self._dpot_speed_pending_max_speed_m_s or 0.0)

                                    # Arm with MaxSpeed=0 to guarantee "no initial speed" on mode switch.
                                    with self._dll_lock:
                                        err_en = self.do_ctrl.DoPEFDPoti(
                                            self.hdl,
                                            self.CTRL_POS,
                                            0.0,
                                            self.DPOT_SENSOR_NO,
                                            dz,
                                            self.DPOT_MODE_SPEED,
                                            self.DPOT_SCALE,
                                            None,
                                        )
                                    self._dpot_speed_pending = False
                                    self._dpot_speed_armed = True
                                    self._dpot_speed_armed_baseline = base
                                    self._dpot_speed_armed_dz = dz
                                    self._dpot_speed_armed_target_max_speed_m_s = target_max_speed_m_s
                                    self._log_async(
                                        f"[digipoti_speed] Knob centered & stable (SensorD={cur:.3f}, noise≈{noise:.3f}); armed (MaxSpeed=0, DxTrigger={dz}) -> 0x{err_en:04x}"
                                    )
                            else:
                                # reset stability timer when knob is not centered/stable
                                self._dpot_speed_pending_started_at = None
                                # Throttle log spam
                                now = time.time()
                                if (now - float(self._dpot_speed_last_log_ts)) >= 1.0:
                                    self._dpot_speed_last_log_ts = now
                                    self._log_async(
                                        f"[digipoti_speed] Waiting for knob to return to baseline and hold... SensorD={cur:.3f}, Δ={delta:.3f}, band={center_band:.3f}"
                                    )
                        except Exception as e:
                            self._dpot_speed_pending = False
                            self._log_async(f"[digipoti_speed] pending enable exception: {e}")

                    # If armed, wait for the first intentional knob movement (beyond DxTrigger),
                    # then apply the target MaxSpeed.
                    if self._dpot_speed_armed and self._dpot_speed_armed_baseline is not None:
                        try:
                            cur = float(data.SensorD)
                            base = float(self._dpot_speed_armed_baseline)
                            dz = int(self._dpot_speed_armed_dz or 3)
                            target_max_speed_m_s = float(self._dpot_speed_armed_target_max_speed_m_s or 0.0)
                            moved = abs(cur - base) >= float(dz)
                            if moved:
                                with self._dll_lock:
                                    err_en = self.do_ctrl.DoPEFDPoti(
                                        self.hdl,
                                        self.CTRL_POS,
                                        target_max_speed_m_s,
                                        self.DPOT_SENSOR_NO,
                                        dz,
                                        self.DPOT_MODE_SPEED,
                                        self.DPOT_SCALE,
                                        None,
                                    )
                                self._dpot_speed_armed = False
                                self._dpot_speed_armed_baseline = None
                                self._dpot_speed_armed_dz = None
                                self._dpot_speed_armed_target_max_speed_m_s = None
                                self._log_async(
                                    f"[digipoti_speed] Knob movement detected (Δ={cur-base:.3f}>=DxTrigger={dz}); switching to target MaxSpeed={target_max_speed_m_s:.6f} -> 0x{err_en:04x}"
                                )
                        except Exception as e:
                            self._dpot_speed_armed = False
                            self._dpot_speed_armed_baseline = None
                            self._dpot_speed_armed_dz = None
                            self._dpot_speed_armed_target_max_speed_m_s = None
                            self._log_async(f"[digipoti_speed] armed stage exception: {e}")

                else:
                    self._log_async(f"[loop] DoPEGetData returned: 0x{err:04x}")
                    self.sig_data.emit(None, None, None)
            except Exception as e:
                self._log_async(f"[loop] DoPEGetData exception: {e}")
            # Higher sampling while running cycles (better recording density)
            try:
                if self._cycle_active:
                    hz = float(self._cycle_freq_hz or 2.0)
                    # keep a sane range; DoPEGetData polling too fast can destabilize the DLL
                    hz = min(50.0, max(0.2, hz))
                    time.sleep(max(0.02, 1.0 / hz))
                else:
                    time.sleep(0.2)
            except Exception:
                time.sleep(0.2)

    def move_up(self):
        """Jog up while the button is pressed.

        The UI speed input is in mm/s, converted to m/s for `DoPEFMove`.
        """
        if not getattr(self, 'hdl', None) or self.hdl.value == 0:
            self.log("[move_up] Not connected")
            return
        speed = self.speed_input.value()
        speed_m = speed / 1000.0
        self.log(f"[move_up] Calling DoPEFMove, speed={speed_m}")
        with self._dll_lock:
            err = self.do_ctrl.DoPEFMove(self.hdl, self.MOVE_UP, self.CTRL_POS, speed_m, None)
        self.log(f"[move_up] DoPEFMove returned: 0x{err:04x}")
        self.log(f"Moving up (speed: {speed} mm/s)")

    def move_down(self):
        """Jog down while the button is pressed.

        The UI speed input is in mm/s, converted to m/s for `DoPEFMove`.
        """
        if not getattr(self, 'hdl', None) or self.hdl.value == 0:
            self.log("[move_down] Not connected")
            return
        speed = self.speed_input.value()
        speed_m = speed / 1000.0
        self.log(f"[move_down] Calling DoPEFMove, speed={speed_m}")
        with self._dll_lock:
            err = self.do_ctrl.DoPEFMove(self.hdl, self.MOVE_DOWN, self.CTRL_POS, speed_m, None)
        self.log(f"[move_down] DoPEFMove returned: 0x{err:04x}")
        self.log(f"Moving down (speed: {speed} mm/s)")

    def stop_move(self):
        """Stop any motion and exit any external control modes.

        This is the "big red button" behavior:
        - cancels pending DigiPoti activation and clears its state machine
        - aborts any running cycle program and closes CSV logs
        - issues `DoPEHalt` (if available) to exit external modes
        - issues `DoPEFMove(HALT)` as a final stop command
        """
        if not getattr(self, 'hdl', None) or self.hdl.value == 0:
            self.log("[stop_move] Not connected")
            return
        # Cancel any pending DigiPoti speed activation
        self._dpot_speed_pending = False
        self._dpot_speed_pending_baseline = None
        self._dpot_speed_pending_max_speed_m_s = None
        self._dpot_speed_pending_dz = None
        self._dpot_speed_pending_started_at = None
        self._dpot_speed_armed = False
        self._dpot_speed_armed_baseline = None
        self._dpot_speed_armed_dz = None
        self._dpot_speed_armed_target_max_speed_m_s = None

        # Abort any running target-cycle program (and close CSV)
        try:
            self._stop_target_cycles(aborted=True)
        except Exception:
            pass

        # Halt first: make sure we exit DigiPoti / external-control modes
        try:
            if hasattr(self.do_ctrl, 'DoPEHalt'):
                with self._dll_lock:
                    err_h = self.do_ctrl.DoPEHalt(self.hdl, 0, None)
                self.log(f"[stop_move] DoPEHalt returned: 0x{err_h:04x}")
        except Exception as e:
            self.log(f"[stop_move] DoPEHalt exception: {e}")

        self.log("[stop_move] DoPEFMove STOP")
        try:
            if hasattr(self, 'do_ctrl') and hasattr(self.do_ctrl, 'DoPEFMove'):
                move_halt = int(getattr(self, 'MOVE_HALT', 0))
                ctrl_pos = int(getattr(self, 'CTRL_POS', 0))
                with self._dll_lock:
                    err = self.do_ctrl.DoPEFMove(self.hdl, move_halt, ctrl_pos, 0.0, None)
                self.log(f"[stop_move] DoPEFMove returned: 0x{int(err):04x}")
        except Exception as e:
            self.log(f"[stop_move] DoPEFMove exception: {e}")
        self.log("Stopped")

    def _open_cycle_log(self) -> None:
        """Open a CSV file to record target cycle data."""
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        out_dir = APP_DIR / "temp"
        out_dir.mkdir(parents=True, exist_ok=True)
        self._cycle_log_path = out_dir / f"target_cycles_{ts}.csv"
        self._cycle_log_fp = self._cycle_log_path.open("w", newline="", encoding="utf-8")
        self._cycle_log_writer = csv.writer(self._cycle_log_fp)
        header = [
            "wall_time_s",
            "iso_time",
            "cycle_idx",
            "phase",
            "position_mm",
            "force_n",
            "target_position_mm",
            "speed_mm_s",
        ]
        self._cycle_log_writer.writerow(header)

    def _close_cycle_log(self) -> None:
        """Close the current cycle CSV file (if any)."""
        fp = self._cycle_log_fp
        self._cycle_log_fp = None
        self._cycle_log_writer = None
        try:
            if fp is not None:
                try:
                    fp.flush()
                finally:
                    fp.close()
        except Exception:
            pass

    def _cycle_send_destination_rel_mm(self, dest_rel_mm: float) -> int:
        """Send a target destination relative to the current origin (in mm).

        Converts:
        - relative mm -> absolute meters
        - speed mm/s -> m/s

        Returns a DoPE error code (0x0000 on success).
        """
        if not getattr(self, 'hdl', None) or self.hdl.value == 0:
            return 0xFFFF
        if not getattr(self.do_ctrl, 'DoPEPos', None):
            return 0xFFFE

        zero = float(self._cycle_origin_abs_m)
        dest_abs_m = zero + (float(dest_rel_mm) / 1000.0)
        speed_m_s = float(self._cycle_speed_mm_s) / 1000.0
        with self._dll_lock:
            return int(self.do_ctrl.DoPEPos(self.hdl, self.CTRL_POS, speed_m_s, float(dest_abs_m), None))

    def start_target_cycles(self):
        """Start the target <-> origin cycle program.

        The UI inputs are in µm and µm/s, but the internal cycle state machine
        uses mm/mm/s for readability.

        Side effects
        ------------
        - Opens a CSV log under `temp/`.
        - Optionally starts Keithley logging (if enabled and channels selected).
        """
        if not getattr(self, 'hdl', None) or self.hdl.value == 0:
            self.log("[cycles] Not connected")
            return
        if self._last_position_abs is None:
            self.log("[cycles] No Position data yet; wait 1–2 seconds and try again")
            return
        if self._cycle_active:
            self.log("[cycles] Already running")
            return

        cycles = int(getattr(self, 'cycle_input').value())
        # UI uses µm and µm/s; internal motion uses mm and mm/s.
        target_rel_um = float(self.pos_input.value())
        speed_um_s = float(self.pos_speed_input.value())
        target_rel_mm = target_rel_um / 1000.0
        speed_mm_s = speed_um_s / 1000.0
        try:
            self._cycle_freq_hz = float(self.freq_input.value())
        except Exception:
            self._cycle_freq_hz = 2.0

        self._cycle_active = True
        self._cycle_total = max(1, cycles)
        self._cycle_index = 1
        self._cycle_phase = "to_target"
        self._cycle_target_rel_mm = float(target_rel_mm)
        self._cycle_speed_mm_s = float(speed_mm_s)
        self._cycle_origin_abs_m = float(self._pos_zero_abs or 0.0)
        self._cycle_start_perf = time.perf_counter()
        self._cycle_settle_count = 0
        self._cycle_log_last_flush_perf = self._cycle_start_perf

        # Keithley channels to include in this run (and CSV header)
        self._kei_channels_active = []
        if hasattr(self, "chk_keithley") and self.chk_keithley.isChecked():
            try:
                self._kei_channels_active = self._get_selected_keithley_channels()
            except Exception:
                self._kei_channels_active = []

        try:
            self._open_cycle_log()
        except Exception as e:
            self.log(f"[cycles] Failed to open CSV log: {e}")
            self._cycle_active = False
            return

        # Start Keithley logger after CSV is open
        if self._kei_channels_active:
            self._start_keithley_logger_for_cycles()

        self.log(
            f"[cycles] Start: cycles={self._cycle_total}, target={self._cycle_target_rel_mm*1000.0:.0f} µm, speed={self._cycle_speed_mm_s*1000.0:.0f} µm/s. Logging to: {self._cycle_log_path}"
        )

        err = self._cycle_send_destination_rel_mm(self._cycle_target_rel_mm)
        self.log(f"[cycles] Move to target => 0x{err:04x}")

    def _stop_target_cycles(self, aborted: bool) -> None:
        """Stop cycles, stop Keithley logging, and close CSV logs."""
        if not self._cycle_active:
            return

        log_path = self._cycle_log_path

        self._cycle_active = False
        self._cycle_total = 0
        self._cycle_index = 0
        self._cycle_phase = ""
        self._cycle_target_rel_mm = 0.0
        self._cycle_speed_mm_s = 0.0
        self._cycle_origin_abs_m = 0.0
        self._cycle_start_perf = 0.0
        self._cycle_settle_count = 0
        self._cycle_log_path = None
        self._cycle_freq_hz = 2.0

        # Stop Keithley logger if it was running
        try:
            self._stop_keithley_logger()
        except Exception:
            pass

        try:
            self._close_cycle_log()
        finally:
            if log_path is not None:
                if aborted:
                    self.log(f"[cycles] Aborted. CSV saved: {log_path}")
                else:
                    self.log(f"[cycles] Completed. CSV saved: {log_path}")

    def _cycle_on_sample(self, position_abs_m, force_n) -> None:
        """Cycle state machine executed on each valid sample (UI thread).

        It logs one CSV row per sample and advances phases when the position is
        within a tolerance band for a small number of consecutive samples.
        """
        if not self._cycle_active:
            return
        if position_abs_m is None or force_n is None:
            return

        wall_t = float(time.perf_counter() - float(self._cycle_start_perf or time.perf_counter()))
        pos_abs = float(position_abs_m)
        pos_rel_mm = (pos_abs - float(self._cycle_origin_abs_m)) * 1000.0
        f = float(force_n)

        w = self._cycle_log_writer
        if w is not None:
            try:
                iso = datetime.now().isoformat(timespec="milliseconds")
                row = [
                    f"{wall_t:.6f}",
                    iso,
                    str(int(self._cycle_index)),
                    str(self._cycle_phase),
                    f"{pos_rel_mm:.6f}",
                    f"{f:.6f}",
                    f"{float(self._cycle_target_rel_mm):.6f}",
                    f"{float(self._cycle_speed_mm_s):.6f}",
                ]
                w.writerow(row)
            except Exception:
                pass

        # Best-effort periodic flush so you can open/copy CSV mid-run
        try:
            if self._cycle_log_fp is not None:
                nowp = time.perf_counter()
                if (nowp - float(self._cycle_log_last_flush_perf or nowp)) >= 1.0:
                    self._cycle_log_fp.flush()
                    self._cycle_log_last_flush_perf = nowp
        except Exception:
            pass

        # Phase advancement (settle-based)
        dest_rel_mm = float(self._cycle_target_rel_mm) if self._cycle_phase == "to_target" else 0.0
        err_mm = float(pos_rel_mm - dest_rel_mm)
        if abs(err_mm) <= float(self._cycle_tol_mm):
            self._cycle_settle_count += 1
        else:
            self._cycle_settle_count = 0

        if self._cycle_settle_count < int(self._cycle_settle_samples):
            return
        self._cycle_settle_count = 0

        if self._cycle_phase == "to_target":
            self._cycle_phase = "to_origin"
            err = self._cycle_send_destination_rel_mm(0.0)
            self.log(
                f"[cycles] Cycle {self._cycle_index}/{self._cycle_total}: reached target, returning to origin => 0x{err:04x}"
            )
            return

        if self._cycle_phase == "to_origin":
            if self._cycle_index >= self._cycle_total:
                self._stop_target_cycles(aborted=False)
                return
            self._cycle_index += 1
            self._cycle_phase = "to_target"
            err = self._cycle_send_destination_rel_mm(float(self._cycle_target_rel_mm))
            self.log(
                f"[cycles] Cycle {self._cycle_index}/{self._cycle_total}: reached origin, moving to target => 0x{err:04x}"
            )
            return

    def _get_selected_keithley_channels(self) -> list[int]:
        """Return selected channel indices 1..20 (UI list)."""
        if not hasattr(self, "keithley_channels_list"):
            return []
        out: list[int] = []
        for it in self.keithley_channels_list.selectedItems():
            try:
                v = int(str(it.text()).strip())
                if 1 <= v <= 20:
                    out.append(v)
            except Exception:
                continue
        out = sorted(set(out))
        return out

    def _get_keithley_latest_snapshot(self) -> dict:
        """Return a copy of the latest resistance values (thread-safe)."""
        with self._kei_latest_lock:
            return dict(self._kei_latest)

    def _start_keithley_logger_for_cycles(self) -> None:
        """Start Keithley logging tied to cycles.

        Strategy:
        - Prefer a 64-bit subprocess streamer (so NI-VISA 64-bit works even though this UI is 32-bit).
        - Store latest values in-memory; cycle CSV appends latest snapshot on each DoPE sample.
        """
        channels = list(getattr(self, "_kei_channels_active", []) or [])
        if not channels:
            return

        # Ensure any previous logger instance is stopped, but keep the requested channel list.
        self._stop_keithley_logger(preserve_channels=True)
        resource = ""
        freq_hz = 2.0
        try:
            resource = str(self.keithley_resource_input.text()).strip()
        except Exception:
            resource = ""
        try:
            freq_hz = float(self.freq_input.value())
        except Exception:
            freq_hz = 2.0

        if freq_hz <= 0:
            freq_hz = 2.0

        # Launch 64-bit helper if available
        helper = APP_DIR / "temp" / "keithley_2700_stream.py"
        py64 = APP_DIR / ".venv" / "Scripts" / "python.exe"
        if py64.exists() and helper.exists():
            args = [
                str(py64),
                str(helper),
                "--resource",
                resource,
                "--channels",
                ",".join(str(c) for c in channels),
                "--frequency",
                str(freq_hz),
                "--duration",
                "0",
            ]
            try:
                self._open_keithley_log(channels)
                self.log(f"[keithley] Logging to: {self._kei_log_path}")
                self._kei_proc = subprocess.Popen(
                    args,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True,
                    bufsize=1,
                    universal_newlines=True,
                )
                self._kei_start_perf = time.perf_counter()
                self._kei_log_last_flush_perf = self._kei_start_perf
                self._kei_proc_reader_thread = threading.Thread(
                    target=self._keithley_proc_reader_loop,
                    args=(self._kei_proc, channels),
                    daemon=True,
                )
                self._kei_proc_reader_thread.start()
                # stderr reader (so buffer can't fill and errors show in UI log)
                try:
                    if self._kei_proc.stderr is not None:
                        self._kei_proc_stderr_thread = threading.Thread(
                            target=self._keithley_proc_stderr_loop,
                            args=(self._kei_proc,),
                            daemon=True,
                        )
                        self._kei_proc_stderr_thread.start()
                except Exception:
                    self._kei_proc_stderr_thread = None
                self.log(f"[keithley] Subprocess logging started (64-bit): resource={resource!r}, channels={channels}, freq={freq_hz:.2f} Hz")
                return
            except Exception as e:
                self.log(f"[keithley] Failed to start subprocess helper: {e}")
                try:
                    self._close_keithley_log()
                except Exception:
                    pass

        # Fallback: in-process polling (requires working VISA backend in 32-bit Python)
        interval_s = 1.0 / float(freq_hz)
        try:
            self._open_keithley_log(channels)
            self.log(f"[keithley] Logging to: {self._kei_log_path}")
        except Exception as e:
            self.log(f"[keithley] Failed to open Keithley CSV: {e}")
        self._kei_stop_evt = threading.Event()
        self._kei_start_perf = time.perf_counter()
        self._kei_log_last_flush_perf = self._kei_start_perf
        self._kei_thread = threading.Thread(
            target=self._keithley_poll_loop,
            args=(resource, channels, interval_s, self._kei_stop_evt),
            daemon=True,
        )
        self._kei_thread.start()
        self.log(f"[keithley] In-process logging started: resource={resource!r}, channels={channels}, freq={freq_hz:.2f} Hz")

    def _stop_keithley_logger(self, preserve_channels: bool = False) -> None:
        """Stop Keithley logging (subprocess or in-process) and close CSV."""
        # Stop subprocess helper (preferred mode)
        proc = self._kei_proc
        self._kei_proc = None
        if proc is not None:
            try:
                proc.terminate()
            except Exception:
                pass
            try:
                proc.wait(timeout=2.0)
            except Exception:
                try:
                    proc.kill()
                except Exception:
                    pass

        thr_r = self._kei_proc_reader_thread
        self._kei_proc_reader_thread = None
        if thr_r is not None and thr_r.is_alive():
            try:
                thr_r.join(timeout=2.0)
            except Exception:
                pass

        thr_e = self._kei_proc_stderr_thread
        self._kei_proc_stderr_thread = None
        if thr_e is not None and thr_e.is_alive():
            try:
                thr_e.join(timeout=1.0)
            except Exception:
                pass

        evt = self._kei_stop_evt
        thr = self._kei_thread
        self._kei_stop_evt = None
        self._kei_thread = None
        if evt is not None:
            try:
                evt.set()
            except Exception:
                pass
        if thr is not None and thr.is_alive():
            try:
                thr.join(timeout=2.0)
            except Exception:
                pass

        with self._kei_latest_lock:
            self._kei_latest.clear()
        if not preserve_channels:
            self._kei_channels_active = []

        # Close Keithley CSV
        try:
            log_path = self._kei_log_path
            self._close_keithley_log()
            if log_path is not None:
                self.log(f"[keithley] CSV saved: {log_path}")
        except Exception:
            pass

    def _open_keithley_log(self, channels: list[int]) -> None:
        """Open Keithley CSV log file under `temp/`."""
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        out_dir = APP_DIR / "temp"
        out_dir.mkdir(parents=True, exist_ok=True)
        self._kei_log_path = out_dir / f"keithley_{ts}.csv"
        self._kei_log_fp = self._kei_log_path.open("w", newline="", encoding="utf-8")
        self._kei_log_writer = csv.writer(self._kei_log_fp)
        header = ["wall_time_s", "iso_time"]
        for ch in channels:
            header.append(f"r_ch{int(ch)}_ohm")
        self._kei_log_writer.writerow(header)

    def _close_keithley_log(self) -> None:
        """Close the Keithley CSV log file (if open)."""
        fp = self._kei_log_fp
        self._kei_log_fp = None
        self._kei_log_writer = None
        self._kei_log_path = None
        try:
            if fp is not None:
                try:
                    fp.flush()
                finally:
                    fp.close()
        except Exception:
            pass

    def _keithley_proc_reader_loop(self, proc, channels: list[int]) -> None:
        """Read JSON lines from helper subprocess and update latest resistance values."""
        try:
            stdout = proc.stdout
            if stdout is None:
                self.sig_log.emit("[keithley] helper stdout is None")
                return

            while True:
                if proc.poll() is not None:
                    break
                line = stdout.readline()
                if not line:
                    time.sleep(0.01)
                    continue
                line = line.strip()
                if not line:
                    continue

                try:
                    obj = json.loads(line)
                    values = obj.get("values") or {}
                except Exception:
                    continue

                # Write Keithley CSV row (its own time base)
                try:
                    kw = self._kei_log_writer
                    if kw is not None:
                        wall = obj.get("wall_time_s")
                        iso = obj.get("iso_time")
                        row = [
                            f"{float(wall):.6f}" if wall is not None else "",
                            str(iso or ""),
                        ]
                        for ch in channels:
                            v = values.get(str(int(ch)))
                            row.append("" if v is None else f"{float(v):.9f}")
                        kw.writerow(row)

                        try:
                            if self._kei_log_fp is not None:
                                nowp = time.perf_counter()
                                if (nowp - float(self._kei_log_last_flush_perf or nowp)) >= 1.0:
                                    self._kei_log_fp.flush()
                                    self._kei_log_last_flush_perf = nowp
                        except Exception:
                            pass
                except Exception:
                    pass

                latest = {}
                for ch in channels:
                    try:
                        v = values.get(str(int(ch)))
                        latest[int(ch)] = (None if v is None else float(v))
                    except Exception:
                        latest[int(ch)] = None

                with self._kei_latest_lock:
                    self._kei_latest.update(latest)

        except Exception as e:
            try:
                self.sig_log.emit(f"[keithley] helper reader exception: {e}")
            except Exception:
                pass

    def _keithley_proc_stderr_loop(self, proc) -> None:
        try:
            stderr = proc.stderr
            if stderr is None:
                return
            for line in stderr:
                if not line:
                    continue
                s = str(line).strip()
                if s:
                    try:
                        self.sig_log.emit(f"[keithley] {s}")
                    except Exception:
                        pass
                if proc.poll() is not None:
                    break
        except Exception:
            pass

    def _keithley_poll_loop(self, resource: str, channels: list[int], interval_s: float, stop_evt: threading.Event) -> None:
        """Poll resistance values in a loop; store latest results in memory.

        Implementation is best-effort because Keithley 2700 SCPI variants depend on card/options.
        """
        try:
            import pyvisa  # type: ignore
        except Exception as e:
            self.sig_log.emit(f"[keithley] pyvisa not installed or import failed: {e}")
            return

        if not resource:
            self.sig_log.emit("[keithley] Empty VISA resource; set e.g. GPIB0::16::INSTR")
            return

        rm = None
        inst = None
        try:
            try:
                rm = pyvisa.ResourceManager()
            except Exception as e_rm:
                # Fallback: pure Python backend (may not support all GPIB adapters on Windows)
                try:
                    rm = pyvisa.ResourceManager("@py")
                    self.sig_log.emit(f"[keithley] VISA backend fallback: using pyvisa-py (@py) because default failed: {e_rm}")
                except Exception as e_rm2:
                    self.sig_log.emit(f"[keithley] No VISA backend found. Install NI-VISA/Keysight VISA or pyvisa-py. Error: {e_rm2}")
                    return

            inst = rm.open_resource(resource)
            try:
                inst.timeout = 2000
            except Exception:
                pass
            # Clear status (non-destructive)
            try:
                inst.write("*CLS")
            except Exception:
                pass

            while not stop_evt.is_set():
                latest = {}
                for ch in channels:
                    if stop_evt.is_set():
                        break
                    scpi_ch = 100 + int(ch)  # 1->101 ... 20->120
                    val = self._keithley_read_resistance_best_effort(inst, scpi_ch)
                    latest[int(ch)] = val

                # Write Keithley CSV in fallback mode
                try:
                    kw = self._kei_log_writer
                    if kw is not None:
                        iso = datetime.now().isoformat(timespec="milliseconds")
                        wall = float(time.perf_counter() - float(self._kei_start_perf or time.perf_counter()))
                        row = [f"{wall:.6f}", iso]
                        for ch in channels:
                            v = latest.get(int(ch))
                            row.append("" if v is None else f"{float(v):.9f}")
                        kw.writerow(row)

                        try:
                            if self._kei_log_fp is not None:
                                nowp = time.perf_counter()
                                if (nowp - float(self._kei_log_last_flush_perf or nowp)) >= 1.0:
                                    self._kei_log_fp.flush()
                                    self._kei_log_last_flush_perf = nowp
                        except Exception:
                            pass
                except Exception:
                    pass

                with self._kei_latest_lock:
                    self._kei_latest.update(latest)

                # Responsive sleep
                t_end = time.perf_counter() + max(0.01, float(interval_s))
                while (not stop_evt.is_set()) and time.perf_counter() < t_end:
                    time.sleep(0.01)

        except Exception as e:
            self.sig_log.emit(f"[keithley] Logger exception: {e}")
        finally:
            try:
                if inst is not None:
                    inst.close()
            except Exception:
                pass
            try:
                if rm is not None:
                    rm.close()
            except Exception:
                pass

    def _keithley_read_resistance_best_effort(self, inst, scpi_ch: int):
        """Return resistance in ohms (float) or None."""
        # Try to select/close the channel (if supported)
        try:
            inst.write(f"ROUT:CLOS (@{int(scpi_ch)})")
        except Exception:
            pass

        cmds = [
            f"MEAS:RES? (@{int(scpi_ch)})",
            "MEAS:RES?",
            f"MEAS:FRES? (@{int(scpi_ch)})",
            "MEAS:FRES?",
            "READ?",
        ]
        for cmd in cmds:
            try:
                resp = inst.query(cmd)
                if resp is None:
                    continue
                s = str(resp).strip()
                if not s:
                    continue
                # Sometimes returns comma-separated fields; take first token
                token = s.split(",")[0].strip()
                val = float(token)
                # Some Keithley instruments use large sentinel on overrange
                if abs(val) > 9e36:
                    return None
                return val
            except Exception as e:
                # Throttle spammy errors
                now = time.perf_counter()
                if (now - float(self._kei_last_err_log_ts or 0.0)) > 5.0:
                    self._kei_last_err_log_ts = now
                    try:
                        self.sig_log.emit(f"[keithley] SCPI failed ({cmd}): {e}")
                    except Exception:
                        pass
                continue
        return None

    def _digipoti_max_speed_m_s(self) -> float:
        """Return DigiPoti max speed as m/s derived from the UI jog speed."""
        # Reuse the UI speed input as DigiPoti MaxSpeed limit (mm/s -> m/s)
        try:
            speed_mm_s = float(self.speed_input.value())
        except Exception:
            speed_mm_s = 10.0
        return speed_mm_s / 1000.0

    def start_digipoti_speed(self):
        """Enable DigiPoti *speed* mode with a safe two-stage activation.

        Why the two-stage activation?
        ----------------------------
        On some rigs, calling `DoPEFDPoti` for speed mode can cause an immediate
        movement if the knob is not exactly at its baseline (or if noise looks
        like a movement). To reduce risk, we:
        1) Stop any motion and clear external modes (`stop_move`).
        2) Observe SensorD until the knob is centered & stable for ~0.25s.
        3) Arm speed mode with `MaxSpeed=0` (guarantee no initial speed).
        4) After the *first intentional* knob movement beyond `DxTrigger`,
           re-issue `DoPEFDPoti` with the requested `MaxSpeed`.

        The arming/activation logic is implemented in `update_data_loop`.
        """
        if not getattr(self, 'hdl', None) or self.hdl.value == 0:
            self.log("[digipoti_speed] Not connected")
            return
        if not getattr(self.do_ctrl, 'DoPEFDPoti', None):
            self.log("[digipoti_speed] DoPEFDPoti not available")
            return

        max_speed_m_s = self._digipoti_max_speed_m_s()
        dz = int(getattr(self, 'DPOT_DEAD_ZONE_SPEED', 3))

        # Safe start strategy: do not call DoPEFDPoti on click (avoid immediate movement).
        # Only enable speed mode after detecting a real knob movement.
        self.stop_move()

        baseline = self._last_sensor_d
        if baseline is None:
            try:
                tmp_buf = ctypes.create_string_buffer(1024)
                with self._dll_lock:
                    err0 = self.do_ctrl.DoPEGetData(self.hdl, ctypes.byref(tmp_buf))
                if err0 == 0x0000:
                    tmp = DoPEData.from_buffer_copy(tmp_buf.raw[: ctypes.sizeof(DoPEData)])
                    baseline = float(tmp.SensorD)
            except Exception:
                baseline = None
        if baseline is None:
            baseline = 0.0

        self._dpot_speed_pending = True
        self._dpot_speed_pending_baseline = baseline
        self._dpot_speed_pending_max_speed_m_s = max_speed_m_s
        self._dpot_speed_pending_dz = dz
        self._dpot_speed_pending_started_at = None
        self.log(
            f"✅ Manual speed pending: switch is armed with MaxSpeed=0 (no initial speed). Keep knob at baseline for ~0.3s; then first movement beyond DxTrigger={dz} applies target MaxSpeed={max_speed_m_s:.6f} (baselineSensorD={baseline:.3f}). Press Stop to exit."
        )

    def start_digipoti_position(self):
        """Enable DigiPoti *position* mode.

                Notes
                -----
                - This mode is usually safer than speed mode because it does not
                    immediately command a velocity.
                - We try Mode=0 (EXT_POSITION) first and fall back to Mode=4
                    (EXT_POS_UP_DOWN) because device configurations vary.
                """
        if not getattr(self, 'hdl', None) or self.hdl.value == 0:
            self.log("[digipoti_pos] Not connected")
            return
        if not getattr(self.do_ctrl, 'DoPEFDPoti', None):
            self.log("[digipoti_pos] DoPEFDPoti not available")
            return

        max_speed_m_s = self._digipoti_max_speed_m_s()
        dz = int(getattr(self, 'DPOT_DEAD_ZONE_POS', 0))
        for mode in (self.DPOT_MODE_POS, self.DPOT_MODE_POS_FALLBACK):
            self.log(
                f"[digipoti_pos] DoPEFDPoti: sensor={self.DPOT_SENSOR_NO}, dz={dz}, mode={mode}, scale={self.DPOT_SCALE}, maxSpeed={max_speed_m_s}"
            )
            with self._dll_lock:
                err = self.do_ctrl.DoPEFDPoti(
                    self.hdl,
                    self.CTRL_POS,
                    max_speed_m_s,
                    self.DPOT_SENSOR_NO,
                    dz,
                    mode,
                    self.DPOT_SCALE,
                    None,
                )
            self.log(f"[digipoti_pos] DoPEFDPoti(Mode={mode}) returned: 0x{err:04x}")
            if err == 0x0000:
                self.log("✅ Manual position active: use panel knob; press Stop to exit")
                return

        self.log("❌ Manual position start failed")

    def move_to_position(self):
        """Backward-compat alias: historically a single move; now runs cycles."""
        # Backward-compat: keep the method name, but run the cycle program.
        self.start_target_cycles()

    def set_origin(self):
        """Set current absolute position as UI origin (so displayed position becomes 0)."""
        if self._last_position_abs is None:
            self.log("[origin] No Position data; cannot set origin")
            return
        self._pos_zero_abs = float(self._last_position_abs)
        self.log(f"[origin] Origin set: zero_abs={self._pos_zero_abs:.6f} (display Position=0)")

    def _rd_sensor_info(self, sensor_no: int) -> tuple[int, DoPESumSenInfo | None]:
        """Read sensor metadata for `sensor_no`.

        Returns
        -------
        (err_code, info)
            - `err_code` is a DoPE error code (0x0000 on success).
            - `info` is a decoded `DoPESumSenInfo` on success.
        """
        if not getattr(self, 'hdl', None) or self.hdl.value == 0:
            return 0xFFFF, None
        if not hasattr(self.do_ctrl, 'DoPERdSensorInfo'):
            return 0xFFFE, None
        try:
            buf = ctypes.create_string_buffer(256)
            with self._dll_lock:
                err = int(self.do_ctrl.DoPERdSensorInfo(self.hdl, int(sensor_no), ctypes.byref(buf)))
            if err != 0x0000:
                return err, None
            info = DoPESumSenInfo.from_buffer_copy(buf.raw[: ctypes.sizeof(DoPESumSenInfo)])
            return err, info
        except Exception:
            return 0xFFFD, None

    def scan_connected_low_range(self):
        """Legacy compatibility: keep the function name, but route to the new setup flow."""
        try:
            self.apply_range_selection()
        except Exception:
            pass

    def apply_force_limits(self):
        """Apply pull/push max limits via DoPESetCheckLimit.

        Note: DoPE manual describes this as a limit supervision that drives a digital output.
        We treat it as a convenient way to configure max pull/push thresholds.

        Convention used here: pull (tension) is positive, push (compression) is negative.
        """
        if not getattr(self, 'hdl', None) or self.hdl.value == 0:
            self.log("[limit] Not connected")
            return
        if not hasattr(self.do_ctrl, 'DoPESetCheckLimit'):
            self.log("[limit] DoPESetCheckLimit not available")
            return

        pull = float(self.pull_limit_input.value())
        push = float(self.push_limit_input.value())
        if pull <= 0.0 and push <= 0.0:
            self.log("[limit] Pull/Push are both 0; nothing applied")
            return

        # Ensure we have a sensor number
        if self._force_sensor_no is None:
            self.scan_connected_low_range()

        sensor_no = int(self._force_sensor_no or 0)

        upr_set = abs(pull) if pull > 0.0 else 0.0
        lwr_set = -abs(push) if push > 0.0 else 0.0

        # Hysteresis toward zero to avoid chattering (2% by default)
        upr_reset = upr_set * 0.98
        lwr_reset = lwr_set * 0.98

        # Store for software auto-stop
        self._force_limit_enabled = True
        self._force_pull_set = float(upr_set)
        self._force_pull_reset = float(upr_reset)
        self._force_push_set = float(lwr_set)
        self._force_push_reset = float(lwr_reset)
        self._force_limit_tripped = False

        self.log(
            f"[limit] Apply limits: SensorNo={sensor_no}, UpperSet={upr_set:g}, UpperReset={upr_reset:g}, LowerReset={lwr_reset:g}, LowerSet={lwr_set:g} (convention: pull positive, push negative)"
        )
        self.log("[limit] Note: Reset is 2% closer to zero (hysteresis) to avoid chattering near the threshold")

        with self._dll_lock:
            err = int(
                self.do_ctrl.DoPESetCheckLimit(
                    self.hdl,
                    ctypes.c_ushort(sensor_no),
                    ctypes.c_double(upr_set),
                    ctypes.c_double(upr_reset),
                    ctypes.c_double(lwr_reset),
                    ctypes.c_double(lwr_set),
                    None,
                )
            )

        self.log(f"[limit] DoPESetCheckLimit returned: 0x{err:04x}")

    def select_10kn_range(self):
        """Legacy compatibility: keep the function name, but route to range selection."""
        try:
            # Force the combo to 10kN and apply.
            if hasattr(self, 'range_combo'):
                self.range_combo.setCurrentText("10 kN")
            self.apply_range_selection()
        except Exception:
            pass

    def disconnect(self):
        """Disconnect from the controller and stop background activity.

        Order of operations
        -------------------
        - Stop motion / abort cycles first (`stop_move`).
        - Stop the polling thread (`self._running = False`).
        - Issue `DoPEHalt` (best-effort) and `DoPECloseLink`.
        """
        # Stop any motion/cycle program first
        try:
            self.stop_move()
        except Exception:
            pass

        # 1) Stop background sampling thread first
        self.log("[disconnect] Stopping background sampling thread...")
        self._running = False
        try:
            if getattr(self, '_thread', None) is not None:
                self._thread.join(timeout=1.0)
        except Exception:
            pass

        if not self.hdl:
            self.log("[disconnect] Handle is empty; nothing to do")
            return

        self.log("[disconnect] Disconnecting hardware...")
        try:
            # A. Stop motion (Halt)
            if hasattr(self.do_ctrl, 'DoPEHalt'):
                # DoPE.pdf V2.88: DoPEHalt(DoPE_HANDLE, unsigned short MoveCtrl, WORD *lpusTAN)
                with self._dll_lock:
                    err = self.do_ctrl.DoPEHalt(self.hdl, 0, None)
                self.log(f"[disconnect] DoPEHalt: 0x{err:04x}")

            # B. Emergency stop / power-off (EmergencyOff) - usually not needed on disconnect; keep commented
            # if hasattr(self.do_ctrl, 'DoPEEmergencyOff'):
            #     self.do_ctrl.DoPEEmergencyOff.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
            #     self.do_ctrl.DoPEEmergencyOff.restype = ctypes.c_ulong
            #     err = self.do_ctrl.DoPEEmergencyOff(self.hdl, 1)
            #     self.log(f"[disconnect] DoPEEmergencyOff: 0x{err:04x}")

            # C. Close link (CloseLink)
            if hasattr(self.do_ctrl, 'DoPECloseLink'):
                self.do_ctrl.DoPECloseLink.argtypes = [ctypes.c_ulong]
                self.do_ctrl.DoPECloseLink.restype = ctypes.c_ulong
                with self._dll_lock:
                    err = self.do_ctrl.DoPECloseLink(self.hdl)
                self.log(f"[disconnect] DoPECloseLink: 0x{err:04x}")
        except Exception as e:
            self.log(f"[disconnect] Exception: {e}")

        # Clear handle to prevent accidental use
        self.hdl = ctypes.c_ulong(0)
        self.log("Disconnected")
        self.setEnabled(False)

    def closeEvent(self, event):
        """Qt close hook: stop threads/motion before exiting the UI."""
        self._running = False
        try:
            if getattr(self, '_thread', None) is not None:
                self._thread.join(timeout=1.0)
        except Exception:
            pass
        try:
            self.stop_move()
        except Exception:
            pass
        event.accept()

if __name__ == "__main__":
    # Optional CLI self-tests for field debugging (do not start the UI).
    # Example: dope_ui_new.exe --keithley-import-test
    try:
        ap = argparse.ArgumentParser(add_help=True)
        ap.add_argument("--keithley-import-test", action="store_true")
        ns, _ = ap.parse_known_args(sys.argv[1:])
        if bool(getattr(ns, "keithley_import_test", False)):
            try:
                import pyvisa  # type: ignore

                print(f"OK: pyvisa importable (version={getattr(pyvisa, '__version__', '?')})")
                raise SystemExit(0)
            except Exception as e:
                print(f"ERROR: pyvisa import failed: {e}")
                raise SystemExit(2)
    except SystemExit:
        raise
    except Exception:
        # Never block the UI from starting due to self-test argument parsing.
        pass

    app = QtWidgets.QApplication(sys.argv)
    panel = DopeUINew()
    panel.show()
    sys.exit(app.exec_())
