#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
测试 DoPEFMove 的真正参数
向上 5 秒，向下 5 秒
尝试不同的参数组合
"""
import ctypes
import time
import sys
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
if not DLL_PATH.exists():
    print("[ERROR] DoPE.dll not found at", DLL_PATH)
    sys.exit(1)

dope = ctypes.WinDLL(str(DLL_PATH))

class DoPEData(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Position", ctypes.c_double),
        ("Load", ctypes.c_double),
        ("Time", ctypes.c_double),
        ("Cycles", ctypes.c_uint),
        ("Extension", ctypes.c_double),
        ("TensionInfo", ctypes.c_uint),
        ("Speed", ctypes.c_double),
        ("reserved", ctypes.c_char * 36),
    ]

# 设置函数签名
dope.DoPEOpenLink.argtypes = [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ulong)]
dope.DoPEOpenLink.restype = ctypes.c_ulong

dope.DoPESetNotification.argtypes = [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint]
dope.DoPESetNotification.restype = ctypes.c_ulong

dope.DoPESelSetup.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)]
dope.DoPESelSetup.restype = ctypes.c_ulong

dope.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
dope.DoPEOn.restype = ctypes.c_ulong

dope.DoPECtrlTestValues.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
dope.DoPECtrlTestValues.restype = ctypes.c_ulong

dope.DoPETransmitData.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_ushort)]
dope.DoPETransmitData.restype = ctypes.c_ulong

dope.DoPEGetData.argtypes = [ctypes.c_ulong, ctypes.POINTER(DoPEData)]
dope.DoPEGetData.restype = ctypes.c_ulong

dope.DoPEFMove.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_double, ctypes.c_void_p]
dope.DoPEFMove.restype = ctypes.c_ulong

print("=" * 60)
print("DoPEFMove 参数测试")
print("=" * 60)

# 连接
print("\n连接设备...")
hdl = ctypes.c_ulong(0)
err = dope.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl))
if err != 0:
    print(f"连接失败: 0x{err:04x}")
    sys.exit(1)
print("✓ 连接成功")

dope.DoPESetNotification(hdl, 0xffffffff, None, None, 0)
tan_first = ctypes.c_ushort(0)
tan_last = ctypes.c_ushort(0)
dope.DoPESelSetup(hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
dope.DoPEOn(hdl, None)
dope.DoPECtrlTestValues(hdl, 0)
dope.DoPETransmitData(hdl, 1, None)

print("\n" + "=" * 60)
print("参数组合 1: direction=2, mode=0, speed=5.0 (尝试向上)")
print("=" * 60)
err = dope.DoPEFMove(hdl, 2, ctypes.c_ushort(0), ctypes.c_double(5.0), None)
print(f"FMove 返回: 0x{err:04x}")
print("向上运动 5 秒...")
for i in range(5):
    time.sleep(1)
    data = DoPEData()
    dope.DoPEGetData(hdl, ctypes.byref(data))
    print(f"  [{i+1}s] Pos={data.Position:.4f} | Load={data.Load:.2f} | Speed={data.Speed:.4f}")

print("\n停止...")
err = dope.DoPEFMove(hdl, 0, ctypes.c_ushort(0), ctypes.c_double(0.0), None)
time.sleep(1)

print("\n" + "=" * 60)
print("参数组合 2: direction=1, mode=0, speed=5.0 (尝试向下)")
print("=" * 60)
err = dope.DoPEFMove(hdl, 1, ctypes.c_ushort(0), ctypes.c_double(5.0), None)
print(f"FMove 返回: 0x{err:04x}")
print("向下运动 5 秒...")
for i in range(5):
    time.sleep(1)
    data = DoPEData()
    dope.DoPEGetData(hdl, ctypes.byref(data))
    print(f"  [{i+1}s] Pos={data.Position:.4f} | Load={data.Load:.2f} | Speed={data.Speed:.4f}")

print("\n停止...")
err = dope.DoPEFMove(hdl, 0, ctypes.c_ushort(0), ctypes.c_double(0.0), None)

print("\n" + "=" * 60)
print("测试完成")
print("=" * 60)
