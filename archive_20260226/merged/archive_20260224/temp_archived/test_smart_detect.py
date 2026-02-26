#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Smart port detection: try to match what EinzelSensor.exe sees
"""
from ctypes import WinDLL, c_uint, c_void_p, c_int, POINTER, byref
import os

dll_paths = [
    r"c:\Users\cho77175\Desktop\code\drivers\DoPE.dll",
    r"c:\Users\cho77175\Desktop\code\drivers\DoDpx.dll",
]

ports = [5, 6, 7, 8]
baudrates = [9600, 19200, 115200]
apivers = [0x0289, 0x028A, 0x0288]

print('[Smart DLL and Port Detection]\n')

for dll_path in dll_paths:
    if not os.path.exists(dll_path):
        continue
    
    dll_name = os.path.basename(dll_path)
    print(f'\nTrying {dll_name}:')
    print('-' * 60)
    
    try:
        dll = WinDLL(dll_path)
        
        # Check for function
        has_named_func = False
        try:
            fn = getattr(dll, 'DoPEOpenLink', None) or getattr(dll, 'DoDpxOpenLink', None)
            if fn:
                has_named_func = True
        except:
            pass
        
        # Try named function first
        if has_named_func:
            print(f'  Found named function')
            for port in ports:
                for baud in [9600]:  # Just 9600 for quick scan
                    for api in [0x0289]:
                        try:
                            fn = getattr(dll, 'DoPEOpenLink') if 'DoPE' in dll_name else getattr(dll, 'DoDpxOpenLink', getattr(dll, 'DoPEOpenLink'))
                            fn.argtypes = [c_uint, c_uint, c_uint, c_uint, c_uint, c_uint, c_void_p, POINTER(c_void_p)]
                            fn.restype = c_int
                            
                            handle = c_void_p()
                            res = fn(port, baud, 10, 10, 50, api, 0, byref(handle))
                            
                            status_char = '✓' if res == 0 else '✗'
                            print(f'  {status_char} COM{port}: 0x{res:04X}', end='')
                            if res == 0:
                                print(f' [CONNECTED!]')
                            else:
                                print()
                        except Exception as e:
                            print(f'  ✗ COM{port}: {type(e).__name__}')
        else:
            print(f'  No named function, trying ordinals...')
            # For DoDpx.dll, would need proper ordinal discovery
            
    except Exception as e:
        print(f'  [ERROR] {e}')

print('\n[Note: If both DLLs and all ports fail, device might be off or not connected]')
