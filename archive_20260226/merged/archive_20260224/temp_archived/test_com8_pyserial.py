#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import serial
import time

print('[Testing COM8 with pyserial]\n')

try:
    # Try to open COM8
    ser = serial.Serial('COM8', 9600, timeout=1)
    print(f'[OK] COM8 opened')
    print(f'     Port: {ser.port}')
    print(f'     Baudrate: {ser.baudrate}')
    print(f'     Is open: {ser.is_open}')
    
    # Try to read/write
    ser.write(b'TEST')
    print(f'[OK] Sent 4 bytes')
    
    time.sleep(0.5)
    
    if ser.in_waiting:
        data = ser.read(ser.in_waiting)
        print(f'[OK] Received {len(data)} bytes: {data[:50]}')
    else:
        print(f'[INFO] No data available')
    
    ser.close()
    print(f'[OK] COM8 closed')
    
except serial.SerialException as e:
    print(f'[FAIL] Serial error: {e}')
except Exception as e:
    print(f'[ERROR] {e}')
