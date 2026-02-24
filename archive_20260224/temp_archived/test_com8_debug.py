#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from drivers.dope_driver import DopeDriver

error_code_names = {
    0x0000: "SUCCESS",
    0x8001: "ERROR_INVALID_HANDLE",
    0x8002: "ERROR_INVALID_PARITY",
    0x8003: "ERROR_INVALID_STOPBITS",
    0x8004: "ERROR_INVALID_DATABITS",
    0x8005: "ERROR_INVALID_FLOWCONTROL",
    0x8006: "ERROR_PORT_NOT_EXIST",
    0x800A: "ERROR_CHECKSUM",
    0x800B: "ERROR_NO_RESPONSE",
    0xFFFF: "ERROR_UNKNOWN",
}

def error_name(code):
    return error_code_names.get(code, f"UNKNOWN(0x{code:04X})")

driver = DopeDriver()
print('✓ DLL 加载成功\n' if driver.loaded() else '✗ DLL 加载失败\n')

# 尝试连接 COM8
print('尝试连接 COM8...\n')
for apiver in [0x0289, 0x028A, 0x0288]:
    for baud in [9600, 19200, 115200]:
        error_code, handle = driver.open_link(port=8, baudrate=baud, apiver=apiver)
        status = "✓" if error_code == 0 else "✗"
        print(f"{status} COM8 @ {baud:6d} baud, apiver=0x{apiver:04X}: {error_name(error_code)} (0x{error_code:04X})")
        
        if error_code == 0:
            print(f"     Handle: {handle}")
            try:
                res, data = driver.get_data()
                print(f"     get_data() → res=0x{res:04X} ({error_name(res)})")
                if data:
                    print(f"       Position: {getattr(data, 'Position', 'N/A')}")
                    print(f"       Load: {getattr(data, 'Load', 'N/A')}")
            except Exception as e:
                print(f"     读数据错: {e}")
            print()
            break
    else:
        continue
    break
