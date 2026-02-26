import ctypes
import sys
import os
import time
import subprocess

os.add_dll_directory(os.path.join(os.getcwd(), 'drivers'))
dll = ctypes.WinDLL('drivers/DoPE.dll')

DoPEOpenLink = dll.DoPEOpenLink
DoPECloseLink = dll.DoPECloseLink
DoPEGetData = dll.DoPEGetData
DoPESelSetup = dll.DoPESelSetup
DoPETransmitData = dll.DoPETransmitData

handle = ctypes.c_void_p()

print("\n" + "="*70)
print("DoPE 数据验证 - 与官方软件对比")
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
DoPESelSetup(handle, ctypes.c_int(1), ctypes.c_void_p(0), ctypes.c_void_p(0), ctypes.c_void_p(0))
print("✓ Setup选择完成\n")

# Enable data
DoPETransmitData(handle, ctypes.c_int(1), ctypes.c_void_p(0))
print("✓ 数据传输已启用\n")

time.sleep(0.5)

print("="*70)
print("正确的数据格式（基于原始字节分析）:")
print("="*70)
print()

# 使用原始字节读取，按正确的格式解释
raw_data = ctypes.create_string_buffer(256)

print("读取数据中... (在另一个窗口打开官方软件 EinzelSensor.exe 对比)")
print()

try:
    counter = 0
    while True:
        time.sleep(1)
        result = DoPEGetData(handle, raw_data)
        counter += 1
        
        # 按字节偏移读取
        position = ctypes.c_double.from_buffer_copy(raw_data.raw[0:8]).value
        load = ctypes.c_double.from_buffer_copy(raw_data.raw[8:16]).value
        time_val = ctypes.c_double.from_buffer_copy(raw_data.raw[16:24]).value
        
        # 后续字段（根据猜测）
        cycles = ctypes.c_uint.from_buffer_copy(raw_data.raw[24:28]).value
        
        if counter % 5 == 0:
            print(f"[{counter:3d}s] Position: {position:10.6f}m | Load: {load:8.2f}N | Time: {time_val:8.4f}s | Cycles: {cycles:10d}")

except KeyboardInterrupt:
    print("\n\n[SHUTDOWN] 关闭连接...")
    DoPECloseLink(handle)
    print("[SHUTDOWN] ✓ 连接已关闭\n")
