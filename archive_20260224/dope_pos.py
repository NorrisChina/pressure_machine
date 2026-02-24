#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DoPEPos 函数测试 - 定点移动

功能: 移动到指定目标位置（自动停止）
参考: Seriell-DLL-DOPE.pdf Page 98, Section 8.2.1
"""
import ctypes
import time
import sys
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
dope = ctypes.WinDLL(str(DLL_PATH))

# 常量定义
CTRL_POS = 0
CTRL_LOAD = 1
CTRL_EXTENSION = 2

DoPERR_NOERROR = 0x0000

print("=" * 80)
print("DoPEPos 函数测试 - 定点移动")
print("=" * 80)

# ============================================================================
# 初始化连接
# ============================================================================
print("\n[初始化] 连接设备...")
print("-" * 80)

dope.DoPEOpenLink.argtypes = [
    ctypes.c_ulong, ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort,
    ctypes.c_ushort, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ulong)
]
dope.DoPEOpenLink.restype = ctypes.c_ulong

hdl = ctypes.c_ulong(0)
err = dope.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl))
if err != DoPERR_NOERROR:
    print(f"❌ 连接失败: 0x{err:04x}")
    sys.exit(1)
print(f"✓ 连接成功 (Handle: {hdl.value})")

# SetNotification
dope.DoPESetNotification.argtypes = [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint]
dope.DoPESetNotification.restype = ctypes.c_ulong
dope.DoPESetNotification(hdl, 0xffffffff, None, None, 0)

# SelSetup
dope.DoPESelSetup.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)]
dope.DoPESelSetup.restype = ctypes.c_ulong
tan_first = ctypes.c_ushort(0)
tan_last = ctypes.c_ushort(0)
err = dope.DoPESelSetup(hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
if err != DoPERR_NOERROR:
    print(f"❌ SelSetup 失败: 0x{err:04x}")
    sys.exit(1)
print("✓ SelSetup 成功")

# 启动控制器
dope.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
dope.DoPEOn.restype = ctypes.c_ulong
dope.DoPEOn(hdl, None)

dope.DoPECtrlTestValues.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
dope.DoPECtrlTestValues.restype = ctypes.c_ulong
dope.DoPECtrlTestValues(hdl, 0)

dope.DoPETransmitData.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_ushort)]
dope.DoPETransmitData.restype = ctypes.c_ulong
dope.DoPETransmitData(hdl, 1, None)

print("✓ 控制器已启动")

# ============================================================================
# DoPEPos 函数签名
# ============================================================================
dope.DoPEPos.argtypes = [
    ctypes.c_ulong,      # DoPEHdl
    ctypes.c_ushort,     # MoveCtrl
    ctypes.c_double,     # Speed
    ctypes.c_double,     # Destination
    ctypes.c_void_p      # lpusTAN
]
dope.DoPEPos.restype = ctypes.c_ulong

# ============================================================================
# 自动测试序列
# ============================================================================
print("\n" + "=" * 80)
print("自动测试序列")
print("=" * 80)

test_positions = [
    (0.002, 0.01, "移动到 2mm"),
    (0.005, 0.02, "移动到 5mm"),
    (0.003, 0.01, "回到 3mm"),
    (0.000, 0.01, "回到原点 0mm"),
]

for destination, speed, desc in test_positions:
    print(f"\n{desc}")
    print(f"  目标位置: {destination*1000:.1f} mm")
    print(f"  速度: {speed*1000:.1f} mm/s")
    
    err = dope.DoPEPos(hdl, CTRL_POS, speed, destination, None)
    print(f"  DoPEPos 返回: 0x{err:04x}")
    
    if err == DoPERR_NOERROR:
        print("  ✓ 命令发送成功，等待到达目标...")
        # 等待足够时间到达目标
        # 估算时间：距离/速度 + 缓冲
        wait_time = abs(destination / speed) + 2
        time.sleep(min(wait_time, 10))  # 最多等10秒
        print("  ✓ 到达目标位置")
    else:
        print(f"  ❌ 命令失败")
    
    time.sleep(1)

# ============================================================================
# 交互式控制
# ============================================================================
print("\n" + "=" * 80)
print("交互式定位控制")
print("=" * 80)
print("\n命令格式:")
print("  <位置mm> <速度mm/s> - 例如: 5 20 (移动到5mm位置，速度20mm/s)")
print("  0 - 回到原点")
print("  q - 退出")
print()

try:
    while True:
        cmd = input(">>> ").strip().lower()
        
        if cmd == 'q':
            print("正在退出...")
            break
        
        if cmd == '0':
            # 快捷回原点
            print("回到原点...")
            err = dope.DoPEPos(hdl, CTRL_POS, 0.02, 0.0, None)
            print(f"返回: 0x{err:04x}")
            if err == DoPERR_NOERROR:
                time.sleep(3)
            continue
        
        # 解析位置和速度
        try:
            parts = cmd.split()
            if len(parts) == 1:
                # 只有位置，使用默认速度
                pos_mm = float(parts[0])
                speed_mm = 20.0  # 默认 20mm/s
            elif len(parts) == 2:
                pos_mm = float(parts[0])
                speed_mm = float(parts[1])
            else:
                print("❌ 格式错误。示例: 5 20 或 5")
                continue
            
            # 转换为米
            destination = pos_mm / 1000.0
            speed = speed_mm / 1000.0
            
            # 检查范围
            if abs(destination) > 0.1:  # 限制在 ±100mm
                print("❌ 位置超出范围（±100mm）")
                continue
            
            if speed <= 0 or speed > 0.1:  # 限制速度 0-100mm/s
                print("❌ 速度超出范围（0-100mm/s）")
                continue
            
            print(f"定位到 {pos_mm:.1f}mm，速度 {speed_mm:.1f}mm/s")
            err = dope.DoPEPos(hdl, CTRL_POS, speed, destination, None)
            print(f"返回: 0x{err:04x}")
            
            if err == DoPERR_NOERROR:
                # 估算到达时间
                est_time = abs(destination / speed) + 1
                print(f"预计 {est_time:.1f}s 到达")
            
        except ValueError:
            print("❌ 输入格式错误。请输入数字，例如: 5 20")
        except Exception as e:
            print(f"❌ 错误: {e}")

except KeyboardInterrupt:
    print("\n\n中断信号 - 退出...")

print("\n" + "=" * 80)
print("连接已关闭")
print("=" * 80)
