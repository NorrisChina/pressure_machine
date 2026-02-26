#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from drivers.dope_driver import DopeDriver

print('[Testing with updated DopeDriver (DoDpx.dll priority)]\n')

driver = DopeDriver()
print(f'DLL loaded: {driver.loaded()}')
print(f'DLL path: {driver.dll_path}\n')

if driver.loaded():
    print('Attempting COM8 connection...')
    for baud in [9600, 19200, 115200]:
        for api in [0x0289, 0x028A, 0x0288]:
            res, handle = driver.open_link(port=8, baudrate=baud, apiver=api)
            if res == 0:
                print(f'[SUCCESS] COM8 @ {baud} baud (api=0x{api:04X})')
                print(f'  Handle: {handle}')
                
                # Try to read data
                try:
                    res2, data = driver.get_data()
                    print(f'  get_data() -> 0x{res2:04X}')
                    if data:
                        print(f'    Position: {getattr(data, "Position", "N/A")}')
                        print(f'    Load: {getattr(data, "Load", "N/A")}')
                except Exception as e:
                    print(f'  get_data() error: {e}')
                exit(0)
    
    print('[FAIL] Could not connect to COM8')
else:
    print('[ERROR] DLL not loaded')
