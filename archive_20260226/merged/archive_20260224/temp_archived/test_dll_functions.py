#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from ctypes import WinDLL
import os

# 加载 DLL
dll_path = r"c:\Users\cho77175\Desktop\code\drivers\DoPE.dll"
try:
    dll = WinDLL(dll_path)
    print("✓ DLL 加载成功\n")
    
    # 列出常见的可能函数名
    possible_functions = [
        # 连接相关
        "DoPEOpenLink", "DoPECloseLink",
        "DoPEInit", "DoPEInitialize", "DoPESetup",
        # 数据读取
        "DoPEGetData", "DoPEGetMeasData", "DoPEGetMeasuringData", "DoPEGetMsg",
        # 控制
        "DoPEMoveTo", "DoPEMove", "DoPEMoveToLoad", "DoPEMoveToPosition",
        "DoPEGoZero", "DoPEGoRest", "DoPEStop",
        # 其他
        "DoPEVersion", "DoPEGetVersion",
        "DoPESetSensor", "DoPESetNotification",
        "DoPEStartMeasurement", "DoPEStopMeasurement",
    ]
    
    print("检查可用函数：\n")
    available = []
    for fname in possible_functions:
        try:
            fn = getattr(dll, fname, None)
            if fn is not None:
                available.append(fname)
                print(f"  ✓ {fname}")
        except:
            pass
    
    if not available:
        print("  (未找到预期的函数)")

except Exception as e:
    print(f"✗ 加载失败: {e}")
