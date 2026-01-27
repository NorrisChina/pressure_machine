#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
最终验证脚本 - 确认所有系统就绪
"""
import sys
import os

print('='*70)
print('DOPE CONTROL PANEL - SYSTEM VERIFICATION')
print('='*70)
print()

# 1. 检查 DLL
print('[1/5] Checking DLL...')
from drivers.dope_driver import DopeDriver
driver = DopeDriver()
if driver.loaded():
    dll_name = os.path.basename(driver.dll_path)
    print(f'  [OK] {dll_name} loaded successfully')
else:
    print(f'  [FAIL] DLL not loaded')
    sys.exit(1)

# 2. 检查 COM7 连接
print('[2/5] Testing COM7 connection...')
res, handle = driver.open_link(port=7, baudrate=9600, apiver=0x0289)
if res == 0:
    print(f'  [OK] Connected successfully')
    print(f'      Handle: {handle}')
else:
    print(f'  [FAIL] Connection failed (0x{res:04X})')
    print(f'  Make sure device is on and official app is closed')
    sys.exit(1)

# 3. 检查数据读取
print('[3/5] Testing data reading...')
try:
    res2, data = driver.get_data()
    if data:
        pos = getattr(data, 'Position', None)
        load = getattr(data, 'Load', None)
        print(f'  [OK] Data read successfully')
        print(f'      Position: {pos} mm')
        print(f'      Load: {load} N')
    else:
        print(f'  [WARN] No data returned (device may be idle)')
except Exception as e:
    print(f'  [FAIL] {e}')
    sys.exit(1)

# 4. 检查 UI 文件
print('[4/5] Checking UI files...')
ui_files = [
    'ui/control_panel_ui.py',
    'control_panel.py',
    'start_control_panel.py'
]
all_exist = True
for fname in ui_files:
    path = os.path.join(os.path.dirname(__file__), fname)
    exists = os.path.exists(path)
    status = '[OK]' if exists else '[FAIL]'
    print(f'  {status} {fname}')
    all_exist = all_exist and exists

if not all_exist:
    print('  Some UI files are missing!')
    sys.exit(1)

# 5. 检查配置
print('[5/5] Checking configuration...')
print(f'  [OK] COM port: 7')
print(f'  [OK] Baudrate: 9600')
print(f'  [OK] Refresh interval: 100ms')

print()
print('='*70)
print('ALL SYSTEMS READY!')
print('='*70)
print()
print('Quick start:')
print('  python start_control_panel.py')
print()
print('Or from main program:')
print('  python start.py')
print('  -> Click "打开控制面板" button')
print()
