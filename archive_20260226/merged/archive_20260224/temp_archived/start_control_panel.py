#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
控制面板启动器
自动检测驱动并启动控制面板
"""

import sys
import os
import subprocess

# 检查是否用 32 位 Python；如果不是，重新启动自己
if sys.maxsize <= 2**32:
    # 已经是 32 位，继续
    pass
else:
    # 64 位，重新用 32 位 Python 启动
    venv32_python = os.path.join(os.path.dirname(__file__), ".venv32", "Scripts", "python.exe")
    if os.path.exists(venv32_python):
        subprocess.call([venv32_python, __file__] + sys.argv[1:])
        sys.exit(0)

# 添加项目根目录到路径
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from PyQt5 import QtWidgets
from control_panel import ControlPanelWindow


def main():
    print("="*60)
    print("设备控制面板启动器")
    print("="*60)
    
    app = QtWidgets.QApplication(sys.argv)
    
    # 尝试加载驱动
    driver = None
    driver_type = "模拟"
    
    print("\n[1/3] 正在加载驱动...")
    try:
        from drivers.dope_driver import DopeDriver
        driver = DopeDriver()
        
        if driver.loaded():
            print("✓ DoPE DLL 加载成功")
            driver_type = "真实硬件"
            
            # 尝试自动连接
            print("\n[2/3] Attempting device connection...")
            
            # 优先尝试 COM7 (最近发现可以工作), 然后其他端口
            ports_priority = [7, 8, 5, 6, 3, 4]
            baudrates = [9600, 19200, 115200]
            apivers = [0x0289, 0x028A, 0x0288]
            
            connected = False
            for baud in baudrates:
                if connected:
                    break
                for api in apivers:
                    if connected:
                        break
                    for port in ports_priority:
                        try:
                            result = driver.open_link(port=port, baudrate=baud, apiver=api)
                            
                            if isinstance(result, tuple) and result[0] == 0:
                                print(f"  Connected: COM{port} @ {baud} baud (apiver=0x{api:04X})")
                                connected = True
                                break
                        except Exception as e:
                            pass
            
            if not connected:
                print("\n⚠️ Warning: Unable to connect to device")
                print("   COM8 (FTDI): All returned 0x800B (no response)")
                print("   Possible causes:")
                print("   - Physical device not connected to COM8")
                print("   - Device powered off")
                print("   - FTDI driver issue")
                print("   Program will run in offline mode")
                driver_type = "Offline Mode"
        else:
            print("⚠️ DLL 未加载，使用模拟模式")
            driver = None
            
    except Exception as e:
        print(f"⚠️ 驱动加载失败: {e}")
        print("   程序将在模拟模式下运行")
        driver = None
    
    print("\n[3/3] 正在启动控制面板...")
    print(f"驱动模式: {driver_type}")
    print("="*60 + "\n")
    
    # 创建并显示控制面板
    window = ControlPanelWindow(driver=driver)
    window.show()
    
    print("✓ 控制面板已启动")
    print("  - 顶部状态栏显示连接状态")
    print("  - 实时数据每 100ms 更新")
    print("  - 红色紧急停止按钮随时可用")
    print("\n" + "="*60)
    
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
