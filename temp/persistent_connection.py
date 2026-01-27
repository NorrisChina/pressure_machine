import ctypes
import sys
import os
import time
import threading

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
DoPEGetMsg = dll.DoPEGetMsg

# Constants
MOVE_UP = 1
MOVE_DOWN = 2
CTRL_POS = 0
CTRL_LOAD = 1

# Global state
handle = ctypes.c_void_p()
is_connected = False
command_queue = []
lock = threading.Lock()

def connect_device():
    """Connect to device"""
    global handle, is_connected
    
    print("[INIT] Connecting to device on COM7...")
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
        print(f"[ERROR] Connection failed: {result:#x}")
        return False
    
    print(f"[OK] Connection established (handle: {handle.value:#x})")
    
    # Select Setup
    print("[INIT] Selecting Setup 1...")
    result = DoPESelSetup(
        handle,
        ctypes.c_int(1),
        ctypes.c_void_p(0),
        ctypes.c_void_p(0),
        ctypes.c_void_p(0)
    )
    
    if result != 0:
        print(f"[WARN] Setup selection failed: {result:#x}")
    else:
        print("[OK] Setup 1 selected")
    
    # Enable data transmission
    print("[INIT] Enabling data transmission...")
    result = DoPETransmitData(
        handle,
        ctypes.c_int(1),
        ctypes.c_void_p(0)
    )
    
    if result != 0:
        print(f"[WARN] Data transmission enable failed: {result:#x}")
    else:
        print("[OK] Data transmission enabled")
    
    is_connected = True
    return True

def read_data():
    """Read current data from device"""
    global handle
    data = DoPEData()
    result = DoPEGetData(handle, ctypes.byref(data))
    if result == 0:
        return data
    return None

def send_command(cmd_name, cmd_func, *args):
    """Send command to device"""
    global handle
    try:
        result = cmd_func(handle, *args)
        print(f"[CMD] {cmd_name} -> Result: {result:#x}")
        return result
    except Exception as e:
        print(f"[ERROR] {cmd_name} failed: {e}")
        return -1

def data_monitoring_thread():
    """Background thread to continuously monitor data"""
    print("[MONITOR] Data monitoring thread started")
    counter = 0
    while is_connected:
        try:
            data = read_data()
            if data and counter % 5 == 0:  # Print every 5 reads
                print(f"[DATA] Pos: {data.Position:8.4f}m | Load: {data.Load:8.2f}N | "
                      f"Time: {data.Time:8.2f}s | Cycles: {data.Cycles:5d} | Status: {data.StatusWord1:#06x}")
            counter += 1
            time.sleep(0.1)
        except Exception as e:
            print(f"[ERROR] Monitoring thread error: {e}")
            break
    print("[MONITOR] Data monitoring thread stopped")

def process_commands():
    """Process commands from queue"""
    global command_queue, is_connected
    
    print("[COMMAND] Command processor started")
    print("[COMMAND] Available commands:")
    print("  1. MOVE_UP <speed>  - Move up (e.g., '1 0.01')")
    print("  2. MOVE_DOWN <speed> - Move down (e.g., '2 0.01')")
    print("  3. POS <ctrl> <speed> <dest> - Position control (e.g., '3 0 0.02 0.1')")
    print("  4. HALT - Stop movement")
    print("  5. READ - Read current data once")
    print("  6. STATUS - Show connection status")
    print("  0. EXIT - Exit program")
    print()
    
    while is_connected:
        try:
            user_input = input("[INPUT] Enter command: ").strip()
            
            if not user_input:
                continue
            
            parts = user_input.split()
            cmd = parts[0]
            
            if cmd == "0" or cmd.upper() == "EXIT":
                print("[INFO] Exit command received, closing connection...")
                is_connected = False
                break
            
            elif cmd == "1" or cmd.upper() == "MOVE_UP":
                speed = float(parts[1]) if len(parts) > 1 else 0.01
                send_command(f"MOVE_UP ({speed})", DoPEFMove, 
                           ctypes.c_int(MOVE_UP), ctypes.c_double(speed))
            
            elif cmd == "2" or cmd.upper() == "MOVE_DOWN":
                speed = float(parts[1]) if len(parts) > 1 else 0.01
                send_command(f"MOVE_DOWN ({speed})", DoPEFMove, 
                           ctypes.c_int(MOVE_DOWN), ctypes.c_double(speed))
            
            elif cmd == "3" or cmd.upper() == "POS":
                ctrl = int(parts[1]) if len(parts) > 1 else CTRL_POS
                speed = float(parts[2]) if len(parts) > 2 else 0.01
                dest = float(parts[3]) if len(parts) > 3 else 0.1
                send_command(f"POS (ctrl={ctrl}, speed={speed}, dest={dest})", DoPEPos,
                           ctypes.c_int(ctrl), ctypes.c_double(speed), ctypes.c_double(dest))
            
            elif cmd == "4" or cmd.upper() == "HALT":
                send_command("HALT", DoPEHalt, ctypes.c_void_p(0))
            
            elif cmd == "5" or cmd.upper() == "READ":
                data = read_data()
                if data:
                    print(f"[DATA] Position: {data.Position:.4f}m, Load: {data.Load:.2f}N, "
                          f"Time: {data.Time:.2f}s, Cycles: {data.Cycles}")
                else:
                    print("[ERROR] Failed to read data")
            
            elif cmd == "6" or cmd.upper() == "STATUS":
                print(f"[STATUS] Connected: {is_connected}, Handle: {handle.value:#x}")
            
            else:
                print("[WARN] Unknown command. Use 1-6 or EXIT")
        
        except ValueError as e:
            print(f"[ERROR] Invalid input: {e}")
        except KeyboardInterrupt:
            print("\n[INFO] Keyboard interrupt received")
            is_connected = False
            break
        except Exception as e:
            print(f"[ERROR] {e}")

def main():
    """Main function"""
    global is_connected, handle
    
    print("="*60)
    print("DoPE Persistent Connection Control Panel")
    print("="*60)
    print()
    
    # Connect to device
    if not connect_device():
        print("[ERROR] Failed to connect to device")
        return
    
    # Start monitoring thread
    monitor_thread = threading.Thread(target=data_monitoring_thread, daemon=True)
    monitor_thread.start()
    
    # Give monitor thread a moment to start
    time.sleep(0.5)
    
    # Process commands
    try:
        process_commands()
    except KeyboardInterrupt:
        print("\n[INFO] Interrupted by user")
    finally:
        # Close connection
        print("\n[CLEANUP] Closing connection...")
        is_connected = False
        if handle.value:
            try:
                DoPECloseLink(handle)
                print("[OK] Connection closed")
            except Exception as e:
                print(f"[ERROR] Error closing connection: {e}")

if __name__ == "__main__":
    main()
