#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DoPE GetData 简易UI面板
- 实时显示采集到的 SampleTime、Position、Force
- 提供上下移动按钮和速度调节
"""
import sys
import ctypes
import threading
import time
from pathlib import Path
from PyQt5 import QtWidgets, QtCore

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"

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

class DopeGetDataPanel(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("DoPE GetData 面板")
        self.setGeometry(200, 200, 400, 300)
        self.init_ui()
        self.init_dope()
        self._running = True
        self._thread = threading.Thread(target=self.update_data_loop, daemon=True)
        self._thread.start()

    def init_ui(self):
        main_layout = QtWidgets.QHBoxLayout()
        left_col = QtWidgets.QVBoxLayout()
        right_col = QtWidgets.QVBoxLayout()

        # 参数显示区
        param_group = QtWidgets.QGroupBox("参数")
        param_layout = QtWidgets.QGridLayout()
        self.lbl_sampletime = QtWidgets.QLabel("SampleTime: --")
        self.lbl_position = QtWidgets.QLabel("Position: --")
        self.lbl_force = QtWidgets.QLabel("Force: --")
        param_layout.addWidget(self.lbl_sampletime, 0, 0)
        param_layout.addWidget(self.lbl_position, 1, 0)
        param_layout.addWidget(self.lbl_force, 2, 0)
        param_group.setLayout(param_layout)
        right_col.addWidget(param_group)

        # 日志区
        self.log_label = QtWidgets.QLabel("日志")
        self.log_label.setStyleSheet("font-weight: bold;")
        self.log_text = QtWidgets.QTextEdit()
        self.log_text.setReadOnly(True)
        self.log_text.setMinimumWidth(320)
        right_col.addWidget(self.log_label)
        right_col.addWidget(self.log_text)

        # 速度调节
        speed_group = QtWidgets.QGroupBox("连续移动 (FMove)")
        speed_layout = QtWidgets.QGridLayout()
        speed_layout.addWidget(QtWidgets.QLabel("速度 (mm/s):"), 0, 0)
        self.speed_input = QtWidgets.QSpinBox()
        self.speed_input.setRange(1, 100)
        self.speed_input.setValue(10)
        speed_layout.addWidget(self.speed_input, 0, 1)
        # 上下移动按钮
        self.btn_up = QtWidgets.QPushButton("▲ 上移")
        self.btn_down = QtWidgets.QPushButton("▼ 下移")
        self.btn_up.pressed.connect(self.move_up)
        self.btn_down.pressed.connect(self.move_down)
        self.btn_up.released.connect(self.stop_move)
        self.btn_down.released.connect(self.stop_move)
        speed_layout.addWidget(self.btn_up, 1, 0, 1, 2)
        speed_layout.addWidget(self.btn_down, 2, 0, 1, 2)
        speed_group.setLayout(speed_layout)
        left_col.addWidget(speed_group)

        # 定点移动
        pos_group = QtWidgets.QGroupBox("定点移动 (Pos)")
        pos_layout = QtWidgets.QGridLayout()
        pos_layout.addWidget(QtWidgets.QLabel("目标位置 (mm):"), 0, 0)
        self.pos_input = QtWidgets.QDoubleSpinBox()
        self.pos_input.setRange(-100, 100)
        self.pos_input.setValue(0)
        self.pos_input.setSingleStep(0.1)
        self.pos_input.setDecimals(2)
        pos_layout.addWidget(self.pos_input, 0, 1)
        pos_layout.addWidget(QtWidgets.QLabel("速度 (mm/s):"), 1, 0)
        self.pos_speed_input = QtWidgets.QSpinBox()
        self.pos_speed_input.setRange(1, 100)
        self.pos_speed_input.setValue(20)
        pos_layout.addWidget(self.pos_speed_input, 1, 1)
        self.btn_move_to = QtWidgets.QPushButton("移动到目标位置")
        self.btn_move_to.clicked.connect(self.move_to_position)
        pos_layout.addWidget(self.btn_move_to, 2, 0, 1, 2)
        self.btn_home = QtWidgets.QPushButton("回到原点")
        self.btn_home.clicked.connect(self.go_home)
        pos_layout.addWidget(self.btn_home, 3, 0, 1, 2)
        pos_group.setLayout(pos_layout)
        left_col.addWidget(pos_group)

        # 控制按钮
        ctrl_layout = QtWidgets.QHBoxLayout()
        self.btn_stop = QtWidgets.QPushButton("停止")
        self.btn_stop.setStyleSheet("background-color: #ff4444; color: white; font-weight: bold;")
        self.btn_stop.clicked.connect(self.stop_move)
        ctrl_layout.addWidget(self.btn_stop)
        self.btn_disconnect = QtWidgets.QPushButton("断开")
        self.btn_disconnect.clicked.connect(self.disconnect)
        ctrl_layout.addWidget(self.btn_disconnect)
        left_col.addLayout(ctrl_layout)
        left_col.addStretch()

        main_layout.addLayout(left_col, 2)
        main_layout.addLayout(right_col, 3)
        self.setLayout(main_layout)

    def log(self, message):
        from datetime import datetime
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.log_text.append(f"[{timestamp}] {message}")
        self.log_text.verticalScrollBar().setValue(self.log_text.verticalScrollBar().maximum())

    def move_to_position(self):
        pos = self.pos_input.value()
        speed = self.pos_speed_input.value()
        pos_m = pos / 1000.0
        speed_m = speed / 1000.0
        if hasattr(self.do_ctrl, 'DoPEPos'):
            self.do_ctrl.DoPEPos.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_double, ctypes.c_double, ctypes.c_void_p]
            self.do_ctrl.DoPEPos.restype = ctypes.c_ulong
            err = self.do_ctrl.DoPEPos(self.hdl, self.CTRL_POS, speed_m, pos_m, None)
            if err == 0x0000:
                self.log(f"移动到 {pos:.2f} mm (速度: {speed} mm/s) - 成功")
            else:
                self.log(f"移动到 {pos:.2f} mm (速度: {speed} mm/s) - 失败: 0x{err:04x}")

    def go_home(self):
        speed = self.pos_speed_input.value()
        speed_m = speed / 1000.0
        if hasattr(self.do_ctrl, 'DoPEPos'):
            self.do_ctrl.DoPEPos.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_double, ctypes.c_double, ctypes.c_void_p]
            self.do_ctrl.DoPEPos.restype = ctypes.c_ulong
            err = self.do_ctrl.DoPEPos(self.hdl, self.CTRL_POS, speed_m, 0.0, None)
            if err == 0x0000:
                self.log(f"回到原点 (速度: {speed} mm/s) - 成功")
            else:
                self.log(f"回到原点 (速度: {speed} mm/s) - 失败: 0x{err:04x}")

    def disconnect(self):
        # 安全断开
        if hasattr(self.do_ctrl, 'DoPEHalt'):
            self.do_ctrl.DoPEHalt.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
            self.do_ctrl.DoPEHalt.restype = ctypes.c_ulong
            self.do_ctrl.DoPEHalt(self.hdl, 0)
        if hasattr(self.do_ctrl, 'DoPEEmergencyOff'):
            self.do_ctrl.DoPEEmergencyOff.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
            self.do_ctrl.DoPEEmergencyOff.restype = ctypes.c_ulong
            self.do_ctrl.DoPEEmergencyOff(self.hdl, 0)
        if hasattr(self.do_ctrl, 'DoPECloseLink'):
            self.do_ctrl.DoPECloseLink.argtypes = [ctypes.c_ulong]
            self.do_ctrl.DoPECloseLink.restype = ctypes.c_ulong
            self.do_ctrl.DoPECloseLink(self.hdl)
        self._running = False
        self.log("已安全断开设备")
        self.setEnabled(False)

    def init_dope(self):
        self.do_ctrl = ctypes.WinDLL(str(DLL_PATH))
        self.hdl = ctypes.c_ulong(0)
        # OpenLink
        self.do_ctrl.DoPEOpenLink.argtypes = [
            ctypes.c_ulong, ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort,
            ctypes.c_ushort, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ulong)
        ]
        self.do_ctrl.DoPEOpenLink.restype = ctypes.c_ulong
        err = self.do_ctrl.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(self.hdl))
        if err != 0x0000:
            QtWidgets.QMessageBox.critical(self, "连接失败", f"OpenLink failed: 0x{err:04x}")
            sys.exit(1)
        # SetNotification
        self.do_ctrl.DoPESetNotification.argtypes = [
            ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint
        ]
        self.do_ctrl.DoPESetNotification.restype = ctypes.c_ulong
        self.do_ctrl.DoPESetNotification(self.hdl, 0xffffffff, None, None, 0)
        # SelSetup
        self.do_ctrl.DoPESelSetup.argtypes = [
            ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)
        ]
        self.do_ctrl.DoPESelSetup.restype = ctypes.c_ulong
        tan_first = ctypes.c_ushort(0)
        tan_last = ctypes.c_ushort(0)
        err = self.do_ctrl.DoPESelSetup(self.hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
        if err != 0x0000:
            QtWidgets.QMessageBox.critical(self, "连接失败", f"SelSetup failed: 0x{err:04x}")
            sys.exit(1)
        # 启动控制器
        self.do_ctrl.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
        self.do_ctrl.DoPEOn.restype = ctypes.c_ulong
        self.do_ctrl.DoPEOn(self.hdl, None)
        self.do_ctrl.DoPECtrlTestValues.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
        self.do_ctrl.DoPECtrlTestValues.restype = ctypes.c_ulong
        self.do_ctrl.DoPECtrlTestValues(self.hdl, 0)
        self.do_ctrl.DoPETransmitData.argtypes = [
            ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_ushort)
        ]
        self.do_ctrl.DoPETransmitData.restype = ctypes.c_ulong
        self.do_ctrl.DoPETransmitData(self.hdl, 1, None)
        # 控制接口
        self.do_ctrl.DoPEFMove.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_double, ctypes.c_void_p]
        self.do_ctrl.DoPEFMove.restype = ctypes.c_ulong
        self.do_ctrl.DoPEGetData.argtypes = [ctypes.c_ulong, ctypes.POINTER(DoPEData)]
        self.do_ctrl.DoPEGetData.restype = ctypes.c_ulong
        self.MOVE_HALT = 0
        self.MOVE_UP = 1
        self.MOVE_DOWN = 2
        self.CTRL_POS = 0

    def update_data_loop(self):
        data = DoPEData()
        while self._running:
            err = self.do_ctrl.DoPEGetData(self.hdl, ctypes.byref(data))
            if err == 0x0000:
                self.lbl_sampletime.setText(f"SampleTime: {data.SampleTime:.2f}")
                self.lbl_position.setText(f"Position: {data.Position:.4f}")
                self.lbl_force.setText(f"Force: {data.Force:.4f}")
            else:
                self.lbl_sampletime.setText("SampleTime: --")
                self.lbl_position.setText("Position: --")
                self.lbl_force.setText("Force: --")
            time.sleep(0.2)

    def move_up(self):
        speed = self.speed_input.value()
        speed_m = speed / 1000.0
        self.do_ctrl.DoPEFMove(self.hdl, self.MOVE_UP, self.CTRL_POS, speed_m, None)

    def move_down(self):
        speed = self.speed_input.value()
        speed_m = speed / 1000.0
        self.do_ctrl.DoPEFMove(self.hdl, self.MOVE_DOWN, self.CTRL_POS, speed_m, None)

    def stop_move(self):
        self.do_ctrl.DoPEFMove(self.hdl, self.MOVE_HALT, self.CTRL_POS, 0.0, None)

    def closeEvent(self, event):
        self._running = False
        self.stop_move()
        event.accept()

if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    panel = DopeGetDataPanel()
    panel.show()
    sys.exit(app.exec_())
