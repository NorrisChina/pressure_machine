#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
官方软件运行时，从 COM7 读取数据
"""
from drivers.dope_driver import DopeDriver
import time

print('[Connected to COM7 while official app is running]\n')

driver = DopeDriver()

# 连接 COM7
print('Connecting to COM7...')
res, handle = driver.open_link(port=7, baudrate=9600, apiver=0x0289)
print(f'open_link result: 0x{res:04X}')

if res == 0:
    print(f'Handle: {handle}\n')
    
    print('Reading data 5 times...\n')
    for i in range(5):
        try:
            res2, data = driver.get_data()
            print(f'[{i+1}] get_data() -> 0x{res2:04X}')
            if data:
                print(f'    Position: {getattr(data, "Position", None)}')
                print(f'    Load: {getattr(data, "Load", None)}')
                print(f'    Time: {getattr(data, "Time", None)}')
                print(f'    Cycles: {getattr(data, "Cycles", None)}')
        except Exception as e:
            print(f'[{i+1}] Error: {e}')
        
        time.sleep(0.5)
else:
    print(f'[FAIL] Connection failed: 0x{res:04X}')
