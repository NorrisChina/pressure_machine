#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Try calling DoDpx.dll functions by ordinal
Common ordinal sequence for Delphi DLLs:
1 = OpenLink, 2 = CloseLink, 3 = GetData, etc.
"""
from ctypes import WinDLL, c_uint, c_void_p, c_int, POINTER, byref

dll_path = r"c:\Users\cho77175\Desktop\code\drivers\DoDpx.dll"
dll = WinDLL(dll_path)

print('[Testing DoDpx.dll with ordinal function calls]\n')
print('Ordinal  Function          Signal')
print('-' * 50)

# Typical Delphi/DoPE function order:
ordinal_names = {
    1: 'OpenLink (or Init)',
    2: 'CloseLink',
    3: 'GetData',
    4: 'GetMsg',
    5: 'SetNotification',
    6: 'Initialize',
    7: 'MoveToPosition',
    8: 'MoveToLoad',
    9: 'GoZero',
    10: 'GoRest',
    11: 'EmergencyStop',
    12: 'StartMeasurement',
    13: 'StopMeasurement',
    14: 'GetStatus',
    15: 'GetVersion',
}

# Try ordinal 1 (likely OpenLink) with COM8
print('\n[Attempting COM8 connection via Ordinal 1 (assumed OpenLink)]\n')

try:
    fn = dll[1]  # Ordinal 1
    fn.argtypes = [c_uint, c_uint, c_uint, c_uint, c_uint, c_uint, c_void_p, POINTER(c_void_p)]
    fn.restype = c_int
    
    handle = c_void_p()
    res = fn(8, 9600, 10, 10, 50, 0x0289, 0, byref(handle))
    
    print(f'Ordinal 1 (OpenLink?) with COM8 @ 9600:')
    print(f'  Result: 0x{res:04X}')
    
    if res == 0:
        print(f'  Handle: {handle.value}')
        print('[SUCCESS!!!] Device connected!')
        
        # Try ordinal 3 (likely GetData)
        print('\n[Trying to read data via Ordinal 3 (assumed GetData)]\n')
        try:
            from drivers.dope_driver_structs import DoPEData
            get_fn = dll[3]
            get_fn.argtypes = [c_void_p, POINTER(DoPEData)]
            get_fn.restype = c_int
            
            data = DoPEData()
            res2 = get_fn(handle, byref(data))
            print(f'Ordinal 3 (GetData?):')
            print(f'  Result: 0x{res2:04X}')
            if res2 == 0:
                print(f'  Position: {data.Position}')
                print(f'  Load: {data.Load}')
                print('[SUCCESS!!!] Real data!!')
        except Exception as e:
            print(f'  Error reading data: {e}')
    else:
        print('[FAIL] Connection failed')
        
except Exception as e:
    print(f'[ERROR] {e}')

# Also try other ordinals with simpler signatures
print('\n\n[Testing other ordinals with safe signatures]\n')

for ord_num in range(1, 16):
    try:
        fn = dll[ord_num]
        # Try minimal safe signature: void -> int
        fn.argtypes = []
        fn.restype = c_int
        res = fn()
        print(f'Ordinal {ord_num:2d}: Called successfully, returned 0x{res:04X}')
    except Exception as e:
        # Signature mismatch or other error - expected
        pass
