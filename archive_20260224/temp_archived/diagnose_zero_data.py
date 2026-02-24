#!/usr/bin/env python3
"""
关键问题诊断: 设备数据为什么都是0？
可能原因:
1. 设备没有被正确初始化 (需要官方软件或特殊初始化)
2. 设备空闲状态下就是0
3. 需要施加力或移动才能产生数据
"""
import sys
import time
from drivers.dope_driver import DopeDriver
import subprocess

def test_scenario_1():
    """场景1: 直接连接，不初始化"""
    print("\n" + "="*60)
    print("场景 1: 直接连接读取 (不初始化)")
    print("="*60)
    
    driver = DopeDriver()
    error_code, handle = driver.open_link(port=7, baudrate=9600, apiver=0x0289)
    
    print(f"连接: 0x{error_code:04X}")
    
    for i in range(3):
        time.sleep(0.3)
        err, data = driver.get_data()
        print(f"  [{i+1}] Position={data.Position:.2f}, Load={data.Load:.2f}")
    
    driver.close_link()

def test_scenario_2():
    """场景2: 官方软件在运行时读取"""
    print("\n" + "="*60)
    print("场景 2: 官方软件运行 + 读取")
    print("="*60)
    
    # 启动官方软件
    print("启动官方软件...")
    proc = subprocess.Popen(
        "C:\\Users\\cho77175\\Desktop\\DruckZug\\20221216_Druckzug_Kraft\\EinzelSensor.exe",
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    time.sleep(3)
    
    driver = DopeDriver()
    error_code, handle = driver.open_link(port=7, baudrate=9600, apiver=0x0289)
    
    print(f"连接: 0x{error_code:04X}")
    
    for i in range(3):
        time.sleep(0.3)
        err, data = driver.get_data()
        print(f"  [{i+1}] Position={data.Position:.2f}, Load={data.Load:.2f}")
    
    driver.close_link()
    
    # 停止官方软件
    proc.terminate()
    proc.wait()

def test_scenario_3():
    """场景3: 尝试多个端口"""
    print("\n" + "="*60)
    print("场景 3: 尝试其他端口")
    print("="*60)
    
    ports = [8, 5, 6, 3, 4]
    
    for port in ports:
        print(f"\n尝试 COM{port}...")
        driver = DopeDriver()
        
        try:
            error_code, handle = driver.open_link(port=port, baudrate=9600, apiver=0x0289)
            
            if error_code == 0 or error_code == 0x8001:
                print(f"  ✓ 连接成功: 0x{error_code:04X}")
                
                err, data = driver.get_data()
                print(f"  数据: Position={data.Position:.2f}, Load={data.Load:.2f}")
                
                driver.close_link()
            else:
                print(f"  ✗ 连接失败: 0x{error_code:04X}")
        except Exception as e:
            print(f"  ✗ 异常: {e}")

def main():
    print("="*60)
    print("设备数据诊断 - 3 个场景测试")
    print("="*60)
    
    try:
        test_scenario_1()
    except Exception as e:
        print(f"场景 1 错误: {e}")
    
    try:
        test_scenario_2()
    except Exception as e:
        print(f"场景 2 错误: {e}")
    
    try:
        test_scenario_3()
    except Exception as e:
        print(f"场景 3 错误: {e}")
    
    print("\n" + "="*60)
    print("诊断完成")
    print("="*60)

if __name__ == "__main__":
    main()
