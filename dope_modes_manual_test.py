import threading
import sys
def print_raw_fields(data):
    print("\n[RAW DATA]")
    for field, _ in data._fields_:
        print(f"{field}: {getattr(data, field)}")

def move_to_position(do_ctrl, hdl, pos_mm, speed_mm):
    pos_m = pos_mm / 1000.0
    speed_m = speed_mm / 1000.0
    err = do_ctrl.DoPEPos(hdl, CTRL_POS, speed_m, pos_m, None)
    print(f"DoPEPos({pos_mm}mm, {speed_mm}mm/s) -> 0x{err:04x}")
    return err

def move_with_speed(do_ctrl, hdl, direction, speed_mm):
    speed_m = speed_mm / 1000.0
    err = do_ctrl.DoPEFMove(hdl, direction, CTRL_POS, speed_m, None)
    print(f"DoPEFMove({direction}, {speed_mm}mm/s) -> 0x{err:04x}")
    return err

def stop(do_ctrl, hdl):
    err = do_ctrl.DoPEFMove(hdl, MOVE_HALT, CTRL_POS, 0.0, None)
    print(f"STOP -> 0x{err:04x}")
    return err
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DoPE 后端手动模式测试
- 启动后保持连接，循环显示 position/force
- 支持命令行输入切换 Position/Speed 模式、手动调节参数
"""
import ctypes
import time
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
do_ctrl = ctypes.WinDLL(str(DLL_PATH))

CTRL_POS = 0
CTRL_LOAD = 1
CTRL_EXTENSION = 2
MOVE_HALT = 0
MOVE_UP = 1
MOVE_DOWN = 2
DoPERR_NOERROR = 0x0000


# --- 新结构体和数据读取方式 ---
class DoPEData(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Time", ctypes.c_double),
        ("Position", ctypes.c_double),
        ("Load", ctypes.c_double),
        ("Extension", ctypes.c_double),
        ("Speed", ctypes.c_double),
        ("Status", ctypes.c_long),
        ("Dummy", ctypes.c_byte * 20)
    ]

def dope_init():
    hdl = ctypes.c_ulong(0)
    # OpenLink
    do_ctrl.DoPEOpenLink.argtypes = [
        ctypes.c_ulong, ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort,
        ctypes.c_ushort, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ulong)
    ]
    do_ctrl.DoPEOpenLink.restype = ctypes.c_ulong
    err = do_ctrl.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl))
    if err != DoPERR_NOERROR:
        raise RuntimeError(f"OpenLink failed: 0x{err:04x}")
    # SetNotification
    do_ctrl.DoPESetNotification.argtypes = [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint]
    do_ctrl.DoPESetNotification.restype = ctypes.c_ulong
    do_ctrl.DoPESetNotification(hdl, 0xffffffff, None, None, 0)
    # SelSetup
    do_ctrl.DoPESelSetup.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)]
    do_ctrl.DoPESelSetup.restype = ctypes.c_ulong
    tan_first = ctypes.c_ushort(0)
    tan_last = ctypes.c_ushort(0)
    err = do_ctrl.DoPESelSetup(hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
    if err != DoPERR_NOERROR:
        raise RuntimeError(f"SelSetup failed: 0x{err:04x}")
    # 启动控制器
    do_ctrl.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
    do_ctrl.DoPEOn.restype = ctypes.c_ulong
    do_ctrl.DoPEOn(hdl, None)
    do_ctrl.DoPECtrlTestValues.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
    do_ctrl.DoPECtrlTestValues.restype = ctypes.c_ulong
    do_ctrl.DoPECtrlTestValues(hdl, 0)
    do_ctrl.DoPETransmitData.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_ushort)]
    do_ctrl.DoPETransmitData.restype = ctypes.c_ulong
    do_ctrl.DoPETransmitData(hdl, 1, None)
    # 控制接口
    do_ctrl.DoPEPos.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_double, ctypes.c_double, ctypes.c_void_p]
    do_ctrl.DoPEPos.restype = ctypes.c_ulong
    do_ctrl.DoPEFMove.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_double, ctypes.c_void_p]
    do_ctrl.DoPEFMove.restype = ctypes.c_ulong
    # 切换为 DoPEGetData 作为主数据读取接口
    do_ctrl.DoPEGetData.argtypes = [ctypes.c_ulong, ctypes.POINTER(DoPEData)]
    do_ctrl.DoPEGetData.restype = ctypes.c_ulong
    return hdl


if __name__ == "__main__":
    hdl = dope_init()
    data = DoPEData()
    print("DoPE 自动测试: DoPEGetData 采集 (Ctrl+C 退出)")
    speed = 10.0
    pos = 30.0
    try:
        # 1. 停止
        stop(do_ctrl, hdl)
        time.sleep(1)
        print("\n[等待你手动操作面板/外部控制...]")
        # 2. 持续用 DoPEGetData 采集 60 秒，打印所有字段
        for i in range(300):
            err = do_ctrl.DoPEGetData(hdl, ctypes.byref(data))
            if err == DoPERR_NOERROR:
                print_raw_fields(data)
            else:
                print(f"[DoPEGetData] 失败: 0x{err:04x}")
            time.sleep(0.2)
    except KeyboardInterrupt:
        print("\n中断退出")
    finally:
        stop(do_ctrl, hdl)
        print("\n已断开")
