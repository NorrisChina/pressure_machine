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
CTRL_LOAD = 1

handle = ctypes.c_void_p()

print("\n" + "="*70)
print("DoPE Device Movement Test - Multiple Command Types")
print("="*70 + "\n")

# Connect
print("[1] 连接设备...")
result = DoPEOpenLink(ctypes.c_int(7), ctypes.c_int(9600), ctypes.c_int(10), ctypes.c_int(10), 
                      ctypes.c_int(10), ctypes.c_int(0x0289), ctypes.c_void_p(0), ctypes.byref(handle))
if result != 0:
    print(f"✗ 连接失败: {result:#x}\n")
    sys.exit(1)
print(f"✓ 连接成功 (handle: {handle.value:#x})\n")

# Select Setup
print("[2] 选择Setup 1...")
result = DoPESelSetup(handle, ctypes.c_int(1), ctypes.c_void_p(0), ctypes.c_void_p(0), ctypes.c_void_p(0))
print(f"✓ Setup选择完成 (result: {result:#x})\n")

# Enable data
print("[3] 启用数据传输...")
result = DoPETransmitData(handle, ctypes.c_int(1), ctypes.c_void_p(0))
print(f"✓ 数据传输已启用 (result: {result:#x})\n")

time.sleep(0.5)

# Initial read
print("[4] 读取初始数据:")
data = DoPEData()
DoPEGetData(handle, ctypes.byref(data))
print(f"    位置: {data.Position:.4f}m | 载荷: {data.Load:.2f}N | 状态: {data.StatusWord1:#06x}\n")

# Test 1: DoPEPos with position control
print("="*70)
print("测试1: DoPEPos - 位置控制定位到 0.05m (速度 0.01 m/s)")
print("="*70)
print()

result = DoPEPos(handle, ctypes.c_int(CTRL_POS), ctypes.c_double(0.01), ctypes.c_double(0.05))
print(f"DoPEPos发送结果: {result:#x}\n")

for i in range(15):
    time.sleep(0.2)
    data = DoPEData()
    DoPEGetData(handle, ctypes.byref(data))
    print(f"{i+1:2d}. Pos: {data.Position:8.4f}m | Load: {data.Load:7.2f}N | Status: {data.StatusWord1:#06x}")

print()
time.sleep(0.5)
data = DoPEData()
DoPEGetData(handle, ctypes.byref(data))
print(f"最终位置: {data.Position:.4f}m\n")

# Test 2: DoPEPos with different position
print("="*70)
print("测试2: DoPEPos - 定位到 0.02m (速度 0.01 m/s)")
print("="*70)
print()

result = DoPEPos(handle, ctypes.c_int(CTRL_POS), ctypes.c_double(0.01), ctypes.c_double(0.02))
print(f"DoPEPos发送结果: {result:#x}\n")

for i in range(15):
    time.sleep(0.2)
    data = DoPEData()
    DoPEGetData(handle, ctypes.byref(data))
    print(f"{i+1:2d}. Pos: {data.Position:8.4f}m | Load: {data.Load:7.2f}N | Status: {data.StatusWord1:#06x}")

print()
time.sleep(0.5)
data = DoPEData()
DoPEGetData(handle, ctypes.byref(data))
print(f"最终位置: {data.Position:.4f}m\n")

# Test 3: DoPeFMove - continuous move up
print("="*70)
print("测试3: DoPEFMove - 持续向上移动 (速度 0.01 m/s, 2秒)")
print("="*70)
print()

result = DoPEFMove(handle, ctypes.c_int(MOVE_UP), ctypes.c_double(0.01))
print(f"DoPEFMove发送结果: {result:#x}\n")

for i in range(10):
    time.sleep(0.2)
    data = DoPEData()
    DoPEGetData(handle, ctypes.byref(data))
    print(f"{i+1:2d}. Pos: {data.Position:8.4f}m | Load: {data.Load:7.2f}N | Status: {data.StatusWord1:#06x}")

print()
print("现在测试继续，不关闭连接...")
print()

# Keep connection alive
print("="*70)
print("✓ 测试完成，连接保持打开")
print("="*70)
print()
print("程序将继续运行，保持连接...")
print()

# Keep monitoring
print("持续监控数据 (按 Ctrl+C 停止):")
try:
    counter = 0
    while True:
        time.sleep(1)
        data = DoPEData()
        DoPEGetData(handle, ctypes.byref(data))
        counter += 1
        if counter % 5 == 0:
            print(f"[{counter}s] Pos: {data.Position:.4f}m | Load: {data.Load:.2f}N | Status: {data.StatusWord1:#06x}")
except KeyboardInterrupt:
    print("\n\n关闭连接...")
    DoPECloseLink(handle)
    print("✓ 连接已关闭")
