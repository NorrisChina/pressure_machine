import ctypes
import sys
import os
import time

os.add_dll_directory(os.path.join(os.getcwd(), 'drivers'))
dll = ctypes.WinDLL('drivers/DoPE.dll')

# 正确的 DoPEData 结构（基于原始字节分析）
class DoPEData(ctypes.Structure):
    _pack_ = 1  # 紧凑对齐
    _fields_ = [
        ("Position", ctypes.c_double),      # 偏移 0-7
        ("Load", ctypes.c_double),          # 偏移 8-15  <- 这是真实的载荷！
        ("Time", ctypes.c_double),          # 偏移 16-23
        ("Cycles", ctypes.c_uint),          # 偏移 24-27
        ("Extension", ctypes.c_double),     # 偏移 28-35
        ("AnalogIn1", ctypes.c_double),     # 偏移 36-43
        ("AnalogIn2", ctypes.c_double),     # 偏移 44-51
        ("AnalogIn3", ctypes.c_double),     # 偏移 52-59
        ("AnalogOut1", ctypes.c_double),    # 偏移 60-67
        ("AnalogOut2", ctypes.c_double),    # 偏移 68-75
        ("BitInput", ctypes.c_ushort),      # 偏移 76-77
        ("BitOutput", ctypes.c_ushort),     # 偏移 78-79
        ("StatusWord1", ctypes.c_ushort),   # 偏移 80-81
        ("StatusWord2", ctypes.c_ushort),   # 偏移 82-83
    ]

print(f"DoPEData 结构大小: {ctypes.sizeof(DoPEData)} 字节\n")

DoPEOpenLink = dll.DoPEOpenLink
DoPECloseLink = dll.DoPECloseLink
DoPEGetData = dll.DoPEGetData
DoPESelSetup = dll.DoPESelSetup
DoPETransmitData = dll.DoPETransmitData
DoPEFMove = dll.DoPEFMove

MOVE_UP = 1
MOVE_DOWN = 2

handle = ctypes.c_void_p()

print("="*70)
print("DoPE 正确数据格式测试")
print("="*70 + "\n")

# Connect
print("[INIT] 连接设备...")
result = DoPEOpenLink(ctypes.c_int(7), ctypes.c_int(9600), ctypes.c_int(10), ctypes.c_int(10), 
                      ctypes.c_int(10), ctypes.c_int(0x0289), ctypes.c_void_p(0), ctypes.byref(handle))
if result != 0:
    print(f"✗ 连接失败: {result:#x}")
    print("  请重启设备（断电再开机）\n")
    sys.exit(1)
print(f"✓ 连接成功\n")

# Select Setup
DoPESelSetup(handle, ctypes.c_int(1), ctypes.c_void_p(0), ctypes.c_void_p(0), ctypes.c_void_p(0))
print("✓ Setup 1 已选择\n")

# Enable data
DoPETransmitData(handle, ctypes.c_int(1), ctypes.c_void_p(0))
print("✓ 数据传输已启用\n")

time.sleep(0.5)

print("="*70)
print("测试1: 静止状态下读取数据")
print("="*70 + "\n")

for i in range(5):
    data = DoPEData()
    result = DoPEGetData(handle, ctypes.byref(data))
    print(f"{i+1}. Pos: {data.Position:10.6f}m | Load: {data.Load:8.2f}N | Time: {data.Time:8.4f}s")
    time.sleep(0.3)

print()
print("="*70)
print("测试2: 向上移动并监控数据")
print("="*70 + "\n")

result = DoPEFMove(handle, ctypes.c_int(MOVE_UP), ctypes.c_double(0.005))
print(f"DoPEFMove(UP) -> {result:#x}\n")

for i in range(20):
    data = DoPEData()
    DoPEGetData(handle, ctypes.byref(data))
    print(f"{i+1:2d}. Pos: {data.Position:10.6f}m | Load: {data.Load:8.2f}N | Status: {data.StatusWord1:#06x}")
    time.sleep(0.2)

print()
print("="*70)
print("✓ 保持连接...")
print("="*70 + "\n")

print("持续监控 (Ctrl+C 停止):\n")

try:
    counter = 0
    while True:
        time.sleep(1)
        data = DoPEData()
        DoPEGetData(handle, ctypes.byref(data))
        counter += 1
        if counter % 5 == 0:
            print(f"[{counter:3d}s] Pos: {data.Position:10.6f}m | Load: {data.Load:8.2f}N | Time: {data.Time:8.4f}s | Status: {data.StatusWord1:#06x}")
except KeyboardInterrupt:
    print("\n\n[SHUTDOWN] 关闭连接...")
    DoPECloseLink(handle)
    print("[SHUTDOWN] ✓ 连接已关闭\n")
