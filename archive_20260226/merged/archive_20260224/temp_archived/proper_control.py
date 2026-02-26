#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Proper DoPE Control Script - Following PDF Documentation
Reference: Pages 94-111 in Seriell-DLL-DOPE.pdf
- Page 94: DoPEHalt (Sync) - Stop command
- Page 98: DoPEPos (Sync) - Absolute positioning
- Page 111: DoPEFMove (Sync) - Velocity control
- Page 57-58: DoPEGetData - Read data
"""

import ctypes
import time
import sys
from pathlib import Path

# ============================================================================
# 1. DoPE.dll Loading and Basic Constants
# ============================================================================

# DoPE.dll path
DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"

if not DLL_PATH.exists():
    print("[ERROR] Cannot find DoPE.dll at: {}".format(DLL_PATH))
    sys.exit(1)

try:
    dope = ctypes.WinDLL(str(DLL_PATH))
    print("[OK] DoPE.dll loaded: {}".format(DLL_PATH))
except Exception as e:
    print("[ERROR] Failed to load DoPE.dll: {}".format(e))
    sys.exit(1)

# Error codes
DoPERR_NOERROR = 0x0000
DoPERR_DEVICE_OFFLINE = 0x800a

# Movement direction constants (PDF page 111 DoPEFMove)
MOVE_STOP = 0
MOVE_UP = 1
MOVE_DOWN = 2

# Control mode constants (PDF page 111)
CTRL_MODE_POS = 0      # Position control mode
CTRL_MODE_LOAD = 1     # Load/Force control mode

# ============================================================================
# 2. Data Structure Definition (Correct field alignment)
# ============================================================================

class DoPEData(ctypes.Structure):
    """
    DoPE Data Structure - Based on PDF page 57 DoPEGetData definition
    _pack_ = 1 ensures tight alignment (no automatic padding)
    """
    _pack_ = 1
    _fields_ = [
        ("Position", ctypes.c_double),      # [0-7]   : Position (mm)
        ("Load", ctypes.c_double),          # [8-15]  : Force value (N)
        ("Time", ctypes.c_double),          # [16-23] : Time (s)
        ("Cycles", ctypes.c_uint),          # [24-27] : Cycle count
        ("Extension", ctypes.c_double),     # [28-35] : Extension value
        ("TensionInfo", ctypes.c_uint),     # [36-39] : Tension info
        ("Speed", ctypes.c_double),         # [40-47] : Speed
        ("reserved", ctypes.c_char * 36),   # [48-83] : Reserved bytes
    ]


# ============================================================================
# 3. Function Definition (According to PDF documentation)
# ============================================================================

def setup_dll_functions():
    """
    Configure DoPE.dll function signatures
    Reference: PDF documentation pages 94-111
    """
    
    # Initialization functions
    dope.DoPEOpenLink.argtypes = [
        ctypes.c_ulong,     # Port
        ctypes.c_ulong,     # Baudrate
        ctypes.c_ushort,    # Receive buffer count
        ctypes.c_ushort,    # Transmit buffer count
        ctypes.c_ushort,    # Data buffer count
        ctypes.c_ushort,    # API Version
        ctypes.c_void_p,    # lpReserved (NULL)
        ctypes.POINTER(ctypes.c_ulong),  # Output: DoPEHdl
    ]
    dope.DoPEOpenLink.restype = ctypes.c_ulong
    
    # DoPECloseLink
    dope.DoPECloseLink.argtypes = [ctypes.c_ulong]  # DoPEHdl
    dope.DoPECloseLink.restype = ctypes.c_ulong
    
    # DoPESetNotification
    dope.DoPESetNotification.argtypes = [
        ctypes.c_ulong,      # DoPEHdl
        ctypes.c_ulong,      # EventMask
        ctypes.c_void_p,     # Callback function pointer
        ctypes.c_void_p,     # hWnd (window handle)
        ctypes.c_uint,       # WM_DoPEEvent
    ]
    dope.DoPESetNotification.restype = ctypes.c_ulong
    
    # DoPESelSetup (page 47)
    dope.DoPESelSetup.argtypes = [
        ctypes.c_ulong,      # DoPEHdl
        ctypes.c_ushort,     # SetupNo (1-4)
        ctypes.c_void_p,     # US (User Scale pointer or NULL)
        ctypes.POINTER(ctypes.c_ushort),  # Output: TANFirst
        ctypes.POINTER(ctypes.c_ushort),  # Output: TANLast
    ]
    dope.DoPESelSetup.restype = ctypes.c_ulong
    
    # DoPETransmitData (page 61 - Enable data transmission)
    dope.DoPETransmitData.argtypes = [
        ctypes.c_ulong,      # DoPEHdl
        ctypes.c_ushort,     # OnOff (1=On, 0=Off)
        ctypes.POINTER(ctypes.c_ushort),  # Optional TAN pointer
    ]
    dope.DoPETransmitData.restype = ctypes.c_ulong
    
    # CORE CONTROL FUNCTIONS
    
    # DoPEHalt(Sync) (page 94) - Stop all movement
    dope.DoPEHalt.argtypes = [ctypes.c_ulong]
    dope.DoPEHalt.restype = ctypes.c_ulong
    
    # DoPEPos(Sync) (page 98) - Absolute positioning
    dope.DoPEPos.argtypes = [
        ctypes.c_ulong,      # DoPEHdl
        ctypes.c_double,     # TargetPos (mm)
        ctypes.c_double,     # Speed (mm/s)
        ctypes.c_ushort,     # ControlMode (0=Pos, 1=Load)
        ctypes.c_void_p,     # TAN pointer (optional)
    ]
    dope.DoPEPos.restype = ctypes.c_ulong
    
    # DoPEFMove(Sync) (page 111) - Velocity movement (Jog)
    dope.DoPEFMove.argtypes = [
        ctypes.c_ulong,      # DoPEHdl
        ctypes.c_ushort,     # Direction (0=Stop, 1=Up, 2=Down)
        ctypes.c_ushort,     # ControlMode (0=Pos, 1=Load)
        ctypes.c_double,     # Speed (mm/s)
        ctypes.c_void_p,     # TAN pointer (optional)
    ]
    dope.DoPEFMove.restype = ctypes.c_ulong
    
    # DATA READING FUNCTIONS
    
    # DoPEGetData (page 57) - Read data record
    dope.DoPEGetData.argtypes = [
        ctypes.c_ulong,                    # DoPEHdl
        ctypes.POINTER(DoPEData),  # Output: Buffer
    ]
    dope.DoPEGetData.restype = ctypes.c_ulong
    
    # DoPEGetMsg (page 51) - Read message
    dope.DoPEGetMsg.argtypes = [
        ctypes.c_ulong,      # DoPEHdl
        ctypes.c_void_p,     # Buffer
        ctypes.c_ushort,     # BufSize
        ctypes.POINTER(ctypes.c_ushort),  # Output: Length
    ]
    dope.DoPEGetMsg.restype = ctypes.c_ulong
    
    # DoPEGetState (page 58) - Query device state
    dope.DoPEGetState.argtypes = [
        ctypes.c_ulong,                   # DoPEHdl
        ctypes.POINTER(ctypes.c_long),    # Output: Status
    ]
    dope.DoPEGetState.restype = ctypes.c_ulong

    # DoPEOn (page 127) - Enable controller/motion
    dope.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
    dope.DoPEOn.restype = ctypes.c_ulong
    
    print("[OK] DLL function signatures configured")


# ============================================================================
# 4. High-level Python Wrapper Class
# ============================================================================

class DoPEController:
    """DoPE Device Controller Class"""
    
    def __init__(self, port=7, baudrate=9600):
        """Initialize connection"""
        self.port = port
        self.baudrate = baudrate
        self.hdl = ctypes.c_ulong(0)
        self.is_connected = False
        
    def connect(self):
        """Connect to device"""
        print("\n[INFO] Connecting to COM{} @ {} baud...".format(self.port, self.baudrate))
        
        tan_first = ctypes.c_ushort(0)
        tan_last = ctypes.c_ushort(0)
        
        err = dope.DoPEOpenLink(
            self.port,              # COM7
            self.baudrate,          # 9600 baud
            10,                     # Receive buffer count
            10,                     # Transmit buffer count
            10,                     # Data buffer count
            0x0289,                 # API Version (v2.89)
            None,                   # lpReserved
            ctypes.byref(self.hdl), # Output: DoPEHdl
        )
        
        if err != DoPERR_NOERROR:
            print("[ERROR] Connection failed: error code 0x{:04x}".format(err))
            return False
            
        print("[OK] Connected! Handle: 0x{:x}".format(self.hdl.value))
        
        # Set notification
        err = dope.DoPESetNotification(self.hdl, 0xffffffff, None, None, 0)
        if err == DoPERR_NOERROR:
            print("[OK] Notification set")
        
        self.is_connected = True
        return True
    
    def select_setup(self, setup_no=1, user_scale=1):
        """Select Setup and initialize"""
        print("\n[INFO] Selecting Setup {}...".format(setup_no))
        
        tan_first = ctypes.c_ushort(0)
        tan_last = ctypes.c_ushort(0)
        
        err = dope.DoPESelSetup(
            self.hdl,
            setup_no,
            None,  # Use default user scale (NULL)
            ctypes.byref(tan_first),
            ctypes.byref(tan_last),
        )
        
        if err != DoPERR_NOERROR:
            print("[ERROR] Setup selection failed: error code 0x{:04x}".format(err))
            return False
            
        print("[OK] Setup {} selected (TAN: {}-{})".format(setup_no, tan_first.value, tan_last.value))
        
        # Turn controller ON
        err = dope.DoPEOn(self.hdl, None)
        if err == DoPERR_NOERROR:
            print("[OK] Controller ON")
        else:
            print("[WARN] DoPEOn returned: 0x{:04x}".format(err))
        
        # Enable data transmission
        print("[INFO] Enabling data transmission...")
        err = dope.DoPETransmitData(self.hdl, 1, None)
        if err == DoPERR_NOERROR:
            print("[OK] Data transmission enabled")
        else:
            print("[WARN] Data transmission enable returned: 0x{:04x}".format(err))
            
        return True
    
    def read_data(self):
        """Read current sensor data"""
        data = DoPEData()
        err = dope.DoPEGetData(self.hdl, ctypes.byref(data))
        
        if err != DoPERR_NOERROR:
            return None
            
        return data
    
    def get_state(self):
        """Get device state"""
        state = ctypes.c_long(0)
        err = dope.DoPEGetState(self.hdl, ctypes.byref(state))
        
        if err == DoPERR_NOERROR:
            return state.value
        return None
    
    def move_up(self, speed=0.5):
        """Move upward"""
        print("[INFO] Moving up ({} mm/s)...".format(speed))
        err = dope.DoPEFMove(self.hdl, MOVE_UP, ctypes.c_ushort(CTRL_MODE_POS), ctypes.c_double(speed), None)
        
        if err != DoPERR_NOERROR:
            print("[WARN] DoPEFMove returned: 0x{:04x}".format(err))
        return err
    
    def move_down(self, speed=0.5):
        """Move downward"""
        print("[INFO] Moving down ({} mm/s)...".format(speed))
        err = dope.DoPEFMove(self.hdl, MOVE_DOWN, ctypes.c_ushort(CTRL_MODE_POS), ctypes.c_double(speed), None)
        
        if err != DoPERR_NOERROR:
            print("[WARN] DoPEFMove returned: 0x{:04x}".format(err))
        return err
    
    def halt(self):
        """Stop movement"""
        print("[INFO] Halting...")
        err = dope.DoPEFMove(self.hdl, MOVE_STOP, ctypes.c_ushort(CTRL_MODE_POS), ctypes.c_double(0.0), None)
        
        if err != DoPERR_NOERROR:
            print("[WARN] Stop command returned: 0x{:04x}".format(err))
        return err
    
    def move_to(self, target_pos, speed=1.0):
        """Move to absolute position"""
        print("[INFO] Moving to position {:.2f} mm (speed: {:.2f} mm/s)...".format(target_pos, speed))
        err = dope.DoPEPos(
            self.hdl,
            ctypes.c_double(target_pos),
            ctypes.c_double(speed),
            ctypes.c_ushort(CTRL_MODE_POS),
            None,
        )
        
        if err != DoPERR_NOERROR:
            print("[WARN] DoPEPos returned: 0x{:04x}".format(err))
        return err
    
    def disconnect(self):
        """Disconnect from device"""
        if not self.is_connected:
            return True
            
        print("\n[INFO] Disconnecting...")
        err = dope.DoPECloseLink(self.hdl)
        
        if err != DoPERR_NOERROR:
            print("[WARN] Disconnect returned: 0x{:04x}".format(err))
        else:
            print("[OK] Disconnected")
            
        self.is_connected = False
        return err == DoPERR_NOERROR


# ============================================================================
# 5. Demonstration Script
# ============================================================================

def main():
    """Main demonstration program"""
    
    print("\n" + "="*70)
    print("COMPLETE DOPE DEVICE CONTROL DEMONSTRATION - FOLLOWING PDF")
    print("="*70)
    
    # Configure DLL functions
    setup_dll_functions()
    
    # Create controller instance
    controller = DoPEController(port=7, baudrate=9600)
    
    try:
        # 1. Connect to device
        if not controller.connect():
            return
            
        time.sleep(1)
        
        # 2. Select Setup and initialize
        if not controller.select_setup(setup_no=1, user_scale=1):
            return
            
        time.sleep(2)
        
        # 3. Display initial status
        print("\n[INFO] Initial data reading:")
        for i in range(3):
            data = controller.read_data()
            if data:
                print("  [{}] Pos={:.4f}mm | Load={:.2f}N | Time={:.4f}s".format(
                    i+1, data.Position, data.Load, data.Time))
            time.sleep(0.2)
        
        # 4. Velocity control test (Jog)
        print("\n[INFO] Velocity control test (upward at 0.5 mm/s for 3 seconds):")
        controller.move_up(speed=0.5)
        
        for i in range(30):  # 3 seconds @ 0.1s sampling
            data = controller.read_data()
            if data:
                print("  [{:2d}] t={:.4f}s | Pos={:.4f}mm | Load={:.2f}N".format(
                    i+1, data.Time, data.Position, data.Load))
            time.sleep(0.1)
        
        controller.halt()
        time.sleep(1)
        
        # 5. Absolute positioning test
        print("\n[INFO] Absolute positioning test (move to 5.0 mm at 1.0 mm/s):")
        controller.move_to(target_pos=5.0, speed=1.0)
        
        for i in range(20):
            data = controller.read_data()
            if data:
                print("  [{:2d}] Pos={:.4f}mm | Load={:.2f}N".format(i+1, data.Position, data.Load))
            time.sleep(0.1)
        
        controller.halt()
        time.sleep(1)
        
        # 6. Return to start
        print("\n[INFO] Return to start (move to 0.0 mm at 1.0 mm/s):")
        controller.move_to(target_pos=0.0, speed=1.0)
        
        for i in range(20):
            data = controller.read_data()
            if data:
                print("  [{:2d}] Pos={:.4f}mm | Load={:.2f}N".format(i+1, data.Position, data.Load))
            time.sleep(0.1)
        
        controller.halt()
        
        print("\n[SUCCESS] Demonstration complete!")
        
    except KeyboardInterrupt:
        print("\n[WARN] User interrupt")
    except Exception as e:
        print("\n[ERROR] Exception: {}".format(e))
        import traceback
        traceback.print_exc()
    finally:
        controller.disconnect()


if __name__ == "__main__":
    main()
