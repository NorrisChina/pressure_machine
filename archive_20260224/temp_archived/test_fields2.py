#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from drivers.dope_driver import DopeDriver
from drivers.dope_driver_structs import DoPEData
import time

driver = DopeDriver()
if driver.loaded():
    print('[OK] DLL loaded')
else:
    print('[ERROR] DLL not loaded')
    exit(1)

# Connect to COM7
print('\nConnecting to COM7...')
error_code, handle = driver.open_link(port=7, baudrate=9600, apiver=0x0289)
print(f'open_link -> error_code=0x{error_code:04X}, handle={handle}')

if error_code == 0:
    print('\nReading data (showing all fields):\n')
    for i in range(3):
        try:
            res, data = driver.get_data()
            print(f'[{i+1}] res=0x{res:04X}')
            
            if data and isinstance(data, DoPEData):
                print(f'    DoPEData fields:')
                for fname, ftype in data._fields_:
                    val = getattr(data, fname, 'N/A')
                    print(f'      {fname:15} = {str(val):30} (type={ftype})')
            else:
                print(f'    data={data}')
        except Exception as e:
            import traceback
            print(f'Error: {e}')
            traceback.print_exc()
        
        print()
        time.sleep(0.2)
