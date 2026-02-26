#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from drivers.dope_driver import DopeDriver
from drivers.dope_driver_structs import DoPEData
import time

driver = DopeDriver()
print('✓ DLL 加载成功\n' if driver.loaded() else '✗ DLL 加载失败\n')

# 连接 COM7
print('连接 COM7...')
error_code, handle = driver.open_link(port=7, baudrate=9600, apiver=0x0289)
print(f'open_link → error_code=0x{error_code:04X}, handle={handle}\n')

if error_code == 0:
    print('读取数据 (检查所有字段)：\n')
    for i in range(5):
        try:
            res, data = driver.get_data()
            print(f'[{i+1}] res=0x{res:04X}')
            
            if data and isinstance(data, DoPEData):
                print(f'    DoPEData fields:')
                for fname, ftype in data._fields_:
                    val = getattr(data, fname, '???')
                    print(f'      {fname}: {val} ({type(val).__name__})')
            else:
                print(f'    data={data}')
        except Exception as e:
            import traceback
            print(f'Error: {e}')
            traceback.print_exc()
        
        time.sleep(0.2)
