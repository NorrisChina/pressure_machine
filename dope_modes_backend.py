#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DoPE Position/Speed 模式后端测试
- 支持 Position/Speed 两种模式切换
- 实时读取 position/force
- 控制接口独立，便于后续集成 UI
"""
import ctypes
import time
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
do_ctrl = ctypes.WinDLL(str(DLL_PATH))

# 常量
CTRL_POS = 0
CTRL_LOAD = 1
CTRL_EXTENSION = 2
MOVE_HALT = 0
MOVE_UP = 1
MOVE_DOWN = 2
DoPERR_NOERROR = 0x0000

class DoPEBackend:
    def __init__(self):
        self.hdl = ctypes.c_ulong(0)
        self.connected = False
        self._init_dll()

    def _init_dll(self):
        # OpenLink
        do_ctrl.DoPEOpenLink.argtypes = [
            ctypes.c_ulong, ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort,
            ctypes.c_ushort, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ulong)
        ]
        do_ctrl.DoPEOpenLink.restype = ctypes.c_ulong
        err = do_ctrl.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(self.hdl))
        if err != DoPERR_NOERROR:
            raise RuntimeError(f"OpenLink failed: 0x{err:04x}")
        self.connected = True
        # SetNotification
        do_ctrl.DoPESetNotification.argtypes = [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint]
        do_ctrl.DoPESetNotification.restype = ctypes.c_ulong
        do_ctrl.DoPESetNotification(self.hdl, 0xffffffff, None, None, 0)
        # SelSetup
        do_ctrl.DoPESelSetup.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)]
        do_ctrl.DoPESelSetup.restype = ctypes.c_ulong
        tan_first = ctypes.c_ushort(0)
        tan_last = ctypes.c_ushort(0)
        err = do_ctrl.DoPESelSetup(self.hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
        if err != DoPERR_NOERROR:
            raise RuntimeError(f"SelSetup failed: 0x{err:04x}")
        # 启动控制器
        do_ctrl.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
        do_ctrl.DoPEOn.restype = ctypes.c_ulong
        do_ctrl.DoPEOn(self.hdl, None)
        do_ctrl.DoPECtrlTestValues.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
        do_ctrl.DoPECtrlTestValues.restype = ctypes.c_ulong
        do_ctrl.DoPECtrlTestValues(self.hdl, 0)
        do_ctrl.DoPETransmitData.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_ushort)]
        do_ctrl.DoPETransmitData.restype = ctypes.c_ulong
        do_ctrl.DoPETransmitData(self.hdl, 1, None)
        # 控制接口
        do_ctrl.DoPEPos.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_double, ctypes.c_double, ctypes.c_void_p]
        do_ctrl.DoPEPos.restype = ctypes.c_ulong
        do_ctrl.DoPEFMove.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_double, ctypes.c_void_p]
        do_ctrl.DoPEFMove.restype = ctypes.c_ulong
        do_ctrl.DoPEGetActValue.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_double), ctypes.c_void_p]
        do_ctrl.DoPEGetActValue.restype = ctypes.c_ulong

    def move_to_position(self, pos_mm, speed_mm):
        pos_m = pos_mm / 1000.0
        speed_m = speed_mm / 1000.0
        err = do_ctrl.DoPEPos(self.hdl, CTRL_POS, speed_m, pos_m, None)
        return err == DoPERR_NOERROR

    def move_with_speed(self, direction, speed_mm):
        speed_m = speed_mm / 1000.0
        err = do_ctrl.DoPEFMove(self.hdl, direction, CTRL_POS, speed_m, None)
        return err == DoPERR_NOERROR

    def stop(self):
        err = do_ctrl.DoPEFMove(self.hdl, MOVE_HALT, CTRL_POS, 0.0, None)
        return err == DoPERR_NOERROR

    def get_position(self):
        val = ctypes.c_double()
        err = do_ctrl.DoPEGetActValue(self.hdl, 0, ctypes.byref(val), None)
        if err == DoPERR_NOERROR:
            return val.value * 1000  # mm
        return None

    def get_force(self):
        val = ctypes.c_double()
        err = do_ctrl.DoPEGetActValue(self.hdl, 1, ctypes.byref(val), None)
        if err == DoPERR_NOERROR:
            return val.value  # N
        return None

if __name__ == "__main__":
    backend = DoPEBackend()
    print("DoPE 后端测试：Position/Speed模式")
    print("1. Position模式: 移动到 10mm, 速度 5mm/s")
    backend.move_to_position(10, 5)
    time.sleep(2)
    print(f"当前Position: {backend.get_position():.3f} mm, Force: {backend.get_force():.3f} N")
    print("2. Speed模式: 向上以 8mm/s 连续移动 2秒")
    backend.move_with_speed(MOVE_UP, 8)
    time.sleep(2)
    backend.stop()
    print(f"当前Position: {backend.get_position():.3f} mm, Force: {backend.get_force():.3f} N")
    print("测试完成")
