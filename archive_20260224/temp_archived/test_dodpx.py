#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Test with DoDpx.dll instead of DoPE.dll
"""
from ctypes import WinDLL, c_uint, c_void_p, c_int, POINTER, byref
import os

print('[Testing DoDpx.dll]\n')

# Try DoDpx.dll
dll_path = r"c:\Users\cho77175\Desktop\code\drivers\DoDpx.dll"
try:
    dll = WinDLL(dll_path)
    print('[OK] DoDpx.dll loaded')
except Exception as e:
    print(f'[FAIL] DoDpx.dll load: {e}')
    exit(1)

# Check functions
print('\nAvailable functions in DoDpx.dll:')
funcs = ['DoPEOpenLink', 'DoPECloseLink', 'DoPEGetData', 'DoPEInitialize',
         'DoDpxOpenLink', 'DoDpxCloseLink', 'DoDpxGetData', 'DoDpxInitialize']
for fname in funcs:
    has_it = hasattr(dll, fname)
    if has_it:
        print(f'  ✓ {fname}')

print('\nTrying COM8 with DoDpx functions:\n')

# Try DoDpxOpenLink
try:
    fn = dll.DoDpxOpenLink
    fn.argtypes = [c_uint, c_uint, c_uint, c_uint, c_uint, c_uint, c_void_p, POINTER(c_void_p)]
    fn.restype = c_int
    
    handle = c_void_p()
    res = fn(8, 9600, 10, 10, 50, 0x0289, 0, byref(handle))
    
    print(f'DoDpxOpenLink(COM8, 9600): 0x{res:04X}')
    
    if res == 0:
        print(f'  -> handle = {handle.value}')
        print('[SUCCESS] Connected!')
    else:
        print('  -> Failed')
        
except AttributeError:
    print('[INFO] DoDpxOpenLink not found, trying DoPEOpenLink')
    try:
        fn = dll.DoPEOpenLink
        fn.argtypes = [c_uint, c_uint, c_uint, c_uint, c_uint, c_uint, c_void_p, POINTER(c_void_p)]
        fn.restype = c_int
        
        handle = c_void_p()
        res = fn(8, 9600, 10, 10, 50, 0x0289, 0, byref(handle))
        
        print(f'DoPEOpenLink(COM8, 9600): 0x{res:04X}')
        
        if res == 0:
            print(f'  -> handle = {handle.value}')
            print('[SUCCESS] Connected!')
    except Exception as e:
        print(f'[ERROR] {e}')
except Exception as e:
    print(f'[ERROR] {e}')
