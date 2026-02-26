#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
按照文档 1.4.1 "C" Program 逻辑重构的 DoPE 测试代码

步骤:
1. DoPEOpenLink - 打开连接
2. DoPESetNotification - 设置通知
3. DoPESelSetup - 选择设置
4. 移动测试 (DoPEFMove 和 DoPEPos)

参考: Seriell-DLL-DOPE.pdf Page 8-9, 98, 111
"""
import ctypes
import time
import sys
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
dope = ctypes.WinDLL(str(DLL_PATH))

# 常量定义（从文档）
MOVE_HALT = 0
MOVE_UP = 1
MOVE_DOWN = 2

CTRL_POS = 0
CTRL_LOAD = 1
CTRL_EXTENSION = 2

DoPERR_NOERROR = 0x0000

print("=" * 80)
print("DoPE 函数测试 - 按照文档逻辑")
print("=" * 80)

# ============================================================================
# 步骤 1: DoPEOpenLink - 打开连接 (Page 8)
# ============================================================================
print("\n[步骤 1] DoPEOpenLink - 打开连接")
print("-" * 80)

dope.DoPEOpenLink.argtypes = [
    ctypes.c_ulong,                  # Port
    ctypes.c_ulong,                  # Baudrate
    ctypes.c_ushort,                 # RxBuf
    ctypes.c_ushort,                 # TxBuf
    ctypes.c_ushort,                 # DataBuf
    ctypes.c_ushort,                 # APIVersion
    ctypes.c_void_p,                 # UserScale
    ctypes.POINTER(ctypes.c_ulong)   # DoPEHdl
]
dope.DoPEOpenLink.restype = ctypes.c_ulong

hdl = ctypes.c_ulong(0)
err = dope.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl))
if err != DoPERR_NOERROR:
    print(f"  ❌ DoPEOpenLink 失败: 0x{err:04x}")
    sys.exit(1)
print(f"  ✓ DoPEOpenLink 成功")
print(f"    - Handle: {hdl.value}")
print(f"    - Port: COM7")
print(f"    - Baudrate: 9600")

# ============================================================================
# 步骤 2: DoPESetNotification - 设置通知 (Page 8)
# ============================================================================
print("\n[步骤 2] DoPESetNotification - 设置通知")
print("-" * 80)

dope.DoPESetNotification.argtypes = [
    ctypes.c_ulong,      # DoPEHdl
    ctypes.c_ulong,      # EventMask
    ctypes.c_void_p,     # Callback
    ctypes.c_void_p,     # hWnd
    ctypes.c_uint        # WM_Event
]
dope.DoPESetNotification.restype = ctypes.c_ulong

err = dope.DoPESetNotification(hdl, 0xffffffff, None, None, 0)
if err != DoPERR_NOERROR:
    print(f"  ⚠️ DoPESetNotification 返回: 0x{err:04x}")
else:
    print(f"  ✓ DoPESetNotification 成功")

# ============================================================================
# 步骤 3: DoPESelSetup - 选择设置 (Page 8)
# ============================================================================
print("\n[步骤 3] DoPESelSetup - 选择设置")
print("-" * 80)

dope.DoPESelSetup.argtypes = [
    ctypes.c_ulong,                  # DoPEHdl
    ctypes.c_ushort,                 # SetupNo
    ctypes.c_void_p,                 # UserScale
    ctypes.POINTER(ctypes.c_ushort), # TANFirst
    ctypes.POINTER(ctypes.c_ushort)  # TANLast
]
dope.DoPESelSetup.restype = ctypes.c_ulong

tan_first = ctypes.c_ushort(0)
tan_last = ctypes.c_ushort(0)
err = dope.DoPESelSetup(hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
if err != DoPERR_NOERROR:
    print(f"  ❌ DoPESelSetup 失败: 0x{err:04x}")
    sys.exit(1)
print(f"  ✓ DoPESelSetup 成功")
print(f"    - Setup No: 1")

# ============================================================================
# 初始化序列（根据之前经验添加）
# ============================================================================
print("\n[初始化] 启动控制器和数据传输")
print("-" * 80)

dope.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
dope.DoPEOn.restype = ctypes.c_ulong
err = dope.DoPEOn(hdl, None)
print(f"  DoPEOn 返回: 0x{err:04x}")

dope.DoPECtrlTestValues.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
dope.DoPECtrlTestValues.restype = ctypes.c_ulong
err = dope.DoPECtrlTestValues(hdl, 0)
print(f"  DoPECtrlTestValues 返回: 0x{err:04x}")

dope.DoPETransmitData.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_ushort)]
dope.DoPETransmitData.restype = ctypes.c_ulong
err = dope.DoPETransmitData(hdl, 1, None)
print(f"  DoPETransmitData 返回: 0x{err:04x}")

# ============================================================================
# 步骤 4A: DoPEFMove 测试 - 使用完整 5 参数版本
# ============================================================================
print("\n" + "=" * 80)
print("[测试 A] DoPEFMove - 5 参数版本（完整定义）")
print("=" * 80)

dope.DoPEFMove.argtypes = [
    ctypes.c_ulong,      # DoPEHdl
    ctypes.c_ushort,     # Direction
    ctypes.c_ushort,     # MoveCtrl
    ctypes.c_double,     # Speed
    ctypes.c_void_p      # lpusTAN
]
dope.DoPEFMove.restype = ctypes.c_ulong

print("\n1. 向上移动 (Direction=1, MoveCtrl=CTRL_POS, speed=0.01 m/s)")
err = dope.DoPEFMove(hdl, MOVE_UP, CTRL_POS, 0.01, None)
print(f"   返回: 0x{err:04x}")
time.sleep(3)

# print("\n2. 停止 (Direction=0, MoveCtrl=CTRL_POS)")
# err = dope.DoPEFMove(hdl, MOVE_HALT, CTRL_POS, 0.0, None)
# print(f"   返回: 0x{err:04x}")
# time.sleep(1)

print("\n3. 向下移动 (Direction=2, MoveCtrl=CTRL_POS, speed=0.01 m/s)")
err = dope.DoPEFMove(hdl, MOVE_DOWN, CTRL_POS, 0.01, None)
print(f"   返回: 0x{err:04x}")
time.sleep(3)

# 停止
err = dope.DoPEFMove(hdl, MOVE_HALT, CTRL_POS, 0.0, None)

# ============================================================================
# 保持连接 - 交互式命令行
# ============================================================================
print("\n" + "=" * 80)
print("连接保持中 - 交互式控制")
print("=" * 80)
print("\n命令:")
print("  u - 向上移动 (Direction=1)")
print("  d - 向下移动 (Direction=2)")
print("  s - 停止")
print("  q - 退出并断开连接")
print()

try:
    while True:
        cmd = input(">>> ").strip().lower()
        
        if cmd == 'u':
            print("向上移动...")
            err = dope.DoPEFMove(hdl, MOVE_UP, CTRL_POS, 0.01, None)
            print(f"返回: 0x{err:04x}")
        
        elif cmd == 'd':
            print("向下移动...")
            err = dope.DoPEFMove(hdl, MOVE_DOWN, CTRL_POS, 0.01, None)
            print(f"返回: 0x{err:04x}")
        
        elif cmd == 's':
            print("停止...")
            err = dope.DoPEFMove(hdl, MOVE_HALT, CTRL_POS, 0.0, None)
            print(f"返回: 0x{err:04x}")
        
        elif cmd == 'q':
            print("正在退出...")
            dope.DoPEFMove(hdl, MOVE_HALT, CTRL_POS, 0.0, None)
            break
        
        else:
            print("无效命令，请输入 u/d/s/q")

except KeyboardInterrupt:
    print("\n\n中断信号 - 停止运动并退出...")
    dope.DoPEFMove(hdl, MOVE_HALT, CTRL_POS, 0.0, None)

print("\n" + "=" * 80)
print("连接已关闭")
print("=" * 80)
