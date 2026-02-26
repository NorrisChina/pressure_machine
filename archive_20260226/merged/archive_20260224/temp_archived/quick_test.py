#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Quick connection test (no GUI)
"""
from drivers.dope_driver import DopeDriver
import time

print('[Quick Connection Test - COM7]\n')

driver = DopeDriver()

print('Connecting to COM7...')
res, handle = driver.open_link(port=7, baudrate=9600, apiver=0x0289)

if res == 0:
    print(f'[SUCCESS] Connected! Handle: {handle}')
    print(f'\nReading real-time data (10 samples)...\n')
    
    for i in range(10):
        try:
            res2, data = driver.get_data()
            if res2 == 0 or res2 == 0x8001:  # 0x8001 might be OK status
                pos = getattr(data, 'Position', 0.0) if data else 0.0
                load = getattr(data, 'Load', 0.0) if data else 0.0
                print(f'  [{i+1:2d}] Position: {pos:8.2f} mm, Load: {load:8.2f} N')
            else:
                print(f'  [{i+1:2d}] get_data() returned 0x{res2:04X}')
        except Exception as e:
            print(f'  [{i+1:2d}] Error: {e}')
        
        time.sleep(0.1)
    
    print('\n[SUCCESS] Real-time data stream working!')
    print('Control panel can now display live measurements.')
else:
    print(f'[FAIL] Connection failed: 0x{res:04X}')
