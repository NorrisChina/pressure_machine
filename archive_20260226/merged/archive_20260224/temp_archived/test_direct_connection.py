#!/usr/bin/env python3
"""
Direct connection test without official software
Test if we can connect and read data from COM7 directly
"""
import sys
import time
import subprocess
from drivers.dope_driver import DopeDriver

def test_direct_connection():
    print("=" * 60)
    print("直接连接测试 (不用官方软件)")
    print("=" * 60)
    
    # Step 1: Kill any existing processes
    print("\n[1] 清理后台进程...")
    try:
        subprocess.run(
            "Stop-Process -Name 'EinzelSensor' -Force -ErrorAction SilentlyContinue; "
            "Get-Process python | Where-Object {$_.CommandLine -like '*control_panel*'} | Stop-Process -Force -ErrorAction SilentlyContinue",
            shell=True,
            capture_output=True
        )
        print("✓ 后台进程已清理")
    except:
        print("✓ 无需清理")
    
    time.sleep(1)
    
    # Step 2: Initialize driver
    print("\n[2] 初始化驱动...")
    try:
        driver = DopeDriver()
        print("✓ DoPE DLL 加载成功")
    except Exception as e:
        print(f"✗ DLL 加载失败: {e}")
        return False
    
    # Step 3: Try connection on all ports with priority order
    print("\n[3] 尝试连接设备...")
    ports_to_try = [7, 8, 5, 6, 3, 4]
    
    for port in ports_to_try:
        com = f"COM{port}"
        print(f"\n   尝试: {com} @ 9600 baud...")
        
        error_code, handle = driver.open_link(
            port=port,
            baudrate=9600,
            apiver=0x0289
        )
        
        if error_code == 0 or error_code == 0x8001:
            print(f"   ✓ 连接成功! (error_code=0x{error_code:04X})")
            print(f"   Handle: {handle}")
            
            # Step 4: Read data multiple times
            print(f"\n[4] 从 {com} 读取数据...")
            print("   等待设备响应...\n")
            
            for i in range(5):
                time.sleep(0.5)
                try:
                    err, data = driver.get_data()
                    
                    if err == 0 or err == 0x8001:
                        print(f"   [{i+1}] ✓ 数据读取成功 (error_code=0x{err:04X})")
                        print(f"       Position: {data.Position:.2f} mm")
                        print(f"       Load:     {data.Load:.2f} N")
                        print(f"       Time:     {data.Time:.2f} s")
                        print(f"       Cycles:   {data.Cycles}")
                    else:
                        print(f"   [{i+1}] ✗ 数据读取失败: error_code=0x{err:04X}")
                except Exception as e:
                    print(f"   [{i+1}] ✗ 异常: {e}")
            
            # Step 5: Close connection
            print(f"\n[5] 关闭连接...")
            try:
                driver.close_link()
                print("✓ 连接已关闭")
            except:
                pass
            
            return True
    
    print("\n✗ 所有端口连接失败")
    return False

if __name__ == "__main__":
    success = test_direct_connection()
    sys.exit(0 if success else 1)
