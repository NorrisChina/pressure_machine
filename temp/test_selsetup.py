import ctypes
import sys
import os

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

print("=== DoPE Complete Initialization Test ===\n")

# Define functions
DoPEOpenLink = dll.DoPEOpenLink
DoPECloseLink = dll.DoPECloseLink
DoPEGetData = dll.DoPEGetData

# Try to get DoPESelSetup function
try:
    DoPESelSetup = dll.DoPESelSetup
    print("✓ DoPESelSetup function found in DLL")
    has_selsetup = True
except AttributeError:
    print("✗ DoPESelSetup function NOT found in DLL")
    has_selsetup = False

# Open connection
print("\n--- Step 1: Opening Connection ---")
port = 7
baudrate = 9600
apiver = 0x0289
handle = ctypes.c_void_p()

result = DoPEOpenLink(
    ctypes.c_int(port),
    ctypes.c_int(baudrate),
    ctypes.c_int(10),  # RcvBuffers
    ctypes.c_int(10),  # XmitBuffers
    ctypes.c_int(10),  # DataBuffers
    ctypes.c_int(apiver),
    ctypes.c_void_p(0),
    ctypes.byref(handle)
)

if result == 0:
    print(f"✓ Connection opened successfully")
    print(f"  Handle: {handle.value:#x}")
else:
    print(f"✗ Failed to open connection: error code {result:#x}")
    sys.exit(1)

# Read data before initialization
print("\n--- Step 2: Reading Data BEFORE Setup Selection ---")
data = DoPEData()
result = DoPEGetData(handle, ctypes.byref(data))
print(f"DoPEGetData result: {result:#x}")
print(f"  Position: {data.Position:.2f}")
print(f"  Load: {data.Load:.2f}")
print(f"  Time: {data.Time:.2f}")
print(f"  Cycles: {data.Cycles}")

# Try DoPESelSetup if available
if has_selsetup:
    print("\n--- Step 3: Attempting DoPESelSetup ---")
    
    # Try different parameter combinations
    print("\nAttempt 1: DoPESelSetup(handle, 1, NULL, NULL, NULL)")
    try:
        # DoPESelSetup parameters:
        # handle, SetupNo, UserScale[], &TANFirst, &TANLast
        result = DoPESelSetup(
            handle,
            ctypes.c_int(1),  # Setup No. 1
            ctypes.c_void_p(0),  # NULL for UserScale
            ctypes.c_void_p(0),  # NULL for TANFirst
            ctypes.c_void_p(0)   # NULL for TANLast
        )
        print(f"  Result: {result:#x}")
        if result == 0:
            print("  ✓ Setup selection successful!")
        else:
            print(f"  ✗ Failed with error code {result:#x}")
    except Exception as e:
        print(f"  ✗ Exception: {e}")
    
    # Read data after DoPESelSetup
    print("\n--- Step 4: Reading Data AFTER Setup Selection ---")
    data2 = DoPEData()
    result = DoPEGetData(handle, ctypes.byref(data2))
    print(f"DoPEGetData result: {result:#x}")
    print(f"  Position: {data2.Position:.2f}")
    print(f"  Load: {data2.Load:.2f}")
    print(f"  Time: {data2.Time:.2f}")
    print(f"  Cycles: {data2.Cycles}")
    
    # Check if data changed
    if (data2.Position != 0 or data2.Load != 0 or 
        data2.Time != 0 or data2.Cycles != 0):
        print("\n✓ SUCCESS! Data is no longer all zeros!")
    else:
        print("\n✗ Data is still all zeros")

else:
    print("\n--- Step 3: Cannot test DoPESelSetup (not in DLL) ---")

# Try to list all available functions by checking common names
print("\n--- Additional DLL Function Check ---")
function_names = [
    'DoPESelSetup',
    'DoPESetNotification',
    'DoPEFMove',
    'DoPEPos',
    'DoPEHalt',
    'DoPEGetMsg',
    'DoPEGetState',
    'DoPESendMsg',
    'DoPETransmitData',
    'DoPERefr',
    'DoPESetTime',
    'DoPERdVersion',
    'DoPEOpenSetup',
    'DoPECloseSetup',
    'DoPERdSetupAll',
    'DoPEWrSetupAll',
]

available = []
for fname in function_names:
    try:
        func = getattr(dll, fname)
        available.append(fname)
        print(f"  ✓ {fname}")
    except AttributeError:
        print(f"  ✗ {fname}")

print(f"\nTotal available functions: {len(available)}")

# Close connection
print("\n--- Closing Connection ---")
DoPECloseLink(handle)
print("✓ Connection closed")

print("\n=== Test Complete ===")
