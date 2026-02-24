#!/usr/bin/env python3
from drivers.dope_driver import DopeDriver

driver = DopeDriver()
print('[Testing all ports for quick response]\n')

for port in [5, 6, 8]:
    print(f'COM{port}:')
    for baud in [9600]:
        for api in [0x0289, 0x028A, 0x0288]:
            res, _ = driver.open_link(port=port, baudrate=baud, apiver=api)
            status = 'OK' if res == 0 else f'0x{res:04X}'
            print(f'  {baud} baud, api=0x{api:04X}: {status}')
    print()
