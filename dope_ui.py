#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DoPE 控制面板 - 简洁版
包含 DoPEFMove（连续移动）和 DoPEPos（定点移动）功能
"""
import sys
import os
import subprocess
import ctypes
from pathlib import Path
from PyQt5 import QtWidgets, QtCore, QtGui

# 多语言文案
LANG_MAP = {
    "zh": {
        "lang_name": "中文",
        "window_title": "DoPE 控制面板",
        "status_group": "设备状态",
        "status_connected": "✓ 已连接",
        "status_disconnected": "未连接",
        "status_failed": "✗ 连接失败",
        "move_group": "连续移动 (DoPEFMove)",
        "move_speed": "速度",
        "move_up": "▲ 向上移动",
        "move_down": "▼ 向下移动",
        "pos_group": "定点移动 (DoPEPos)",
        "pos_position": "目标位置",
        "pos_speed": "速度",
        "pos_go": "移动到目标位置",
        "pos_home": "⌂ 回到原点",
        "stop": "■ 停止",
        "exit": "✕ 退出",
        "log": "操作日志",
        "connect_fail_title": "连接失败",
        "log_connect_ok": "连接成功",
        "log_connect_fail": "连接失败",
        "log_move_up": "向上移动 (速度: {speed} mm/s) - {msg}",
        "log_move_down": "向下移动 (速度: {speed} mm/s) - {msg}",
        "log_stop": "自动停止 - {msg}",
        "log_stop_manual": "紧急停止 - {msg}",
        "log_move_to": "移动到 {pos:.2f} mm (速度: {speed} mm/s) - {msg}",
        "log_home": "回到原点 (速度: {speed} mm/s) - {msg}",
            "cmd_success": "命令发送成功",
    },
    "en": {
        "lang_name": "English",
        "window_title": "DoPE Control Panel",
        "status_group": "Device Status",
        "status_connected": "✓ Connected",
        "status_disconnected": "Disconnected",
        "status_failed": "✗ Connection Failed",
        "move_group": "Continuous Move (DoPEFMove)",
        "move_speed": "Speed",
        "move_up": "▲ Move Up",
        "move_down": "▼ Move Down",
        "pos_group": "Position Move (DoPEPos)",
        "pos_position": "Target Position",
        "pos_speed": "Speed",
        "pos_go": "Move to Target",
        "pos_home": "⌂ Home",
        "stop": "■ Stop",
        "exit": "✕ Exit",
        "log": "Log",
        "connect_fail_title": "Connection Failed",
        "log_connect_ok": "Connected",
        "log_connect_fail": "Connection failed",
        "log_move_up": "Move Up (speed: {speed} mm/s) - {msg}",
        "log_move_down": "Move Down (speed: {speed} mm/s) - {msg}",
        "log_stop": "Auto stop - {msg}",
        "log_stop_manual": "Emergency stop - {msg}",
        "log_move_to": "Move to {pos:.2f} mm (speed: {speed} mm/s) - {msg}",
        "log_home": "Home (speed: {speed} mm/s) - {msg}",
        "cmd_success": "Command sent",
    },
    "de": {
        "lang_name": "Deutsch",
        "window_title": "DoPE Bedienfeld",
        "status_group": "Gerätestatus",
        "status_connected": "✓ Verbunden",
        "status_disconnected": "Nicht verbunden",
        "status_failed": "✗ Verbindung fehlgeschlagen",
        "move_group": "Dauerlauf (DoPEFMove)",
        "move_speed": "Geschwindigkeit",
        "move_up": "▲ Aufwärts",
        "move_down": "▼ Abwärts",
        "pos_group": "Positionsfahrt (DoPEPos)",
        "pos_position": "Zielposition",
        "pos_speed": "Geschwindigkeit",
        "pos_go": "Zum Ziel fahren",
        "pos_home": "⌂ Referenz",
        "stop": "■ Stopp",
        "exit": "✕ Beenden",
        "log": "Protokoll",
        "connect_fail_title": "Verbindung fehlgeschlagen",
        "log_connect_ok": "Verbunden",
        "log_connect_fail": "Verbindung fehlgeschlagen",
        "log_move_up": "Aufwärts (Geschw.: {speed} mm/s) - {msg}",
        "log_move_down": "Abwärts (Geschw.: {speed} mm/s) - {msg}",
        "log_stop": "Auto-Stopp - {msg}",
        "log_stop_manual": "Not-Stopp - {msg}",
        "log_move_to": "Fahre zu {pos:.2f} mm (Geschw.: {speed} mm/s) - {msg}",
        "log_home": "Referenzfahrt (Geschw.: {speed} mm/s) - {msg}",
        "cmd_success": "Befehl gesendet",
    },
}

# 检查是否用 32 位 Python；如果不是，重新启动自己
if sys.maxsize > 2**32:
    # 64 位，重新用 32 位 Python 启动
    venv32_python = os.path.join(os.path.dirname(__file__), ".venv32", "Scripts", "python.exe")
    if os.path.exists(venv32_python):
        subprocess.call([venv32_python, __file__] + sys.argv[1:])
        sys.exit(0)
    else:
        print("错误: 找不到 32 位 Python (.venv32)")
        sys.exit(1)

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"

class DopeController:
    """DoPE 设备控制器"""

    def disconnect(self):
        """安全断开设备，顺序: DoPEHalt → DoPEEmergencyOff → DoPECloseLink"""
        if not self.connected or not self.dope:
            return
        try:
            # DoPEHalt
            if hasattr(self.dope, 'DoPEHalt'):
                self.dope.DoPEHalt.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
                self.dope.DoPEHalt.restype = ctypes.c_ulong
                self.dope.DoPEHalt(self.hdl, 0)
            # DoPEEmergencyOff（可选）
            if hasattr(self.dope, 'DoPEEmergencyOff'):
                self.dope.DoPEEmergencyOff.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
                self.dope.DoPEEmergencyOff.restype = ctypes.c_ulong
                self.dope.DoPEEmergencyOff(self.hdl, 0)
            # DoPECloseLink
            if hasattr(self.dope, 'DoPECloseLink'):
                self.dope.DoPECloseLink.argtypes = [ctypes.c_ulong]
                self.dope.DoPECloseLink.restype = ctypes.c_ulong
                self.dope.DoPECloseLink(self.hdl)
        except Exception as e:
            pass
        self.connected = False
    
    def __init__(self):
        self.dope = None
        self.hdl = ctypes.c_ulong(0)
        self.connected = False
        
        # 常量
        self.MOVE_HALT = 0
        self.MOVE_UP = 1
        self.MOVE_DOWN = 2
        self.CTRL_POS = 0
        self.DoPERR_NOERROR = 0x0000
        
    def connect(self):
        """连接设备"""
        try:
            self.dope = ctypes.WinDLL(str(DLL_PATH))
            
            # DoPEOpenLink
            self.dope.DoPEOpenLink.argtypes = [
                ctypes.c_ulong, ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort,
                ctypes.c_ushort, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ulong)
            ]
            self.dope.DoPEOpenLink.restype = ctypes.c_ulong
            
            err = self.dope.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(self.hdl))
            if err != self.DoPERR_NOERROR:
                return False, f"OpenLink 失败: 0x{err:04x}"
            
            # DoPESetNotification
            self.dope.DoPESetNotification.argtypes = [
                ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint
            ]
            self.dope.DoPESetNotification.restype = ctypes.c_ulong
            self.dope.DoPESetNotification(self.hdl, 0xffffffff, None, None, 0)
            
            # DoPESelSetup
            self.dope.DoPESelSetup.argtypes = [
                ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p,
                ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)
            ]
            self.dope.DoPESelSetup.restype = ctypes.c_ulong
            tan_first = ctypes.c_ushort(0)
            tan_last = ctypes.c_ushort(0)
            err = self.dope.DoPESelSetup(self.hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
            if err != self.DoPERR_NOERROR:
                return False, f"SelSetup 失败: 0x{err:04x}"
            
            # 启动控制器
            self.dope.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
            self.dope.DoPEOn.restype = ctypes.c_ulong
            self.dope.DoPEOn(self.hdl, None)
            
            self.dope.DoPECtrlTestValues.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
            self.dope.DoPECtrlTestValues.restype = ctypes.c_ulong
            self.dope.DoPECtrlTestValues(self.hdl, 0)
            
            self.dope.DoPETransmitData.argtypes = [
                ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_ushort)
            ]
            self.dope.DoPETransmitData.restype = ctypes.c_ulong
            self.dope.DoPETransmitData(self.hdl, 1, None)
            
            # DoPEFMove
            self.dope.DoPEFMove.argtypes = [
                ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_double, ctypes.c_void_p
            ]
            self.dope.DoPEFMove.restype = ctypes.c_ulong
            
            # DoPEPos
            self.dope.DoPEPos.argtypes = [
                ctypes.c_ulong, ctypes.c_ushort, ctypes.c_double, ctypes.c_double, ctypes.c_void_p
            ]
            self.dope.DoPEPos.restype = ctypes.c_ulong
            
            self.connected = True
            return True, "connected"
            
        except Exception as e:
            return False, f"连接异常: {e}"
    
    def move_continuous(self, direction, speed):
        """连续移动"""
        if not self.connected:
            return False, "设备未连接"
        
        try:
            speed_m = speed / 1000.0  # mm/s -> m/s
            err = self.dope.DoPEFMove(self.hdl, direction, self.CTRL_POS, speed_m, None)
            if err == self.DoPERR_NOERROR:
                return True, "success"
            else:
                return False, f"命令失败: 0x{err:04x}"
        except Exception as e:
            return False, f"异常: {e}"
    
    def move_to_position(self, position, speed):
        """定点移动"""
        if not self.connected:
            return False, "设备未连接"
        
        try:
            pos_m = position / 1000.0  # mm -> m
            speed_m = speed / 1000.0   # mm/s -> m/s
            err = self.dope.DoPEPos(self.hdl, self.CTRL_POS, speed_m, pos_m, None)
            if err == self.DoPERR_NOERROR:
                return True, "success"
            else:
                return False, f"命令失败: 0x{err:04x}"
        except Exception as e:
            return False, f"异常: {e}"
    
    def stop(self):
        """停止运动"""
        return self.move_continuous(self.MOVE_HALT, 0)


class DopeControlPanel(QtWidgets.QWidget):
    """DoPE 控制面板"""
    
    def __init__(self):
        super().__init__()
        self.controller = DopeController()
        self.lang = "zh"
        # 先初始化控件
        self.init_ui()
        # 再连接设备，避免log_text未初始化
        self.connect_device()

    def _t(self, key):
        return LANG_MAP[self.lang].get(key, key)

    def _translate_msg(self, msg):
        if msg == "success":
            return self._t("cmd_success")
        if msg == "connected":
            return self._t("log_connect_ok")
        return msg

    def apply_language(self):
        """刷新所有文案"""
        self.setWindowTitle(self._t("window_title"))
        self.status_group.setTitle(self._t("status_group"))
        if self.controller.connected:
            self.status_label.setText(self._t("status_connected"))
            self.status_label.setStyleSheet("font-weight: bold; color: green;")
        else:
            self.status_label.setText(self._t("status_disconnected"))
            self.status_label.setStyleSheet("font-weight: bold; color: red;")
        self.move_group.setTitle(self._t("move_group"))
        self.lbl_move_speed.setText(f"{self._t('move_speed')}:")
        self.btn_move_up.setText(self._t("move_up"))
        self.btn_move_down.setText(self._t("move_down"))
        self.pos_group.setTitle(self._t("pos_group"))
        self.lbl_pos_position.setText(f"{self._t('pos_position')}:")
        self.lbl_pos_speed.setText(f"{self._t('pos_speed')}:")
        self.btn_move_to.setText(self._t("pos_go"))
        self.btn_go_home.setText(self._t("pos_home"))
        self.btn_stop.setText(self._t("stop"))
        self.log_label.setText(self._t("log"))

    def on_language_changed(self, _index):
        self.lang = self.lang_combo.currentData()
        self.apply_language()
        
    def init_ui(self):
        """初始化界面"""
        self.setWindowTitle(self._t("window_title"))
        self.setGeometry(100, 100, 900, 520)
        
        # 主体左右分栏
        main_layout = QtWidgets.QHBoxLayout()
        left_col = QtWidgets.QVBoxLayout()
        right_col = QtWidgets.QVBoxLayout()
        
        # 状态栏 + 语言切换
        self.status_group = QtWidgets.QGroupBox(self._t("status_group"))
        status_layout = QtWidgets.QHBoxLayout()
        self.status_label = QtWidgets.QLabel(self._t("status_disconnected"))
        self.status_label.setStyleSheet("font-weight: bold; color: red;")
        status_layout.addWidget(self.status_label)
        status_layout.addStretch()
        self.lang_combo = QtWidgets.QComboBox()
        self.lang_combo.addItem(LANG_MAP["zh"]["lang_name"], "zh")
        self.lang_combo.addItem(LANG_MAP["en"]["lang_name"], "en")
        self.lang_combo.addItem(LANG_MAP["de"]["lang_name"], "de")
        self.lang_combo.currentIndexChanged.connect(self.on_language_changed)
        status_layout.addWidget(self.lang_combo)
        self.status_group.setLayout(status_layout)
        left_col.addWidget(self.status_group)
        
        # DoPEFMove 区域 - 连续移动
        self.move_group = QtWidgets.QGroupBox(self._t("move_group"))
        move_layout = QtWidgets.QGridLayout()

        # 速度输入（单位放在外侧）
        self.lbl_move_speed = QtWidgets.QLabel(f"{self._t('move_speed')}:" )
        move_layout.addWidget(self.lbl_move_speed, 0, 0)
        self.move_speed_input = QtWidgets.QSpinBox()
        self.move_speed_input.setRange(1, 100)
        self.move_speed_input.setValue(10)
        move_layout.addWidget(self.move_speed_input, 0, 1)
        self.lbl_move_speed_unit = QtWidgets.QLabel("mm/s")
        move_layout.addWidget(self.lbl_move_speed_unit, 0, 2)
        
        # 向上/向下按钮
        self.btn_move_up = QtWidgets.QPushButton(self._t("move_up"))
        self.btn_move_up.setMinimumHeight(50)
        self.btn_move_up.pressed.connect(self.on_move_up_pressed)
        self.btn_move_up.released.connect(self.on_move_released)
        move_layout.addWidget(self.btn_move_up, 1, 0, 1, 3)
        
        self.btn_move_down = QtWidgets.QPushButton(self._t("move_down"))
        self.btn_move_down.setMinimumHeight(50)
        self.btn_move_down.pressed.connect(self.on_move_down_pressed)
        self.btn_move_down.released.connect(self.on_move_released)
        move_layout.addWidget(self.btn_move_down, 2, 0, 1, 3)
        
        self.move_group.setLayout(move_layout)
        left_col.addWidget(self.move_group)
        
        # DoPEPos 区域 - 定点移动
        self.pos_group = QtWidgets.QGroupBox(self._t("pos_group"))
        pos_layout = QtWidgets.QGridLayout()

        # 位置输入（单位外侧）
        self.lbl_pos_position = QtWidgets.QLabel(f"{self._t('pos_position')}:" )
        pos_layout.addWidget(self.lbl_pos_position, 0, 0)
        self.pos_position_input = QtWidgets.QDoubleSpinBox()
        self.pos_position_input.setRange(-100, 100)
        self.pos_position_input.setValue(0)
        self.pos_position_input.setSingleStep(0.1)
        self.pos_position_input.setDecimals(2)
        pos_layout.addWidget(self.pos_position_input, 0, 1)
        self.lbl_pos_position_unit = QtWidgets.QLabel("mm")
        pos_layout.addWidget(self.lbl_pos_position_unit, 0, 2)
        
        # 速度输入（单位外侧）
        self.lbl_pos_speed = QtWidgets.QLabel(f"{self._t('pos_speed')}:" )
        pos_layout.addWidget(self.lbl_pos_speed, 1, 0)
        self.pos_speed_input = QtWidgets.QSpinBox()
        self.pos_speed_input.setRange(1, 100)
        self.pos_speed_input.setValue(20)
        pos_layout.addWidget(self.pos_speed_input, 1, 1)
        self.lbl_pos_speed_unit = QtWidgets.QLabel("mm/s")
        pos_layout.addWidget(self.lbl_pos_speed_unit, 1, 2)
        
        # 移动按钮
        self.btn_move_to = QtWidgets.QPushButton(self._t("pos_go"))
        self.btn_move_to.setMinimumHeight(40)
        self.btn_move_to.clicked.connect(self.on_move_to_position)
        pos_layout.addWidget(self.btn_move_to, 2, 0, 1, 3)
        
        # 回原点按钮
        self.btn_go_home = QtWidgets.QPushButton(self._t("pos_home"))
        self.btn_go_home.setMinimumHeight(40)
        self.btn_go_home.clicked.connect(self.on_go_home)
        pos_layout.addWidget(self.btn_go_home, 3, 0, 1, 3)
        
        self.pos_group.setLayout(pos_layout)
        left_col.addWidget(self.pos_group)
        
        # 控制按钮区域
        control_layout = QtWidgets.QHBoxLayout()
        
        self.btn_stop = QtWidgets.QPushButton(self._t("stop"))
        self.btn_stop.setMinimumHeight(50)
        self.btn_stop.setStyleSheet("background-color: #ff4444; color: white; font-weight: bold;")
        self.btn_stop.clicked.connect(self.on_stop)
        control_layout.addWidget(self.btn_stop)
        

        self.btn_disconnect = QtWidgets.QPushButton("断开")
        self.btn_disconnect.setMinimumHeight(50)
        self.btn_disconnect.clicked.connect(self.on_disconnect)
        control_layout.addWidget(self.btn_disconnect)

        left_col.addLayout(control_layout)
        left_col.addStretch()

        # 右侧日志区域（更大）
        self.log_label = QtWidgets.QLabel(self._t("log"))
        self.log_label.setStyleSheet("font-weight: bold;")
        self.log_text = QtWidgets.QTextEdit()
        self.log_text.setReadOnly(True)
        self.log_text.setMinimumWidth(320)
        right_col.addWidget(self.log_label)
        right_col.addWidget(self.log_text)

        main_layout.addLayout(left_col, 2)
        main_layout.addLayout(right_col, 3)

        self.setLayout(main_layout)
        self.apply_language()

    def on_disconnect(self):
        """断开按钮：安全断开设备"""
        self.controller.disconnect()
        self.status_label.setText(self._t("status_disconnected"))
        self.status_label.setStyleSheet("font-weight: bold; color: red;")
        self.log("[断开] 已安全断开设备")
        # 可选：禁用操作区，防止误操作
        self.setEnabled(False)
        
    def connect_device(self):
        """连接设备"""
        success, msg = self.controller.connect()
        if success:
            msg_t = self._translate_msg(msg)
            self.status_label.setText(self._t("status_connected"))
            self.status_label.setStyleSheet("font-weight: bold; color: green;")
            self.log(f"✓ {self._t('log_connect_ok')}: {msg_t}")
        else:
            self.status_label.setText(self._t("status_failed"))
            self.status_label.setStyleSheet("font-weight: bold; color: red;")
            self.log(f"✗ {self._t('log_connect_fail')}: {msg}")
            QtWidgets.QMessageBox.warning(self, self._t("connect_fail_title"), msg)
    
    def log(self, message):
        """记录日志"""
        from datetime import datetime
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.log_text.append(f"[{timestamp}] {message}")
        # 自动滚动到底部
        self.log_text.verticalScrollBar().setValue(
            self.log_text.verticalScrollBar().maximum()
        )
    
    def on_move_up_pressed(self):
        """向上按钮按下"""
        speed = self.move_speed_input.value()
        success, msg = self.controller.move_continuous(self.controller.MOVE_UP, speed)
        self.log(self._t("log_move_up").format(speed=speed, msg=self._translate_msg(msg)))
    
    def on_move_down_pressed(self):
        """向下按钮按下"""
        speed = self.move_speed_input.value()
        success, msg = self.controller.move_continuous(self.controller.MOVE_DOWN, speed)
        self.log(self._t("log_move_down").format(speed=speed, msg=self._translate_msg(msg)))
    
    def on_move_released(self):
        """移动按钮释放 - 自动停止"""
        success, msg = self.controller.stop()
        self.log(self._t("log_stop").format(msg=self._translate_msg(msg)))
    
    def on_move_to_position(self):
        """移动到目标位置"""
        position = self.pos_position_input.value()
        speed = self.pos_speed_input.value()
        success, msg = self.controller.move_to_position(position, speed)
        self.log(self._t("log_move_to").format(pos=position, speed=speed, msg=self._translate_msg(msg)))
    
    def on_go_home(self):
        """回到原点"""
        speed = self.pos_speed_input.value()
        success, msg = self.controller.move_to_position(0, speed)
        self.log(self._t("log_home").format(speed=speed, msg=self._translate_msg(msg)))
    def on_stop(self):
        """停止按钮"""
        success, msg = self.controller.stop()
        self.log(self._t("log_stop_manual").format(msg=self._translate_msg(msg)))
    
    def closeEvent(self, event):
        """关闭窗口前安全断开设备"""
        self.controller.disconnect()
        event.accept()


def main():
    app = QtWidgets.QApplication(sys.argv)
    
    # 设置应用样式
    app.setStyle('Fusion')
    
    panel = DopeControlPanel()
    panel.show()
    
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
