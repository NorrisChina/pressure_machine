#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Final test: Start control panel and attempt COM8 connection with logging
"""
from drivers.dope_driver import DopeDriver
import sys

print('='*70)
print('DOPE CONTROL PANEL - FINAL CONNECTION TEST')
print('='*70)
print()

# Load driver
driver = DopeDriver()
if not driver.loaded():
    print('[ERROR] DLL not loaded')
    sys.exit(1)

print('[OK] DLL loaded successfully\n')

# Try COM8 specifically
print('Attempting COM8 (FTDI) connection...')
print()

# Aggressive testing for COM8
best_config = None
best_error = None

for api in [0x0289, 0x028A, 0x0288]:
    for baud in [9600, 19200, 115200]:
        res, handle = driver.open_link(port=8, baudrate=baud, apiver=api)
        
        if res == 0:
            print(f'[SUCCESS] Connected on COM8 @ {baud} baud (apiver=0x{api:04X})')
            print(f'          Handle: {handle}')
            best_config = (8, baud, api, handle)
            break
        else:
            if best_error is None or (res == 0x800A and best_error != 0x800A):
                best_error = res
                print(f'[FAIL]    COM8 @ {baud:6d} baud (api=0x{api:04X}): 0x{res:04X}')
    
    if best_config:
        break

print()
if best_config:
    port, baud, api, handle = best_config
    print(f'Device ready on COM{port}')
    print('Control panel can now connect and read real-time data')
else:
    print('[INFO] COM8 connection failed')
    print('       Error codes seen:')
    print('       - 0x800B = Device No Response')
    print('       - 0x800A = Checksum Error')
    print('       - 0x0005 = Unknown')
    print()
    print('Troubleshooting:')
    print('1. Check if physical DoPE device is connected to COM8')
    print('2. Verify FTDI drivers are installed')
    print('3. Try manually opening COM8 in Device Manager')
    print('4. Check device power supply')
