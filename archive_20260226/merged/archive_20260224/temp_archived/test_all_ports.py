#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from drivers.dope_driver import DopeDriver

error_code_names = {
    0x0000: "SUCCESS",
    0x8001: "DLL 未初始化",
    0x8002: "无效句柄",
    0x8003: "参数错误",
    0x8004: "内存分配失败",
    0x8005: "通信超时",
    0x8006: "串口打开失败",
    0x8007: "串口已被占用",
    0x8008: "数据接收错误",
    0x8009: "数据发送错误",
    0x800A: "校验和错误",
    0x800B: "设备无响应",
}

def error_name(code):
    return error_code_names.get(code, f"UNKNOWN(0x{code:04X})")

driver = DopeDriver()
print('✓ DLL 加载成功\n' if driver.loaded() else '✗ DLL 加载失败\n')

# 尝试所有 COM 口
ports_to_try = [5, 6, 7, 8]  # COM5, COM6, COM7, COM8
connected = False

for port in ports_to_try:
    print(f'--- 尝试连接 COM{port} ---')
    for apiver in [0x0289, 0x028A, 0x0288]:
        for baud in [9600, 19200, 115200]:
            error_code, handle = driver.open_link(port=port, baudrate=baud, apiver=apiver)
            
            if error_code == 0:
                print(f'  ✓ COM{port} @ {baud:6d} baud, apiver=0x{apiver:04X}: SUCCESS')
                print(f'    Handle: {handle}')
                
                # 尝试读取数据
                try:
                    res, data = driver.get_data()
                    print(f'    get_data() → res=0x{res:04X} ({error_name(res)})')
                    if data:
                        pos = getattr(data, 'Position', None)
                        load = getattr(data, 'Load', None)
                        print(f'      Position: {pos}')
                        print(f'      Load: {load}')
                    else:
                        print(f'      (无数据)')
                except Exception as e:
                    print(f'    读数据错: {e}')
                
                connected = True
                break
        
        if connected:
            break
    
    if connected:
        print()
        break
    else:
        print(f'  (全部失败)\n')

if not connected:
    print('\n✗ 无法连接任何 COM 口')
    print('请检查：')
    print('  1. 设备是否真的连接了？')
    print('  2. USB 驱动是否已安装？')
    print('  3. COM8 是 FTDI 芯片，可能不是 DoPE 测量设备')
