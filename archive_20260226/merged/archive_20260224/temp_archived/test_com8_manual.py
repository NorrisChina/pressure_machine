#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Manual protocol test for COM8 FTDI device
Try to understand what DoPE DLL expects
"""
from ctypes import WinDLL, c_uint, c_void_p, c_int, POINTER, byref
import time

print('[Testing COM8 manual DoPE protocol handshake]\n')

dll_path = r"c:\Users\cho77175\Desktop\code\drivers\DoPE.dll"
try:
    dll = WinDLL(dll_path)
    print('[OK] DLL loaded')
except Exception as e:
    print(f'[FAIL] DLL load: {e}')
    exit(1)

# Check available functions
print('\nChecking DLL functions...')
funcs = ['DoPEOpenLink', 'DoPECloseLink', 'DoPEGetData', 'DoPEInitialize']
for fname in funcs:
    has_it = hasattr(dll, fname)
    print(f'  {fname}: {"YES" if has_it else "NO"}')

# Try opening COM8 with verbose error checking
print('\nTrying COM8 open_link with various configs:\n')

configs_to_try = [
    # (port, baud, rcvbuf, xmitbuf, databuf, apiver)
    (8, 9600, 10, 10, 50, 0x0289),
    (8, 9600, 256, 256, 256, 0x0289),
    (8, 9600, 4096, 4096, 4096, 0x0289),
    (8, 19200, 256, 256, 256, 0x0289),
    (8, 115200, 256, 256, 256, 0x0289),
    (8, 9600, 10, 10, 50, 0x028A),
]

for port, baud, rcvbuf, xmitbuf, databuf, apiver in configs_to_try:
    try:
        fn = dll.DoPEOpenLink
        fn.argtypes = [c_uint, c_uint, c_uint, c_uint, c_uint, c_uint, c_void_p, POINTER(c_void_p)]
        fn.restype = c_int
        
        handle = c_void_p()
        res = fn(port, baud, rcvbuf, xmitbuf, databuf, apiver, 0, byref(handle))
        
        status = 'OK' if res == 0 else f'0x{res:04X}'
        print(f'[{status}] port={port}, baud={baud:6d}, rcv={rcvbuf:4d}, xmit={xmitbuf:4d}, data={databuf:4d}, api=0x{apiver:04X}')
        
        if res == 0:
            print(f'      -> handle={handle.value}')
            
            # Try to get data immediately
            try:
                get_data_fn = dll.DoPEGetData
                get_data_fn.argtypes = [c_void_p, POINTER(c_void_p)]
                get_data_fn.restype = c_int
                data = c_void_p()
                res2 = get_data_fn(handle, byref(data))
                print(f'      -> get_data returned 0x{res2:04X}')
            except Exception as e:
                print(f'      -> get_data failed: {e}')
            
            # Close
            try:
                close_fn = dll.DoPECloseLink
                close_fn.argtypes = [c_void_p]
                close_fn.restype = c_int
                res3 = close_fn(handle)
                print(f'      -> close returned 0x{res3:04X}')
            except:
                pass
    
    except Exception as e:
        print(f'[ERROR] {port},{baud}: {e}')

print('\n[INFO] If all returned 0x800B (NO_RESPONSE), COM8 might not have the device')
print('[INFO] Check if physical device is connected to COM8 FTDI adapter')
