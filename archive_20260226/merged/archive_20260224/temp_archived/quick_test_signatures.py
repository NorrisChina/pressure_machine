#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Quick Test - Proper function signature discovery
"""

import ctypes
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
dope = ctypes.WinDLL(str(DLL_PATH))

print("[OK] DoPE.dll loaded")

# First test: Connect
hdl = ctypes.c_ulong(0)
err = dope.DoPEOpenLink(7, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl))
print("[1] DoPEOpenLink returned: 0x{:04x}, Handle: 0x{:x}".format(err, hdl.value if hdl.value else 0))

if err == 0:
    print("\n[2] Trying DoPESelSetup...")
    
    tan_first = ctypes.c_ushort(0)
    tan_last = ctypes.c_ushort(0)
    
    # Try calling without setting argtypes first
    try:
        err2 = dope.DoPESelSetup(hdl.value, 1, 1, ctypes.byref(tan_first), ctypes.byref(tan_last))
        print("[2.1] DoPESelSetup returned: 0x{:04x}".format(err2))
        print("      TAN First: {}, Last: {}".format(tan_first.value, tan_last.value))
    except Exception as e:
        print("[2.1] Error with hdl.value: {}".format(e))
        
        # Try with ctypes.byref(hdl)
        try:
            err2 = dope.DoPESelSetup(ctypes.byref(hdl), 1, 1, ctypes.byref(tan_first), ctypes.byref(tan_last))
            print("[2.2] DoPESelSetup returned: 0x{:04x}".format(err2))
            print("      TAN First: {}, Last: {}".format(tan_first.value, tan_last.value))
        except Exception as e2:
            print("[2.2] Error with ctypes.byref(hdl): {}".format(e2))
    
    # Also try enabling data transmission
    #print("\n[3] Trying DoPETransmitData...")
    #dope.DoPETransmitData.argtypes = [ctypes.c_ulong, ctypes.c_int, ctypes.POINTER(ctypes.c_ushort)]
    #dope.DoPETransmitData.restype = ctypes.c_ulong
    #err3 = dope.DoPETransmitData(hdl, 1, None)
    #print("[3] DoPETransmitData returned: 0x{:04x}".format(err3))
    
    # Try reading data
    #print("\n[4] Trying DoPEGetData...")
    #
    #class DoPEData(ctypes.Structure):
    #    _pack_ = 1
    #    _fields_ = [
    #        ("Position", ctypes.c_double),
    #        ("Load", ctypes.c_double),
    #        ("Time", ctypes.c_double),
    #        ("Cycles", ctypes.c_uint),
    #        ("Extension", ctypes.c_double),
    #        ("TensionInfo", ctypes.c_uint),
    #        ("Speed", ctypes.c_double),
    #        ("reserved", ctypes.c_char * 36),
    #    ]
    #
    #dope.DoPEGetData.argtypes = [ctypes.c_ulong, ctypes.POINTER(DoPEData)]
    #dope.DoPEGetData.restype = ctypes.c_ulong
    #
    #data = DoPEData()
    #err4 = dope.DoPEGetData(hdl, ctypes.byref(data))
    #print("[4] DoPEGetData returned: 0x{:04x}".format(err4))
    #if err4 == 0:
    #    print("    Position: {:.4f} mm".format(data.Position))
    #    print("    Load: {:.2f} N".format(data.Load))
    #    print("    Time: {:.4f} s".format(data.Time))
    
    # Try FMove
    #print("\n[5] Trying DoPEFMove UP...")
    #dope.DoPEFMove.argtypes = [ctypes.c_ulong, ctypes.c_int, ctypes.c_double]
    #dope.DoPEFMove.restype = ctypes.c_ulong
    #err5 = dope.DoPEFMove(hdl, 1, 0.5)
    #print("[5] DoPEFMove(UP, 0.5) returned: 0x{:04x}".format(err5))
    
    # Disconnect
    #print("\n[6] Disconnecting...")
    #dope.DoPECloseLink.argtypes = [ctypes.c_ulong]
    #err6 = dope.DoPECloseLink(hdl)
    #print("[6] DoPECloseLink returned: 0x{:04x}".format(err6))
