import ctypes
import sys
import os
import time

os.add_dll_directory(os.path.join(os.getcwd(), 'drivers'))
dll = ctypes.WinDLL('drivers/DoPE.dll')

class DoPEData(ctypes.Structure):
    _fields_ = [
        ("Position", ctypes.c_double),
        ("Load", ctypes.c_double),
        ("Time", ctypes.c_double),
        ("Cycles", ctypes.c_ulong),
        ("Extension", ctypes.c_double),
        ("AnalogIn1", ctypes.c_double),
        ("AnalogIn2", ctypes.c_double),
        ("AnalogIn3", ctypes.c_double),
        ("AnalogOut1", ctypes.c_double),
        ("AnalogOut2", ctypes.c_double),
        ("BitInput", ctypes.c_ushort),
        ("BitOutput", ctypes.c_ushort),
        ("StatusWord1", ctypes.c_ushort),
        ("StatusWord2", ctypes.c_ushort),
    ]

DoPEOpenLink = dll.DoPEOpenLink
DoPECloseLink = dll.DoPECloseLink
DoPEGetData = dll.DoPEGetData
DoPESelSetup = dll.DoPESelSetup
DoPETransmitData = dll.DoPETransmitData
DoPEFMove = dll.DoPEFMove
DoPEPos = dll.DoPEPos
DoPEHalt = dll.DoPEHalt

MOVE_UP = 1
MOVE_DOWN = 2
CTRL_POS = 0

handle = ctypes.c_void_p()

# Connect
print("连接设备...")
result = DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, 0, ctypes.byref(handle))
if result != 0:
    print(f"连接失败: {result:#x}")
    sys.exit(1)
print("✓ 连接成功")

# Select Setup
print("选择Setup 1...")
DoPESelSetup(handle, 1, 0, 0, 0)
print("✓ Setup选择完成")

# Enable data
print("启用数据传输...")
DoPETransmitData(handle, 1, 0)
print("✓ 数据传输已启用\n")

# Test move up
print("测试1: 向上移动 (速度 0.005 m/s)")
print("-" * 50)
DoPEFMove(handle, ctypes.c_int(MOVE_UP), ctypes.c_double(0.005))

for i in range(10):
    time.sleep(0.3)
    data = DoPEData()
    DoPEGetData(handle, ctypes.byref(data))
    print(f"{i+1}. 位置: {data.Position:8.4f}m | 载荷: {data.Load:7.2f}N | 时间: {data.Time:5.2f}s")

print("停止...")
DoPEHalt(handle, 0)
time.sleep(0.5)

data = DoPEData()
DoPEGetData(handle, ctypes.byref(data))
print(f"最终位置: {data.Position:.4f}m\n")

# Test move down
print("测试2: 向下移动 (速度 0.005 m/s)")
print("-" * 50)
DoPEFMove(handle, MOVE_DOWN, 0.005)

for i in range(10):
    time.sleep(0.3)
    data = DoPEData()
    DoPEGetData(handle, ctypes.byref(data))
    print(f"{i+1}. 位置: {data.Position:8.4f}m | 载荷: {data.Load:7.2f}N | 时间: {data.Time:5.2f}s")

print("停止...")
DoPEHalt(handle, 0)
time.sleep(0.5)

data = DoPEData()
DoPEGetData(handle, ctypes.byref(data))
print(f"最终位置: {data.Position:.4f}m\n")

# Close
DoPECloseLink(handle)
print("✓ 已关闭连接")
