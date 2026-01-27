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

MOVE_UP = 1
MOVE_DOWN = 2

handle = ctypes.c_void_p()

print("\n" + "="*70)
print("DoPE 连接保活 - 设备监控")
print("="*70 + "\n")

# Connect
print("[INIT] 连接设备...")
result = DoPEOpenLink(ctypes.c_int(7), ctypes.c_int(9600), ctypes.c_int(10), ctypes.c_int(10), 
                      ctypes.c_int(10), ctypes.c_int(0x0289), ctypes.c_void_p(0), ctypes.byref(handle))
if result != 0:
    print(f"✗ 连接失败: {result:#x}\n")
    sys.exit(1)
print(f"✓ 连接成功\n")

# Select Setup
print("[INIT] 选择Setup 1...")
DoPESelSetup(handle, ctypes.c_int(1), ctypes.c_void_p(0), ctypes.c_void_p(0), ctypes.c_void_p(0))
print("[INIT] ✓ Setup选择完成\n")

# Enable data
print("[INIT] 启用数据传输...")
DoPETransmitData(handle, ctypes.c_int(1), ctypes.c_void_p(0))
print("[INIT] ✓ 数据传输已启用\n")

time.sleep(0.5)

# Test 1: Move UP - continuous
print("="*70)
print("测试1: 持续向上移动 (0.005 m/s)")
print("="*70 + "\n")

result = DoPEFMove(handle, ctypes.c_int(MOVE_UP), ctypes.c_double(0.005))
print(f"[CMD] DoPEFMove(UP) -> {result:#x}\n")

for i in range(20):
    time.sleep(0.2)
    data = DoPEData()
    DoPEGetData(handle, ctypes.byref(data))
    print(f"{i+1:2d}. Pos: {data.Position:10.6f}m | Load: {data.Load:8.2f}N")

print()
time.sleep(1)

# Test 2: Move DOWN - continuous
print("="*70)
print("测试2: 持续向下移动 (0.005 m/s)")
print("="*70 + "\n")

result = DoPEFMove(handle, ctypes.c_int(MOVE_DOWN), ctypes.c_double(0.005))
print(f"[CMD] DoPEFMove(DOWN) -> {result:#x}\n")

for i in range(20):
    time.sleep(0.2)
    data = DoPEData()
    DoPEGetData(handle, ctypes.byref(data))
    print(f"{i+1:2d}. Pos: {data.Position:10.6f}m | Load: {data.Load:8.2f}N")

print()
print("="*70)
print("✓ 测试完成，保持连接...")
print("="*70 + "\n")

# Keep connection alive - continuous monitoring
print("连接保活 - 持续监控 (按 Ctrl+C 停止):\n")
try:
    counter = 0
    while True:
        time.sleep(0.5)
        data = DoPEData()
        DoPEGetData(handle, ctypes.byref(data))
        counter += 1
        if counter % 2 == 0:  # Print every 1 second
            print(f"[KEEP-ALIVE {counter}s] Pos: {data.Position:.6f}m | Load: {data.Load:.2f}N")
except KeyboardInterrupt:
    print("\n\n[SHUTDOWN] 关闭连接...")
    DoPECloseLink(handle)
    print("[SHUTDOWN] ✓ 连接已关闭\n")
