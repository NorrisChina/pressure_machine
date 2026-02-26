#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from drivers.dope_driver import DopeDriver
import time

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

# 连接 COM7
print('连接 COM7...')
error_code, handle = driver.open_link(port=7, baudrate=9600, apiver=0x0289)
print(f'open_link → 0x{error_code:04X} ({error_name(error_code)})')
print(f'Handle: {handle}\n')

if error_code == 0:
    # 尝试多次读取数据
    print('多次调用 get_data()：\n')
    for i in range(5):
        try:
            res, data = driver.get_data()
            print(f'  [{i+1}] get_data() → 0x{res:04X} ({error_name(res)})')
            if data:
                pos = getattr(data, 'Position', None)
                load = getattr(data, 'Load', None)
                time_val = getattr(data, 'Time', None)
                cycles = getattr(data, 'Cycles', None)
                print(f'      Position={pos}, Load={load}, Time={time_val}, Cycles={cycles}')
        except Exception as e:
            print(f'  [{i+1}] 错误: {e}')
        
        time.sleep(0.2)
    
    print('\n设备工作状态检查：')
    print('- 如果读到实数据，说明设备正常工作')
    print('- 如果都是 0x8001，可能需要特殊初始化命令')
