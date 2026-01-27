#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from ctypes import WinDLL, c_uint, c_void_p, c_int, POINTER, byref
import os

dll_paths = [
    r"c:\Users\cho77175\Desktop\code\drivers\DoPE.dll",
]

ports = [5, 6, 7, 8]

print('[Testing DoPE.dll with all ports]\n')

try:
    dll = WinDLL(dll_paths[0])
    print('[OK] DoPE.dll loaded\n')
    
    fn = getattr(dll, 'DoPEOpenLink')
    fn.argtypes = [c_uint, c_uint, c_uint, c_uint, c_uint, c_uint, c_void_p, POINTER(c_void_p)]
    fn.restype = c_int
    
    for port in ports:
        for baud in [9600]:
            handle = c_void_p()
            res = fn(port, baud, 10, 10, 50, 0x0289, 0, byref(handle))
            
            status = 'OK' if res == 0 else 'FAIL'
            print(f'  COM{port} @ {baud}: {status} (0x{res:04X})', end='')
            if res == 0:
                print(f' HANDLE={handle.value} [CONNECTED!]')
            else:
                print()

except Exception as e:
    print(f'[ERROR] {e}')
    import traceback
    traceback.print_exc()
