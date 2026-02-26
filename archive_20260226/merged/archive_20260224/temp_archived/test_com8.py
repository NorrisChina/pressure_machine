#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from drivers.dope_driver import DopeDriver

driver = DopeDriver()
print('✓ DLL 加载成功' if driver.loaded() else '✗ DLL 加载失败')

# 尝试连接 COM8
found = False
for apiver in [0x0289, 0x028A, 0x0288]:
    for baud in [9600, 19200, 115200]:
        error_code, handle = driver.open_link(port=8, baudrate=baud, apiver=apiver)
        if error_code == 0:
            print(f'✓ COM8 @ {baud} baud (apiver=0x{apiver:04X}) - 连接成功！')
            print(f'  Handle: {handle}')
            
            # 尝试读取数据
            try:
                res, data = driver.get_data()
                print(f'  get_data() 返回: res={res}')
                if data:
                    print(f'    Position: {getattr(data, "Position", "N/A")}')
                    print(f'    Load: {getattr(data, "Load", "N/A")}')
                    print(f'    Time: {getattr(data, "Time", "N/A")}')
                    print(f'    Cycles: {getattr(data, "Cycles", "N/A")}')
            except Exception as e:
                print(f'  读取数据出错: {e}')
            
            found = True
            break
    
    if found:
        break

if not found:
    print('✗ 无法连接到 COM8，尝试过的配置：')
    print('  - 波特率: 9600, 19200, 115200')
    print('  - API版本: 0x0289, 0x028A, 0x0288')
