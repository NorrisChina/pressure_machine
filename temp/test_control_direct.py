import ctypes
import sys
import os
import time

# Add drivers folder to PATH
os.add_dll_directory(os.path.join(os.getcwd(), 'drivers'))

# Load the DoPE DLL
dll = ctypes.WinDLL('drivers/DoPE.dll')

# Define DoPEData structure
class DoPEData(ctypes.Structure):
    _fields_ = [
        ("Position", ctypes.c_double),
        ("Load", ctypes.c_double),
        ("Time", ctypes.c_double),
        ("Cycles", ctypes.c_ulong),
        ("Extension", ctypes.c_double),
        ("AnalogIn1", ctypes.c_double),
        ("AnalogIn2", ctypes.c_double),
        ("AnalogIn3", ctypes.c_double),
        ("AnalogOut1", ctypes.c_double),
        ("AnalogOut2", ctypes.c_double),
        ("BitInput", ctypes.c_ushort),
        ("BitOutput", ctypes.c_ushort),
        ("StatusWord1", ctypes.c_ushort),
        ("StatusWord2", ctypes.c_ushort),
    ]

# Define functions
DoPEOpenLink = dll.DoPEOpenLink
DoPECloseLink = dll.DoPECloseLink
DoPEGetData = dll.DoPEGetData
DoPESelSetup = dll.DoPESelSetup
DoPETransmitData = dll.DoPETransmitData
DoPEFMove = dll.DoPEFMove
DoPEPos = dll.DoPEPos
DoPEHalt = dll.DoPEHalt

# Constants
MOVE_UP = 1
MOVE_DOWN = 2
CTRL_POS = 0
CTRL_LOAD = 1

print("="*80)
print("DoPE Device Control - Direct Testing")
print("="*80)
print()

# Open connection
print("[1/5] Opening connection to device...")
handle = ctypes.c_void_p()
result = DoPEOpenLink(
    ctypes.c_int(7),
    ctypes.c_int(9600),
    ctypes.c_int(10),
    ctypes.c_int(10),
    ctypes.c_int(10),
    ctypes.c_int(0x0289),
    ctypes.c_void_p(0),
    ctypes.byref(handle)
)

if result != 0:
    print(f"✗ Connection failed: {result:#x}")
    sys.exit(1)

print(f"✓ Connection opened")

# Select Setup
print("[2/5] Selecting Setup 1...")
result = DoPESelSetup(
    handle,
    ctypes.c_int(1),
    ctypes.c_void_p(0),
    ctypes.c_void_p(0),
    ctypes.c_void_p(0)
)
print(f"✓ Setup selected")

# Enable data transmission
print("[3/5] Enabling data transmission...")
result = DoPETransmitData(
    handle,
    ctypes.c_int(1),
    ctypes.c_void_p(0)
)
print(f"✓ Data transmission enabled")
print()

# Read initial data
print("[4/5] Reading initial data...")
data = DoPEData()
DoPEGetData(handle, ctypes.byref(data))
print(f"Initial Position: {data.Position:.4f}m, Load: {data.Load:.2f}N")
print()

# Test sequence
print("[5/5] Starting test sequence...\n")

# Test 1: Move up
print("TEST 1: Moving UP with speed 0.005 m/s for 3 seconds")
print("-" * 60)
result = DoPEFMove(
    handle,
    ctypes.c_int(MOVE_UP),
    ctypes.c_double(0.005)
)
print(f"Command sent: {result:#x}")

for i in range(10):
    time.sleep(0.3)
    data = DoPEData()
    DoPEGetData(handle, ctypes.byref(data))
    print(f"  {i+1}. Pos: {data.Position:8.4f}m | Load: {data.Load:8.2f}N | Time: {data.Time:6.2f}s")

# Stop
print("\nStopping movement...")
result = DoPEHalt(handle, ctypes.c_void_p(0))
print(f"HALT command: {result:#x}")
time.sleep(1)

data = DoPEData()
DoPEGetData(handle, ctypes.byref(data))
print(f"Final position after UP: {data.Position:.4f}m, Load: {data.Load:.2f}N\n")

# Test 2: Move down
print("TEST 2: Moving DOWN with speed 0.005 m/s for 3 seconds")
print("-" * 60)
result = DoPEFMove(
    handle,
    ctypes.c_int(MOVE_DOWN),
    ctypes.c_double(0.005)
)
print(f"Command sent: {result:#x}")

for i in range(10):
    time.sleep(0.3)
    data = DoPEData()
    DoPEGetData(handle, ctypes.byref(data))
    print(f"  {i+1}. Pos: {data.Position:8.4f}m | Load: {data.Load:8.2f}N | Time: {data.Time:6.2f}s")

# Stop
print("\nStopping movement...")
result = DoPEHalt(handle, ctypes.c_void_p(0))
print(f"HALT command: {result:#x}")
time.sleep(1)

data = DoPEData()
DoPEGetData(handle, ctypes.byref(data))
print(f"Final position after DOWN: {data.Position:.4f}m, Load: {data.Load:.2f}N\n")

# Test 3: Position control
print("TEST 3: Position Control - Move to 0.05m with speed 0.01 m/s")
print("-" * 60)
result = DoPEPos(
    handle,
    ctypes.c_int(CTRL_POS),
    ctypes.c_double(0.01),
    ctypes.c_double(0.05)
)
print(f"Command sent: {result:#x}")

for i in range(15):
    time.sleep(0.2)
    data = DoPEData()
    DoPEGetData(handle, ctypes.byref(data))
    print(f"  {i+1}. Pos: {data.Position:8.4f}m | Load: {data.Load:8.2f}N | Time: {data.Time:6.2f}s")
    
    if abs(data.Position - 0.05) < 0.001:  # Close enough
        print("  ✓ Position reached!")
        break

time.sleep(0.5)
data = DoPEData()
DoPEGetData(handle, ctypes.byref(data))
print(f"Final position: {data.Position:.4f}m, Load: {data.Load:.2f}N\n")

# Close connection
print("Closing connection...")
DoPECloseLink(handle)
print("✓ Connection closed")

print("\n" + "="*80)
print("Test Complete!")
print("="*80)
