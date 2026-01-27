#!/usr/bin/env python3
"""
列出 DoPE.dll 中的所有导出函数
"""
import ctypes
from ctypes import WinDLL
import os

def list_dll_exports():
    current_dir = os.path.dirname(os.path.abspath(__file__))
    dll_path = os.path.join(current_dir, "drivers", "DoPE.dll")
    
    print(f"DLL 路径: {dll_path}")
    print(f"DLL 存在: {os.path.exists(dll_path)}")
    
    if not os.path.exists(dll_path):
        print("✗ DLL 不存在")
        return
    
    try:
        dll = WinDLL(dll_path)
        print("✓ DLL 加载成功\n")
        
        # 尝试访问常见函数
        common_functions = [
            "DoPEOpenLink",
            "DoPECloseLink", 
            "DoPEGetData",
            "DoPEGetMeasData",
            "DoPEMoveToPosition",
            "DoPEMoveToForce",
            "DoPEStartMeasuring",
            "DoPEStopMeasuring",
            "DoPESetPosition",
            "DoPESetForce",
            "DoPEEmergencyStop",
            "DoPEInitialize",
            "DoPEReset",
        ]
        
        print("尝试访问以下函数:\n")
        found_count = 0
        
        for func_name in common_functions:
            try:
                fn = getattr(dll, func_name)
                print(f"✓ {func_name}")
                found_count += 1
            except AttributeError:
                print(f"✗ {func_name}")
        
        print(f"\n找到 {found_count}/{len(common_functions)} 个函数")
        
    except Exception as e:
        print(f"✗ 加载 DLL 失败: {e}")

if __name__ == "__main__":
    list_dll_exports()
