import ctypes
import time
import sys
from pathlib import Path

# --- 1. 配置区域 ---
DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
COM_PORT = 7  # 对应 COM8
MAX_SPEED = 10.0  # 手动模式的最大速度限制 (mm/s)
SENSOR_NO = 9     # 9 = 面板上的数字旋钮 (DigiPoti)

# --- 2. 结构体定义 (保持你验证过的版本) ---
class DoPEData(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Time", ctypes.c_double),
        ("SampleTime", ctypes.c_double),
        ("Position", ctypes.c_double),
        ("Force", ctypes.c_double),
        ("Speed", ctypes.c_double),
        ("Status", ctypes.c_long),
        ("Dummy", ctypes.c_byte * 20)
    ]

# --- 3. 初始化 ---
if not DLL_PATH.exists():
    print(f"❌ 找不到 DLL: {DLL_PATH}")
    sys.exit(1)

try:
    dope = ctypes.WinDLL(str(DLL_PATH))
except Exception as e:
    print(f"❌ DLL 加载失败: {e}")
    sys.exit(1)

# 定义函数接口
dope.DoPEOpenLink.argtypes = [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ulong)]
dope.DoPESelSetup.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p, ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)]
dope.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.c_void_p]
dope.DoPETransmitData.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p]
dope.DoPEGetData.argtypes = [ctypes.c_ulong, ctypes.POINTER(DoPEData)]
# 关键：你这版 DLL 实测需要 2 个参数 (Handle, Action)
dope.DoPEHalt.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
dope.DoPECloseLink.argtypes = [ctypes.c_ulong]

dope.DoPEFDPoti.argtypes = [
    ctypes.c_ulong,  # Handle
    ctypes.c_ushort, # MoveCtrl (0=Pos)
    ctypes.c_double, # MaxSpeed
    ctypes.c_ushort, # SensorNo (9)
    ctypes.c_ushort, # DxTrigger (死区)
    ctypes.c_ushort, # Mode (0=Abs, 1=Rel)
    ctypes.c_double, # Scale (灵敏度)
    ctypes.c_void_p  # Tan
]

# --- 4. 主程序 ---
hdl = ctypes.c_ulong(0)

def main():
    print(f"🔌 连接 COM{COM_PORT+1} ...")
    if dope.DoPEOpenLink(COM_PORT, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl)) != 0:
        print("❌ 连接失败")
        return

    print("⚙️ 初始化 Setup ...")
    tan = ctypes.c_ushort(0)
    dope.DoPESelSetup(hdl, 1, None, ctypes.byref(tan), ctypes.byref(tan))
    dope.DoPEOn(hdl, None)
    dope.DoPETransmitData(hdl, 1, None)

    print("\n" + "="*50)
    print("🎮 进入 DigiPoti (旋钮控制) 模式")
    print("="*50)
    print(f"👉 请转动机器面板上的大旋钮 (Sensor {SENSOR_NO})")
    print(f"⚠️ 最大速度限制: {MAX_SPEED} mm/s")
    print("⌨️ 按 Ctrl+C 退出并停止")
    print("-" * 50)

    SCALE_FACTOR = 1.0 
    DEAD_ZONE = 20
    
    ret = dope.DoPEFDPoti(hdl, 0, MAX_SPEED, SENSOR_NO, DEAD_ZONE, 0, SCALE_FACTOR, None)
    
    if ret != 0:
        print(f"❌ 启动 DigiPoti 失败: 0x{ret:04x}")
        dope.DoPEHalt(hdl, 0)
        dope.DoPECloseLink(hdl)
        return

    data = DoPEData()
    try:
        while True:
            dope.DoPEGetData(hdl, ctypes.byref(data))
            print(f"\r📍 Pos: {data.Position:8.3f} mm | 💪 Force: {data.Force:8.3f} N", end="")
            time.sleep(0.1)
    except KeyboardInterrupt:
        print("\n\n🛑 正在退出手控模式...")
        dope.DoPEHalt(hdl, 0)
        time.sleep(0.5)
        if hasattr(dope, 'DoPECloseLink'):
            dope.DoPECloseLink(hdl)
        print("✅ 已断开，控制权释放。")

if __name__ == "__main__":
    main()
