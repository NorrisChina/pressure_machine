#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
自动向上移动测试 - 不需要任何输入
"""
import ctypes
import time
import sys
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
if not DLL_PATH.exists():
    print("[ERROR] DoPE.dll not found at", DLL_PATH)
    sys.exit(1)

dope = ctypes.WinDLL(str(DLL_PATH))

DoPERR_NOERROR = 0x0000
MOVE_STOP = 0
MOVE_UP = 1
MOVE_DOWN = 2
CTRL_MODE_POS = 0

class DoPEData(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Position", ctypes.c_double),
        ("Load", ctypes.c_double),
        ("Time", ctypes.c_double),
        ("Cycles", ctypes.c_uint),
        ("Extension", ctypes.c_double),
        ("TensionInfo", ctypes.c_uint),
        ("Speed", ctypes.c_double),
        ("reserved", ctypes.c_char * 36),
    ]

# signatures

dope.DoPEOpenLink.argtypes = [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ulong)]
dope.DoPEOpenLink.restype = ctypes.c_ulong

dope.DoPESetNotification.argtypes = [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint]
dope.DoPESetNotification.restype = ctypes.c_ulong

dope.DoPESelSetup.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)]
dope.DoPESelSetup.restype = ctypes.c_ulong

dope.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
dope.DoPEOn.restype = ctypes.c_ulong

dope.DoPECtrlTestValues.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
dope.DoPECtrlTestValues.restype = ctypes.c_ulong

dope.DoPETransmitData.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_ushort)]
dope.DoPETransmitData.restype = ctypes.c_ulong

dope.DoPEGetData.argtypes = [ctypes.c_ulong, ctypes.POINTER(DoPEData)]
dope.DoPEGetData.restype = ctypes.c_ulong

dope.DoPEFMove.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_double, ctypes.c_void_p]
dope.DoPEFMove.restype = ctypes.c_ulong

class Controller:
    def __init__(self, port=7, baud=9600, speed=2.0):
        self.port = port
        self.baud = baud
        self.speed = speed
        self.hdl = ctypes.c_ulong(0)

    def connect(self):
        err = dope.DoPEOpenLink(self.port, self.baud, 10, 10, 10, 0x0289, None, ctypes.byref(self.hdl))
        if err != DoPERR_NOERROR:
            print(f"[ERROR] OpenLink failed 0x{err:04x}")
            return False
        dope.DoPESetNotification(self.hdl, 0xffffffff, None, None, 0)
        tan_first = ctypes.c_ushort(0)
        tan_last = ctypes.c_ushort(0)
        err = dope.DoPESelSetup(self.hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
        if err != DoPERR_NOERROR:
            print(f"[ERROR] SelSetup failed 0x{err:04x}")
            return False
        err = dope.DoPEOn(self.hdl, None)
        if err != DoPERR_NOERROR:
            print(f"[WARN] DoPEOn returned 0x{err:04x}")
        err = dope.DoPECtrlTestValues(self.hdl, 0)
        if err != DoPERR_NOERROR:
            print(f"[WARN] CtrlTestValues returned 0x{err:04x}")
        err = dope.DoPETransmitData(self.hdl, 1, None)
        if err != DoPERR_NOERROR:
            print(f"[WARN] TransmitData returned 0x{err:04x}")
        print("[OK] Connected and active")
        return True

    def move_up(self):
        err = dope.DoPEFMove(self.hdl, MOVE_UP, ctypes.c_ushort(CTRL_MODE_POS), ctypes.c_double(self.speed), None)
        if err != DoPERR_NOERROR:
            print(f"[WARN] FMove up err 0x{err:04x}")
        else:
            print(f"[OK] Move UP sent (speed={self.speed})")

    def move_down(self):
        err = dope.DoPEFMove(self.hdl, MOVE_DOWN, ctypes.c_ushort(CTRL_MODE_POS), ctypes.c_double(self.speed), None)
        if err != DoPERR_NOERROR:
            print(f"[WARN] FMove down err 0x{err:04x}")
        else:
            print(f"[OK] Move DOWN sent")

    def stop(self):
        err = dope.DoPEFMove(self.hdl, MOVE_STOP, ctypes.c_ushort(CTRL_MODE_POS), ctypes.c_double(0.0), None)
        if err != DoPERR_NOERROR:
            print(f"[WARN] FMove stop err 0x{err:04x}")
        else:
            print("[OK] STOP sent")

    def get_data(self):
        data = DoPEData()
        err = dope.DoPEGetData(self.hdl, ctypes.byref(data))
        if err == DoPERR_NOERROR:
            return data
        return None

    def close(self):
        try:
            err = dope.DoPEFMove(self.hdl, MOVE_STOP, ctypes.c_ushort(CTRL_MODE_POS), ctypes.c_double(0.0), None)
        except Exception:
            pass


def main():
    print("=" * 60)
    print("自动向上移动测试")
    print("=" * 60)
    
    c = Controller(speed=2.0)
    if not c.connect():
        return
    
    try:
        # 自动向上移动
        print("\n[1] 向上移动 10 秒...")
        c.move_up()
        
        for i in range(10):
            time.sleep(1)
            data = c.get_data()
            if data:
                print(f"   [{i+1}s] Pos={data.Position:.4f}mm | Load={data.Load:.2f}N | Speed={data.Speed:.4f}")
            else:
                print(f"   [{i+1}s] GetData failed")
        
        # 停止
        print("\n[2] 停止...")
        c.stop()
        time.sleep(1)
        
        # 自动向下移动
        print("\n[3] 向下移动 10 秒...")
        c.move_down()
        
        for i in range(10):
            time.sleep(1)
            data = c.get_data()
            if data:
                print(f"   [{i+1}s] Pos={data.Position:.4f}mm | Load={data.Load:.2f}N | Speed={data.Speed:.4f}")
            else:
                print(f"   [{i+1}s] GetData failed")
        
        # 停止
        print("\n[4] 停止...")
        c.stop()
        
    finally:
        c.close()
        print("\n" + "=" * 60)
        print("测试完成")
        print("=" * 60)


if __name__ == "__main__":
    main()
