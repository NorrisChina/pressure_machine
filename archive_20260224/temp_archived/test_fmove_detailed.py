#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DoPEFMove 参数探测测试
根据 PDF Page 111 的说明进行全面测试

关键信息：
- DoPEFMove 有软限位（Softend）保护
- 如果到达限位，会拒绝向该方向移动
- 需要检查 DoPEGetState 来诊断问题
"""
import ctypes
import time
import sys
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
dope = ctypes.WinDLL(str(DLL_PATH))

# 数据结构
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

dope.DoPEGetState.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_long)]
dope.DoPEGetState.restype = ctypes.c_ulong

# DoPEFMove - 3参数版本
dope.DoPEFMove.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_double]
dope.DoPEFMove.restype = ctypes.c_ulong

print("=" * 80)
print("DoPEFMove 参数探测测试")
print("根据 PDF Page 111 文档")
print("=" * 80)

# 连接
print("\n[初始化] 连接设备...")
hdl = ctypes.c_ulong(0)
err = dope.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl))
if err != 0:
    print(f"❌ 连接失败: 0x{err:04x}")
    sys.exit(1)
print("✓ 连接成功")

dope.DoPESetNotification(hdl, 0xffffffff, None, None, 0)
tan_first = ctypes.c_ushort(0)
tan_last = ctypes.c_ushort(0)
dope.DoPESelSetup(hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
dope.DoPEOn(hdl, None)
dope.DoPECtrlTestValues(hdl, 0)
dope.DoPETransmitData(hdl, 1, None)

# 读取初始状态
def get_status():
    """读取当前状态和数据"""
    state = ctypes.c_long(0)
    data = DoPEData()
    
    err_state = dope.DoPEGetState(hdl, ctypes.byref(state))
    err_data = dope.DoPEGetData(hdl, ctypes.byref(data))
    
    return state.value, data, err_state, err_data

def decode_state(state_value):
    """解码状态字"""
    flags = []
    if state_value & 0x01:
        flags.append("Bit0")
    if state_value & 0x02:
        flags.append("LOWER_LIMIT")
    if state_value & 0x04:
        flags.append("UPPER_LIMIT")
    if state_value & 0x08:
        flags.append("Bit3")
    if state_value & 0x10:
        flags.append("Bit4")
    return f"0x{state_value:08X} [{', '.join(flags) if flags else 'NONE'}]"

print("\n[状态检查] 读取初始状态...")
state, data, err_state, err_data = get_status()
print(f"  GetState: 0x{err_state:04x} -> {decode_state(state)}")
print(f"  GetData: 0x{err_data:04x}")
print(f"  Position: {data.Position:.6f} m")
print(f"  Load: {data.Load:.2f} N")
print(f"  Extension: {data.Extension:.6f} m")

# ============================================================================
# 测试 1: Direction 参数映射（使用 3 参数版本）
# ============================================================================
print("\n" + "=" * 80)
print("测试 1: Direction 参数探测（3参数版本）")
print("=" * 80)

test_cases = [
    (0, 0.01, "HALT/STOP"),
    (1, 0.01, "Direction=1"),
    (2, 0.01, "Direction=2"),
]

for direction, speed, desc in test_cases:
    print(f"\n--- {desc} ---")
    print(f"调用: DoPEFMove(hdl, {direction}, {speed})")
    
    # 读取移动前状态
    state_before, data_before, _, _ = get_status()
    print(f"  移动前: Pos={data_before.Position:.6f} | Load={data_before.Load:.2f} | State={decode_state(state_before)}")
    
    # 执行移动
    err = dope.DoPEFMove(hdl, direction, speed)
    print(f"  返回: 0x{err:04x}")
    
    # 等待并监测
    print("  监测 3 秒...")
    for i in range(3):
        time.sleep(1)
        _, data, _, _ = get_status()
        print(f"    [{i+1}s] Pos={data.Position:.6f} | Load={data.Load:.2f}")
    
    # 停止
    dope.DoPEFMove(hdl, 0, 0.0)
    time.sleep(0.5)
    
    # 读取最终状态
    state_after, data_after, _, _ = get_status()
    delta_pos = data_after.Position - data_before.Position
    delta_load = data_after.Load - data_before.Load
    print(f"  移动后: Pos={data_after.Position:.6f} | Load={data_after.Load:.2f} | State={decode_state(state_after)}")
    print(f"  变化量: ΔPos={delta_pos:.6f} | ΔLoad={delta_load:.2f}")
    
    if abs(delta_pos) < 0.000001 and abs(delta_load) < 0.1:
        print("  ⚠️ 无明显变化 - 可能被限位保护或方向无效")
    elif delta_load > 1.0:
        print("  ✓ 载荷增加 - 可能是拉伸/压缩方向")
    
    time.sleep(1)

# ============================================================================
# 测试 2: 速度参数影响
# ============================================================================
print("\n" + "=" * 80)
print("测试 2: 速度参数影响（使用 Direction=1）")
print("=" * 80)

speeds = [0.001, 0.01, 0.05]

for speed in speeds:
    print(f"\n--- Speed={speed} m/s ---")
    
    data_before, _, _, _ = get_status()[1:2] + (None, None)
    
    err = dope.DoPEFMove(hdl, 1, speed)
    print(f"  调用: DoPEFMove(hdl, 1, {speed}) -> 0x{err:04x}")
    
    time.sleep(2)
    
    _, data_after, _, _ = get_status()
    delta = data_after.Load - data_before.Load
    print(f"  Load变化: {delta:.2f} N")
    
    dope.DoPEFMove(hdl, 0, 0.0)
    time.sleep(0.5)

# ============================================================================
# 测试 3: 尝试突破限位（如果存在）
# ============================================================================
print("\n" + "=" * 80)
print("测试 3: 检查限位保护机制")
print("=" * 80)

print("\n尝试强制移动到可能的限位方向...")
state, data, _, _ = get_status()
print(f"当前位置: {data.Position:.6f} m")
print(f"当前状态: {decode_state(state)}")

if state & 0x02:
    print("⚠️ 检测到下限位标志 - 尝试向上移动")
    err = dope.DoPEFMove(hdl, 2, 0.01)
    print(f"  向上移动返回: 0x{err:04x}")
elif state & 0x04:
    print("⚠️ 检测到上限位标志 - 尝试向下移动")
    err = dope.DoPEFMove(hdl, 1, 0.01)
    print(f"  向下移动返回: 0x{err:04x}")
else:
    print("✓ 未检测到限位标志")

time.sleep(2)
dope.DoPEFMove(hdl, 0, 0.0)

print("\n" + "=" * 80)
print("测试完成")
print("=" * 80)
print("\n总结:")
print("- Direction=0: 停止")
print("- Direction=1: [根据测试结果确定]")
print("- Direction=2: [根据测试结果确定]")
print("- 检查 State 中的限位标志来诊断移动失败原因")
