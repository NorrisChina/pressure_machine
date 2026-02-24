#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DoPE 控制面板 - 稳定版
结构体：采用用户验证过的版本 (含 SampleTime/Speed)
修复：UI 线程安全问题
"""
import sys
import os
import subprocess
import ctypes
import threading
import time
from pathlib import Path
from PyQt5 import QtWidgets, QtCore

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"

# Prefer using 32-bit Python for the 32-bit DoPE.dll.
if sys.maxsize > 2**32:
    venv32_python = os.path.join(os.path.dirname(__file__), ".venv32", "Scripts", "python.exe")
    if os.path.exists(venv32_python):
        subprocess.call([venv32_python, __file__] + sys.argv[1:])
        raise SystemExit(0)


# --- 1. 保持你验证过的结构体 (不要动它) ---
class DoPEData(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Time", ctypes.c_double),
        ("SampleTime", ctypes.c_double),
        ("Position", ctypes.c_double),
        ("Force", ctypes.c_double),
        ("Speed", ctypes.c_double),
        ("Status", ctypes.c_long),
        ("Dummy", ctypes.c_byte * 20)
    ]

class DopeUINew(QtWidgets.QWidget):
    # 定义信号，用于从后台线程安全更新 UI
    data_received = QtCore.pyqtSignal(object) 

    def __init__(self):
        super().__init__()
        self.setWindowTitle("DoPE 控制面板 (稳定版)")
        self.setGeometry(100, 100, 700, 450)
        self.init_ui()
        
        # 信号槽连接
        self.data_received.connect(self.update_ui_data)
        
        self.do_ctrl = None
        self.hdl = ctypes.c_ulong(0)
        self.connected = False
        self._running = False
        
        try:
            self.init_dope()
            self.connected = True
            self._running = True
            self._thread = threading.Thread(target=self.update_data_loop, daemon=True)
            self._thread.start()
        except Exception as e:
            self.connected = False
            self._running = False
            # Disable controls if not connected
            try:
                self._set_controls_enabled(False)
            except Exception:
                pass
            QtWidgets.QMessageBox.critical(self, "初始化失败", str(e))

    def _set_controls_enabled(self, enabled: bool) -> None:
        for w in [
            getattr(self, "speed_input", None),
            getattr(self, "pos_input", None),
        ]:
            if w is not None:
                w.setEnabled(enabled)

        for w in [
            getattr(self, "btn_up", None),
            getattr(self, "btn_down", None),
            getattr(self, "btn_stop", None),
        ]:
            if w is not None:
                w.setEnabled(enabled)

    def init_ui(self):
        main_layout = QtWidgets.QHBoxLayout()
        left_col = QtWidgets.QVBoxLayout()
        right_col = QtWidgets.QVBoxLayout()

        # 参数显示
        param_group = QtWidgets.QGroupBox("实时参数 (自动读取)")
        p_layout = QtWidgets.QVBoxLayout()
        # 字体加大一点
        font = self.font(); font.setPointSize(12); font.setBold(True)
        
        self.lbl_time = QtWidgets.QLabel("Time: --"); self.lbl_time.setFont(font)
        self.lbl_position = QtWidgets.QLabel("Position: --"); self.lbl_position.setFont(font)
        self.lbl_force = QtWidgets.QLabel("Force: --"); self.lbl_force.setFont(font)
        self.lbl_speed = QtWidgets.QLabel("Speed: --"); self.lbl_speed.setFont(font)
        
        p_layout.addWidget(self.lbl_time)
        p_layout.addWidget(self.lbl_position)
        p_layout.addWidget(self.lbl_force)
        p_layout.addWidget(self.lbl_speed)
        param_group.setLayout(p_layout)
        right_col.addWidget(param_group)

        # 日志
        self.log_text = QtWidgets.QTextEdit()
        self.log_text.setReadOnly(True)
        right_col.addWidget(QtWidgets.QLabel("日志"))
        right_col.addWidget(self.log_text)

        # 控制区
        ctrl_group = QtWidgets.QGroupBox("运动控制")
        c_layout = QtWidgets.QVBoxLayout()
        
        # 速度设置
        spd_layout = QtWidgets.QHBoxLayout()
        spd_layout.addWidget(QtWidgets.QLabel("速度 (mm/s):"))
        self.speed_input = QtWidgets.QSpinBox(); self.speed_input.setRange(1, 50); self.speed_input.setValue(5)
        spd_layout.addWidget(self.speed_input)
        c_layout.addLayout(spd_layout)
        
        # 按钮
        self.btn_up = QtWidgets.QPushButton("▲ 上移 (按住)"); self.btn_up.setMinimumHeight(40)
        self.btn_down = QtWidgets.QPushButton("▼ 下移 (按住)"); self.btn_down.setMinimumHeight(40)
        self.btn_stop = QtWidgets.QPushButton("■ 停止"); self.btn_stop.setMinimumHeight(40); self.btn_stop.setStyleSheet("background:red; color:white")
        
        self.btn_up.pressed.connect(self.move_up); self.btn_up.released.connect(self.stop_move)
        self.btn_down.pressed.connect(self.move_down); self.btn_down.released.connect(self.stop_move)
        self.btn_stop.clicked.connect(self.stop_move)
        
        c_layout.addWidget(self.btn_up)
        c_layout.addWidget(self.btn_down)
        c_layout.addWidget(self.btn_stop)
        ctrl_group.setLayout(c_layout)
        left_col.addWidget(ctrl_group)
        
        # 定点移动
        pos_group = QtWidgets.QGroupBox("定点移动")
        pos_layout = QtWidgets.QGridLayout()
        self.pos_input = QtWidgets.QDoubleSpinBox(); self.pos_input.setRange(-200, 200)
        btn_go = QtWidgets.QPushButton("Go"); btn_go.clicked.connect(self.move_to_pos)
        pos_layout.addWidget(QtWidgets.QLabel("目标(mm):"), 0, 0)
        pos_layout.addWidget(self.pos_input, 0, 1)
        pos_layout.addWidget(btn_go, 0, 2)
        pos_group.setLayout(pos_layout)
        left_col.addWidget(pos_group)

        main_layout.addLayout(left_col, 1)
        main_layout.addLayout(right_col, 2)
        self.setLayout(main_layout)

    def log(self, msg):
        t = time.strftime("%H:%M:%S")
        self.log_text.append(f"[{t}] {msg}")

    def init_dope(self):
        if not DLL_PATH.exists(): raise FileNotFoundError("找不到 DLL")
        
        self.do_ctrl = ctypes.WinDLL(str(DLL_PATH))
        
        # 1. OpenLink
        self.do_ctrl.DoPEOpenLink.argtypes = [
            ctypes.c_ulong, ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort,
            ctypes.c_ushort, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ulong)
        ]
        err = self.do_ctrl.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(self.hdl))
        if err != 0: raise Exception(f"OpenLink Error: {err}")

        # 2. Setup & Init (基本保持你原样)
        self.do_ctrl.DoPESelSetup.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)]
        tan = ctypes.c_ushort(0)
        self.do_ctrl.DoPESelSetup(self.hdl, 1, None, ctypes.byref(tan), ctypes.byref(tan))
        
        # DoPE.pdf V2.88: DoPEOn(DoPE_HANDLE, WORD* lpusTAN)
        self.do_ctrl.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
        self.do_ctrl.DoPEOn(self.hdl, None)
        
        # DoPE.pdf V2.88: DoPETransmitData(DoPE_HANDLE, unsigned short Enable, WORD* lpusTAN)
        self.do_ctrl.DoPETransmitData.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_ushort)]
        self.do_ctrl.DoPETransmitData(self.hdl, 1, None)
        
        # 3. 定义控制函数
        # DoPE.pdf V2.88: DoPEFMove(DoPE_HANDLE, unsigned short Direction, unsigned short MoveCtrl, double Speed, WORD* lpusTAN)
        self.do_ctrl.DoPEFMove.argtypes = [
            ctypes.c_ulong,
            ctypes.c_ushort,
            ctypes.c_ushort,
            ctypes.c_double,
            ctypes.POINTER(ctypes.c_ushort),
        ]
        self.do_ctrl.DoPEPos = getattr(self.do_ctrl, 'DoPEPos', None)
        if self.do_ctrl.DoPEPos:
            # DoPE.pdf V2.88: DoPEPos(DoPE_HANDLE, unsigned short MoveCtrl, double Speed, double Destination, WORD* lpusTAN)
            self.do_ctrl.DoPEPos.argtypes = [
                ctypes.c_ulong,
                ctypes.c_ushort,
                ctypes.c_double,
                ctypes.c_double,
                ctypes.POINTER(ctypes.c_ushort),
            ]
        
        # 修正: Halt 通常只要1个参数，但我加了兼容处理
        self.do_ctrl.DoPEHalt.argtypes = [ctypes.c_ulong] 

        # DoPEGetData is used in the background loop
        if hasattr(self.do_ctrl, "DoPEGetData"):
            self.do_ctrl.DoPEGetData.argtypes = [ctypes.c_ulong, ctypes.POINTER(DoPEData)]
            self.do_ctrl.DoPEGetData.restype = ctypes.c_ulong

        self.log("初始化完成")
        self._set_controls_enabled(True)

    def update_data_loop(self):
        data = DoPEData()
        while self._running:
            try:
                # 调用你的 DLL 读取函数
                self.do_ctrl.DoPEGetData(self.hdl, ctypes.byref(data))
                
                # 【关键】将数据打包，发送信号给主线程
                # 不要在这里直接 setText
                info = {
                    "time": data.Time,
                    "pos": data.Position,
                    "force": data.Force,
                    "speed": data.Speed
                }
                self.data_received.emit(info)
                
            except Exception:
                pass
            time.sleep(0.1) # 10Hz 刷新

    def update_ui_data(self, info):
        # 这个函数运行在主线程，安全更新 UI
        self.lbl_time.setText(f"Time: {info['time']:.2f} s")
        self.lbl_position.setText(f"Position: {info['pos']:.3f} mm")
        self.lbl_force.setText(f"Force: {info['force']:.3f} N")
        self.lbl_speed.setText(f"Speed: {info['speed']:.3f} mm/s")

    def move_up(self):
        if not self.do_ctrl or not self.connected or not self.hdl.value:
            self.log("未连接：无法上移")
            return
        spd = self.speed_input.value() / 1000.0
        self.do_ctrl.DoPEFMove(self.hdl, 1, 0, spd, None) # 1=UP
        self.log("上移...")

    def move_down(self):
        if not self.do_ctrl or not self.connected or not self.hdl.value:
            self.log("未连接：无法下移")
            return
        spd = self.speed_input.value() / 1000.0
        self.do_ctrl.DoPEFMove(self.hdl, 2, 0, spd, None) # 2=DOWN
        self.log("下移...")

    def stop_move(self):
        if not self.do_ctrl or not self.connected or not self.hdl.value:
            self.log("未连接：无法停止")
            return
        self.do_ctrl.DoPEFMove(self.hdl, 0, 0, 0.0, None) # 0=HALT
        self.log("停止")

    def move_to_pos(self):
        if not self.do_ctrl or not self.connected or not self.hdl.value:
            self.log("未连接：无法定点移动")
            return
        target = self.pos_input.value() / 1000.0
        spd = self.speed_input.value() / 1000.0
        if self.do_ctrl.DoPEPos:
            self.do_ctrl.DoPEPos(self.hdl, 0, spd, target, None)
            self.log(f"移动到 {self.pos_input.value()}mm")

    def closeEvent(self, event):
        self._running = False
        if self.do_ctrl and self.hdl and self.hdl.value:
            try:
                self.do_ctrl.DoPEHalt(self.hdl)
            except Exception:
                pass
            if hasattr(self.do_ctrl, 'DoPECloseLink'):
                try:
                    self.do_ctrl.DoPECloseLink(self.hdl)
                except Exception:
                    pass
        event.accept()

if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    panel = DopeUINew()
    panel.show()
    sys.exit(app.exec_())