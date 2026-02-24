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

print("=== DoPE Full Activation Test ===\n")

# Define functions
DoPEOpenLink = dll.DoPEOpenLink
DoPECloseLink = dll.DoPECloseLink
DoPEGetData = dll.DoPEGetData
DoPESelSetup = dll.DoPESelSetup
DoPETransmitData = dll.DoPETransmitData
DoPEFMove = dll.DoPEFMove
DoPEHalt = dll.DoPEHalt
DoPEGetMsg = dll.DoPEGetMsg

# Constants from documentation
MOVE_UP = 1
MOVE_DOWN = 2

# Open connection
print("Step 1: Opening Connection")
port = 7
baudrate = 9600
apiver = 0x0289
handle = ctypes.c_void_p()

result = DoPEOpenLink(
    ctypes.c_int(port),
    ctypes.c_int(baudrate),
    ctypes.c_int(10),
    ctypes.c_int(10),
    ctypes.c_int(10),
    ctypes.c_int(apiver),
    ctypes.c_void_p(0),
    ctypes.byref(handle)
)

if result != 0:
    print(f"✗ Failed to open connection: {result:#x}")
    sys.exit(1)
print(f"✓ Connection opened (handle: {handle.value:#x})")

# Select Setup
print("\nStep 2: Selecting Setup 1")
result = DoPESelSetup(
    handle,
    ctypes.c_int(1),
    ctypes.c_void_p(0),
    ctypes.c_void_p(0),
    ctypes.c_void_p(0)
)
print(f"DoPESelSetup result: {result:#x}")
if result == 0:
    print("✓ Setup selected")
else:
    print(f"✗ Failed to select setup")

# Enable data transmission
print("\nStep 3: Enabling Data Transmission")
result = DoPETransmitData(
    handle,
    ctypes.c_int(1),  # TRUE = Enable
    ctypes.c_void_p(0)  # No TAN needed
)
print(f"DoPETransmitData result: {result:#x}")
if result == 0:
    print("✓ Data transmission enabled")
else:
    print(f"✗ Failed to enable data transmission")

# Wait a moment for device to start transmitting
time.sleep(0.5)

# Read data
print("\nStep 4: Reading Data")
for i in range(3):
    data = DoPEData()
    result = DoPEGetData(handle, ctypes.byref(data))
    print(f"  Read {i+1} - Result: {result:#x}")
    print(f"    Position: {data.Position:.4f}")
    print(f"    Load: {data.Load:.4f}")
    print(f"    Time: {data.Time:.4f}")
    print(f"    Cycles: {data.Cycles}")
    time.sleep(0.2)

# Check for messages
print("\nStep 5: Checking Messages")
msg_buffer = ctypes.create_string_buffer(256)
msg_len = ctypes.c_int()
result = DoPEGetMsg(handle, msg_buffer, ctypes.c_int(256), ctypes.byref(msg_len))
print(f"DoPEGetMsg result: {result:#x}")
if result == 0 and msg_len.value > 0:
    print(f"  Message received (length: {msg_len.value})")
    print(f"  Content: {msg_buffer.raw[:msg_len.value].hex()}")
else:
    print("  No messages")

# Try to move
print("\nStep 6: Testing Movement Command")
print("Attempting DoPEFMove (MOVE_UP, 0.001 m/s)...")
result = DoPEFMove(
    handle,
    ctypes.c_int(MOVE_UP),
    ctypes.c_double(0.001)  # Very slow speed: 1mm/s
)
print(f"DoPEFMove result: {result:#x}")
if result == 0:
    print("✓ Movement command sent!")
    
    # Read data while moving
    print("\nReading data while moving:")
    for i in range(5):
        time.sleep(0.3)
        data = DoPEData()
        result = DoPEGetData(handle, ctypes.byref(data))
        print(f"  {i+1}. Pos: {data.Position:.4f}, Load: {data.Load:.4f}, Status1: {data.StatusWord1:#x}")
    
    # Stop movement
    print("\nStopping movement...")
    result = DoPEHalt(handle, ctypes.c_void_p(0))
    print(f"DoPEHalt result: {result:#x}")
    
else:
    print(f"✗ Movement command failed: {result:#x}")
    # Try to get error details
    if result == 0x8001:
        print("  Error 0x8001: Likely 'No data available' or device not initialized properly")
    elif result == 0x8002:
        print("  Error 0x8002: Invalid parameter")
    elif result == 0x8003:
        print("  Error 0x8003: Communication error")

# Close connection
print("\nStep 7: Closing Connection")
DoPECloseLink(handle)
print("✓ Connection closed")

print("\n=== Test Complete ===")
