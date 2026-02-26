#!/usr/bin/env python3
"""
Dump all exported functions from DoDpx.dll using ctypes
"""
from ctypes import WinDLL, WINFUNCTYPE
import ctypes

dll_path = r"c:\Users\cho77175\Desktop\code\drivers\DoDpx.dll"

print('[Loading DoDpx.dll and attempting to enumerate functions]\n')

try:
    dll = WinDLL(dll_path)
    print('[OK] DoDpx.dll loaded\n')
    
    # Try common function name patterns used by Delphi/DoPE software
    common_names = [
        # Opening/Closing
        'OpenLink', 'CloseLink', 'Open', 'Close',
        'OpenPort', 'ClosePort', 
        'OpenSerial', 'CloseSerial',
        
        # Data reading
        'GetData', 'ReadData', 'GetMeasData', 'GetMeasuringData',
        'GetMsg', 'ReadMsg', 
        
        # Control
        'Move', 'MoveTo', 'MoveToPosition', 'MoveToLoad',
        'GoZero', 'GoRest', 'Stop', 'Emergency',
        'Start', 'StartMeasurement', 'StopMeasurement',
        
        # Setup
        'Init', 'Initialize', 'Setup', 'Configure',
        'SetSensor', 'SetParameter', 'GetParameter',
        
        # Info
        'GetVersion', 'Version', 'GetInfo', 'GetStatus',
        'GetHandle', 'IsConnected',
        
        # Callbacks
        'SetNotification', 'SetCallback', 'RegisterCallback',
        
        # Advanced
        'LoadConfig', 'SaveConfig',
        'GetConfig', 'SetConfig',
    ]
    
    print('Scanning for exported functions:\n')
    found = []
    
    for name in common_names:
        # Try different prefix combinations
        for prefix in ['DoPE', 'DoDpx', 'Dope', 'DoPx', 'DoDP', '']:
            full_name = prefix + name if prefix else name
            try:
                fn = getattr(dll, full_name, None)
                if fn is not None:
                    found.append(full_name)
                    print(f'  ✓ {full_name}')
                    break
            except:
                pass
    
    if not found:
        print('  (No standard functions found)')
        print('\n  Trying ordinal-based exports (common in older DLLs)...')
        
        # Try to call by ordinal
        for i in range(1, 20):
            try:
                fn = dll[i]
                print(f'    Ordinal {i}: exists')
            except:
                pass
        
except Exception as e:
    print(f'[ERROR] {e}')
    import traceback
    traceback.print_exc()
