#!/usr/bin/env python3
"""
使用 DoPEInitialize 初始化设备进入操作模式
"""
import sys
import time
from ctypes import c_void_p, c_int, byref
from drivers.dope_driver import DopeDriver

def main():
    print("=" * 60)
    print("设备初始化 - 进入操作模式")
    print("=" * 60)
    
    # Step 1: 初始化驱动
    print("\n[1] 加载 DLL...")
    try:
        driver = DopeDriver()
        print("✓ DoPE DLL 加载成功")
    except Exception as e:
        print(f"✗ DLL 加载失败: {e}")
        return False
    
    # Step 2: 连接设备
    print("\n[2] 连接设备 (COM7)...")
    error_code, handle = driver.open_link(
        port=7,
        baudrate=9600,
        apiver=0x0289
    )
    
    if error_code != 0 and error_code != 0x8001:
        print(f"✗ 连接失败: error_code=0x{error_code:04X}")
        return False
    
    print(f"✓ 连接成功 (error_code=0x{error_code:04X})")
    print(f"  Handle: {handle}")
    
    # Step 3: 调用 DoPEInitialize
    print("\n[3] 调用 DoPEInitialize 初始化设备...")
    try:
        fn = driver.dll.DoPEInitialize
        # 尝试不同的参数组合
        
        # 尝试 1: 只传 handle
        print("   尝试 1: DoPEInitialize(handle)...")
        try:
            fn.argtypes = [c_void_p]
            fn.restype = c_int
            res = fn(handle)
            print(f"   结果: 0x{res:04X}")
        except Exception as e:
            print(f"   失败: {e}")
        
        time.sleep(0.5)
        
        # 尝试 2: handle + 参数
        print("   尝试 2: DoPEInitialize(handle, 0)...")
        try:
            fn.argtypes = [c_void_p, c_int]
            fn.restype = c_int
            res = fn(handle, 0)
            print(f"   结果: 0x{res:04X}")
        except Exception as e:
            print(f"   失败: {e}")
        
        time.sleep(0.5)
        
        # 尝试 3: handle + 1
        print("   尝试 3: DoPEInitialize(handle, 1)...")
        try:
            fn.argtypes = [c_void_p, c_int]
            fn.restype = c_int
            res = fn(handle, 1)
            print(f"   结果: 0x{res:04X}")
        except Exception as e:
            print(f"   失败: {e}")
            
    except Exception as e:
        print(f"✗ 初始化失败: {e}")
    
    # Step 4: 读取数据看是否有变化
    print("\n[4] 读取数据 (10 次)...")
    print("   监控数据是否有变化...\n")
    
    max_pos = 0
    max_load = 0
    
    for i in range(10):
        time.sleep(0.5)
        try:
            err, data = driver.get_data()
            
            if err == 0 or err == 0x8001:
                if data.Position > max_pos:
                    max_pos = data.Position
                if data.Load > max_load:
                    max_load = data.Load
                
                marker = ""
                if data.Position > 0.1 or data.Load > 0.1:
                    marker = " ← 检测到数据！"
                
                print(f"   [{i+1:2d}] Pos: {data.Position:7.2f} mm | "
                      f"Load: {data.Load:7.2f} N{marker}")
        except Exception as e:
            print(f"   [{i+1:2d}] 读取失败: {e}")
    
    print(f"\n   数据统计:")
    print(f"   - 最大位置: {max_pos:.2f} mm")
    print(f"   - 最大力值: {max_load:.2f} N")
    
    if max_pos > 0 or max_load > 0:
        print("\n✓ 设备已激活，可以读取数据！")
    else:
        print("\n  设备数据仍为 0，可能需要:")
        print("  1. 通过设备面板手动启动")
        print("  2. 或使用官方软件激活设备")
    
    # Step 5: 关闭连接
    print("\n[5] 关闭连接...")
    try:
        driver.close_link()
        print("✓ 连接已关闭")
    except:
        pass
    
    print("\n" + "=" * 60)
    print("✓ 测试完成")
    print("=" * 60)
    
    return True

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
