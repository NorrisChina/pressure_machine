import ctypes
import sys
import os
import time

os.add_dll_directory(os.path.join(os.getcwd(), 'drivers'))
dll = ctypes.WinDLL('drivers/DoPE.dll')

# 先尝试用 DoPEGetData 读原始二进制数据，看看结构
# 不用结构体，直接读字节

DoPEOpenLink = dll.DoPEOpenLink
DoPECloseLink = dll.DoPECloseLink
DoPEGetData = dll.DoPEGetData
DoPESelSetup = dll.DoPESelSetup
DoPETransmitData = dll.DoPETransmitData

handle = ctypes.c_void_p()

print("\n" + "="*70)
print("DoPE 数据结构诊断 - 原始字节分析")
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

# 读取原始字节 - 创建足够大的缓冲区
# 假设数据结构可能比我们想的要大
print("="*70)
print("读取原始数据字节 (前256字节)")
print("="*70 + "\n")

# 方法1: 用通用字节缓冲区
raw_data = ctypes.create_string_buffer(256)

for i in range(5):
    result = DoPEGetData(handle, raw_data)
    
    print(f"读取 {i+1}:")
    print(f"  返回值: {result:#x}")
    
    # 显示前64字节的十六进制
    hex_str = ' '.join(f'{b:02x}' for b in raw_data.raw[:64])
    print(f"  字节(Hex): {hex_str}")
    
    # 尝试解释为double (8字节)
    print(f"  作为double的前4个值:")
    for j in range(4):
        offset = j * 8
        if offset + 8 <= len(raw_data):
            double_val = ctypes.c_double.from_buffer_copy(raw_data.raw[offset:offset+8])
            print(f"    [偏移 {offset:2d}]: {double_val.value:.6f}")
    
    # 尝试解释为32-bit int
    print(f"  作为uint32的前4个值:")
    for j in range(4):
        offset = j * 4
        if offset + 4 <= len(raw_data):
            uint_val = ctypes.c_uint.from_buffer_copy(raw_data.raw[offset:offset+4])
            print(f"    [偏移 {offset:2d}]: {uint_val.value}")
    
    print()
    time.sleep(0.5)

print("="*70)
print("现在启动官方软件，同时监控我们读到的数据")
print("="*70 + "\n")

print("连接保活中... (可与官方软件对比数据)")
print()

try:
    counter = 0
    while True:
        time.sleep(1)
        raw_data = ctypes.create_string_buffer(256)
        result = DoPEGetData(handle, raw_data)
        counter += 1
        
        # 输出可能的位置和载荷值（尝试不同的偏移）
        if counter % 5 == 0:
            print(f"[{counter}s] 原始数据分析:")
            
            # 尝试标准结构 (双精度浮点数序列)
            try:
                pos = ctypes.c_double.from_buffer_copy(raw_data.raw[0:8])
                load = ctypes.c_double.from_buffer_copy(raw_data.raw[8:16])
                time_val = ctypes.c_double.from_buffer_copy(raw_data.raw[16:24])
                print(f"  标准结构[0,8,16]: Pos={pos.value:.4f}, Load={load.value:.2f}, Time={time_val.value:.4f}")
            except:
                print(f"  标准结构读取失败")
            
            # 尝试其他偏移
            try:
                # 可能有额外头部
                pos2 = ctypes.c_double.from_buffer_copy(raw_data.raw[4:12])
                load2 = ctypes.c_double.from_buffer_copy(raw_data.raw[12:20])
                print(f"  偏移+4结构[4,12]: Pos={pos2.value:.4f}, Load={load2.value:.2f}")
            except:
                pass
                
except KeyboardInterrupt:
    print("\n\n[SHUTDOWN] 关闭连接...")
    DoPECloseLink(handle)
    print("[SHUTDOWN] ✓ 连接已关闭\n")
