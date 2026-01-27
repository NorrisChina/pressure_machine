#!/usr/bin/env python3
"""
初始化设备并尝试运动 - 不依赖位置/力控制函数
"""
import sys
import time
from ctypes import c_uint, c_int, c_void_p, byref
from drivers.dope_driver import DopeDriver

def main():
    print("=" * 60)
    print("设备初始化 & 数据监控")
    print("=" * 60)
    
    # Step 1: 初始化驱动
    print("\n[1] 初始化驱动...")
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
    
    # Step 3: 尝试初始化设备
    print("\n[3] 初始化设备...")
    try:
        fn = driver.dll.DoPEInitialize
        fn.argtypes = [c_void_p]
        fn.restype = c_int
        res = fn(handle)
        print(f"✓ DoPEInitialize 已调用 (返回值: 0x{res:04X})")
        time.sleep(1)
    except AttributeError:
        print(f"✗ DoPEInitialize 函数在 DLL 中不存在")
    except Exception as e:
        print(f"✗ 初始化异常: {e}")
    
    # Step 4: 持续读取数据 (20 次，每次 300ms)
    print("\n[4] 监控设备数据 (20 次，每次 300ms)...")
    print("   观察 Position/Load 变化...\n")
    
    max_position = 0
    max_load = 0
    
    for i in range(20):
        time.sleep(0.3)
        try:
            err, data = driver.get_data()
            
            if err == 0 or err == 0x8001:
                # 跟踪最大值
                if data.Position > max_position:
                    max_position = data.Position
                if data.Load > max_load:
                    max_load = data.Load
                
                # 标记显著变化
                marker = ""
                if data.Position > 0 or data.Load > 0:
                    marker = " ← 检测到数据变化！"
                
                print(f"   [{i+1:2d}] Position: {data.Position:8.2f} mm | "
                      f"Load: {data.Load:8.2f} N | "
                      f"Cycles: {data.Cycles:5d}{marker}")
        except Exception as e:
            print(f"   [{i+1:2d}] 读取失败: {e}")
    
    print(f"\n   数据统计:")
    print(f"   - 最大位置: {max_position:.2f} mm")
    print(f"   - 最大力值: {max_load:.2f} N")
    
    # Step 5: 关闭连接
    print("\n[5] 关闭连接...")
    try:
        driver.close_link()
        print("✓ 连接已关闭")
    except:
        pass
    
    print("\n" + "=" * 60)
    print("✓ 监控完成")
    print("=" * 60)
    
    return True

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
