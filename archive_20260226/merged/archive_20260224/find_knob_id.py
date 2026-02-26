import ctypes
import time
import sys
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
COM_PORT = 7  # 对应 COM8

# 定义一个足够大的结构体，把多个可能的传感器通道都包含进去
class DoPEDataFull(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Time", ctypes.c_double),
        ("SampleTime", ctypes.c_double),
        ("Position", ctypes.c_double),   # Channel 0
        ("Force", ctypes.c_double),      # Channel 1
        ("Extension", ctypes.c_double),  # Channel 2
        ("SensorD", ctypes.c_double),    # Channel 3 (常见为旋钮/DPoti)
        ("Sensor4", ctypes.c_double),
        ("Sensor5", ctypes.c_double),
        ("Sensor6", ctypes.c_double),
        ("Sensor7", ctypes.c_double),
        ("Sensor8", ctypes.c_double),
        ("Sensor9", ctypes.c_double),
        ("Sensor10", ctypes.c_double),
        ("Reserved", ctypes.c_byte * 100),
    ]


def _define_api(dope: ctypes.WinDLL) -> None:
    dope.DoPEOpenLink.argtypes = [
        ctypes.c_ulong,
        ctypes.c_ulong,
        ctypes.c_ushort,
        ctypes.c_ushort,
        ctypes.c_ushort,
        ctypes.c_ushort,
        ctypes.c_void_p,
        ctypes.POINTER(ctypes.c_ulong),
    ]
    dope.DoPEOpenLink.restype = ctypes.c_ulong

    # 这里按你现有项目里常用写法：后面几个参数允许传 None
    dope.DoPESelSetup.argtypes = [
        ctypes.c_ulong,
        ctypes.c_ushort,
        ctypes.c_void_p,
        ctypes.c_void_p,
        ctypes.c_void_p,
    ]
    dope.DoPESelSetup.restype = ctypes.c_ulong

    dope.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.c_void_p]
    dope.DoPEOn.restype = ctypes.c_ulong

    dope.DoPETransmitData.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.c_void_p]
    dope.DoPETransmitData.restype = ctypes.c_ulong

    dope.DoPEGetData.argtypes = [ctypes.c_ulong, ctypes.POINTER(DoPEDataFull)]
    dope.DoPEGetData.restype = ctypes.c_ulong

    # 关键：你这版DLL实际需要两个参数 (Handle, Action)
    if hasattr(dope, "DoPEHalt"):
        dope.DoPEHalt.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
        dope.DoPEHalt.restype = ctypes.c_ulong

    if hasattr(dope, "DoPECloseLink"):
        dope.DoPECloseLink.argtypes = [ctypes.c_ulong]
        dope.DoPECloseLink.restype = ctypes.c_ulong


def main() -> int:
    if not DLL_PATH.exists():
        print(f"❌ 找不到 DLL: {DLL_PATH}")
        return 1

    try:
        dope = ctypes.WinDLL(str(DLL_PATH))
    except Exception as e:
        print(f"❌ DLL 加载失败: {e}")
        return 1

    _define_api(dope)

    hdl = ctypes.c_ulong(0)

    print("🔌 连接中...")
    err = dope.DoPEOpenLink(COM_PORT, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl))
    if err != 0:
        print(f"❌ 连接失败: 0x{err:04x}")
        return 2

    # 初始化
    dope.DoPESelSetup(hdl, 1, None, None, None)
    dope.DoPEOn(hdl, None)
    dope.DoPETransmitData(hdl, 1, None)

    print("\n==============================================")
    print("🕵️ 旋钮侦探模式")
    print("==============================================")
    print("👉 请现在转动机器面板上的大旋钮！")
    print("👀 观察下面哪一列数值在发生变化？")
    print("(如果只有 SensorD 在变，后续可以优先尝试 SENSOR_NO=9；若 9 报 0x0007，再试 3/0)")
    print("----------------------------------------------")
    print(f"{'SenD(3)':<10} | {'Sen4':<10} | {'Sen5':<10} | {'Sen9':<10} | {'Sen10':<10}")
    print("-" * 60)

    data = DoPEDataFull()
    try:
        while True:
            dope.DoPEGetData(hdl, ctypes.byref(data))
            print(
                f"{data.SensorD:10.3f} | {data.Sensor4:10.3f} | {data.Sensor5:10.3f} | {data.Sensor9:10.3f} | {data.Sensor10:10.3f}",
                end="\r",
                flush=True,
            )
            time.sleep(0.1)
    except KeyboardInterrupt:
        print("\n\n🛑 停止...")
        try:
            if hasattr(dope, "DoPEHalt"):
                dope.DoPEHalt(hdl, 0)
        finally:
            if hasattr(dope, "DoPECloseLink"):
                dope.DoPECloseLink(hdl)
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
