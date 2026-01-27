#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
根据文档 Page 111 和示例代码测试 DoPEFMove
文档显示: DoPEFMove(DoPEHdl, Direction, MoveCtrl, Speed, lpusTAN)
示例显示: DoPEFMove(DoPEHdl, MOVE_UP, 0.01) - 只有3个参数！

测试两种调用方式
"""
import ctypes
import time
import sys
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
dope = ctypes.WinDLL(str(DLL_PATH))

MOVE_UP = 1
MOVE_DOWN = 2
MOVE_HALT = 0

print("=" * 70)
print("DoPEFMove 函数调用测试")
print("文档: Page 111, Section 8.5.3")
print("=" * 70)

# 连接
print("\n[连接设备]")
dope.DoPEOpenLink.argtypes = [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ulong)]
dope.DoPEOpenLink.restype = ctypes.c_ulong

hdl = ctypes.c_ulong(0)
err = dope.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl))
if err != 0:
    print(f"  ❌ 连接失败: 0x{err:04x}")
    sys.exit(1)
print(f"  ✓ 连接成功, handle={hdl.value}")

# 初始化
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

dope.DoPESetNotification(hdl, 0xffffffff, None, None, 0)
tan_first = ctypes.c_ushort(0)
tan_last = ctypes.c_ushort(0)
dope.DoPESelSetup(hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
dope.DoPEOn(hdl, None)
dope.DoPECtrlTestValues(hdl, 0)
dope.DoPETransmitData(hdl, 1, None)

print("\n" + "=" * 70)
print("测试 1: 3参数版本 (按照示例代码)")
print("DoPEFMove(hdl, MOVE_UP, 0.01)")
print("=" * 70)

# 尝试 3 参数版本
dope.DoPEFMove.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_double]
dope.DoPEFMove.restype = ctypes.c_ulong

print("\n向上移动 (MOVE_UP=1, speed=0.01)...")
err = dope.DoPEFMove(hdl, MOVE_UP, 0.01)
print(f"  返回: 0x{err:04x}")
time.sleep(3)

print("\n停止 (MOVE_HALT=0, speed=0.0)...")
err = dope.DoPEFMove(hdl, MOVE_HALT, 0.0)
print(f"  返回: 0x{err:04x}")
time.sleep(1)

print("\n向下移动 (MOVE_DOWN=2, speed=0.01)...")
err = dope.DoPEFMove(hdl, MOVE_DOWN, 0.01)
print(f"  返回: 0x{err:04x}")
time.sleep(3)

print("\n停止 (MOVE_HALT=0, speed=0.0)...")
err = dope.DoPEFMove(hdl, MOVE_HALT, 0.0)
print(f"  返回: 0x{err:04x}")

print("\n" + "=" * 70)
print("测试完成")
print("=" * 70)
