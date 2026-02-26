#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
最简单的向上移动测试
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

DoPERR_NOERROR = 0x0000
MOVE_UP = 1
CTRL_MODE_POS = 0

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
print("最简单的向上移动测试")
print("=" * 60)

# 1. 打开连接
print("\n[1] 正在打开连接 (COM7, 9600, apiver=0x0289)...")
hdl = ctypes.c_ulong(0)
err = dope.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl))
if err != DoPERR_NOERROR:
    print(f"❌ OpenLink 失败 0x{err:04x}")
    sys.exit(1)
print(f"✓ 连接成功，handle={hdl.value}")

# 2. SetNotification
print("\n[2] 设置通知...")
err = dope.DoPESetNotification(hdl, 0xffffffff, None, None, 0)
print(f"   SetNotification 返回 0x{err:04x}")

# 3. SelSetup
print("\n[3] 选择通道...")
tan_first = ctypes.c_ushort(0)
tan_last = ctypes.c_ushort(0)
err = dope.DoPESelSetup(hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
if err != DoPERR_NOERROR:
    print(f"❌ SelSetup 失败 0x{err:04x}")
    sys.exit(1)
print(f"✓ SelSetup 成功")

# 4. DoPEOn
print("\n[4] 启动控制器...")
err = dope.DoPEOn(hdl, None)
print(f"   DoPEOn 返回 0x{err:04x}")

# 5. DoPECtrlTestValues
print("\n[5] 设置测试值...")
err = dope.DoPECtrlTestValues(hdl, 0)
print(f"   CtrlTestValues 返回 0x{err:04x}")

# 6. DoPETransmitData
print("\n[6] 启用数据传输...")
err = dope.DoPETransmitData(hdl, 1, None)
print(f"   TransmitData 返回 0x{err:04x}")

# 7. 读取当前数据
print("\n[7] 读取初始数据...")
data = DoPEData()
err = dope.DoPEGetData(hdl, ctypes.byref(data))
if err == DoPERR_NOERROR:
    print(f"✓ 初始位置: {data.Position:.4f} mm")
else:
    print(f"   GetData 返回 0x{err:04x}")

# 8. 向上移动！
print("\n[8] 🚀 执行向上移动 (速度=10.0 mm/s, 控制模式=2)...")
speed = 10.0
ctrl_mode = 2
print(f"   调用: DoPEFMove(hdl, {MOVE_UP}, {ctrl_mode}, {speed}, None)")
err = dope.DoPEFMove(hdl, MOVE_UP, ctypes.c_ushort(ctrl_mode), ctypes.c_double(speed), None)
print(f"   DoPEFMove 返回 0x{err:04x}")

if err == DoPERR_NOERROR:
    print("✓ 命令发送成功！")
else:
    print(f"❌ 命令失败")

# 监控 5 秒
print("\n[9] 监控 5 秒...")
for i in range(5):
    data = DoPEData()
    err = dope.DoPEGetData(hdl, ctypes.byref(data))
    if err == DoPERR_NOERROR:
        print(f"   [{i+1}s] Pos={data.Position:.4f} mm | Load={data.Load:.2f} N | Speed={data.Speed:.4f}")
    time.sleep(1.0)

# 停止
print("\n[10] 停止运动...")
err = dope.DoPEFMove(hdl, 0, ctypes.c_ushort(CTRL_MODE_POS), ctypes.c_double(0.0), None)
print(f"   FMove(stop) 返回 0x{err:04x}")

print("\n" + "=" * 60)
print("测试完成")
print("=" * 60)
