#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from drivers.dope_driver import DopeDriver
import time

error_codes = {
    0x0000: "SUCCESS",
    0x0005: "UNKNOWN_0005",
    0x8001: "DLL_NOT_INITIALIZED",
    0x8002: "INVALID_HANDLE",
    0x8003: "INVALID_PARAM",
    0x8004: "MEM_ALLOC_FAILED",
    0x8005: "COMM_TIMEOUT",
    0x8006: "PORT_OPEN_FAILED",
    0x8007: "PORT_IN_USE",
    0x8008: "DATA_RECV_ERROR",
    0x8009: "DATA_SEND_ERROR",
    0x800A: "CHECKSUM_ERROR",
    0x800B: "NO_RESPONSE",
}

driver = DopeDriver()
print('[OK] DLL loaded\n' if driver.loaded() else '[FAIL] DLL load failed\n')

print('Testing COM8 with different parameters:\n')
print('Format: port, baudrate, rcvbuf, xmitbuf, databuf, apiver')
print('-' * 70)

# Try different buffer sizes and parameters
test_configs = [
    # (port, baudrate, rcvbuf, xmitbuf, databuf, apiver, desc)
    (8, 9600,   10,    10,    50, 0x0289, "default"),
    (8, 9600,   256,   256,   256, 0x0289, "large buffers"),
    (8, 9600,   64,    64,    256, 0x0289, "medium buffers"),
    (8, 9600,   32,    32,    128, 0x0289, "small buffers"),
    (8, 19200,  256,   256,   256, 0x0289, "19200 large"),
    (8, 115200, 256,   256,   256, 0x0289, "115200 large"),
    (8, 9600,   10,    10,    50, 0x028A, "apiver 0x028A"),
    (8, 9600,   10,    10,    50, 0x0288, "apiver 0x0288"),
    (8, 9600,   0,     0,     0,  0x0289, "zero buffers"),
]

best_result = None
for port, baud, rcvbuf, xmitbuf, databuf, apiver, desc in test_configs:
    error_code, handle = driver.open_link(
        port=port, 
        baudrate=baud, 
        rcvbuf=rcvbuf,
        xmitbuf=xmitbuf,
        databuf=databuf,
        apiver=apiver
    )
    
    error_name = error_codes.get(error_code, f'0x{error_code:04X}')
    status = '[OK]' if error_code == 0 else '[FAIL]'
    
    print(f'{status} {desc:20s} -> 0x{error_code:04X} ({error_name})')
    
    if error_code == 0 and best_result is None:
        best_result = (port, baud, rcvbuf, xmitbuf, databuf, apiver)
        print(f'     ^-- Found working config! Handle: {handle}')
        
        # Try reading data
        try:
            res, data = driver.get_data()
            print(f'     get_data() -> res=0x{res:04X}')
            if data:
                pos = getattr(data, 'Position', None)
                load = getattr(data, 'Load', None)
                print(f'     Position: {pos}, Load: {load}')
        except Exception as e:
            print(f'     get_data() error: {e}')

print()
if best_result:
    port, baud, rcvbuf, xmitbuf, databuf, apiver = best_result
    print(f'\n[SUCCESS] Device working on COM{port} @ {baud} baud')
    print(f'Update start_control_panel.py to use these settings')
else:
    print('\n[INFO] No working config found yet')
    print('The device might need special initialization or different parameters')
