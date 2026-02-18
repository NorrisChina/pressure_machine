import ctypes
import time
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
COM_PORT = 7  # 对应 COM8

# 你现场确认：SensorD(3) 是面板旋钮通道
SENSOR_NO = 3

# Position 模式
# 注意：根据提取的 PDF 文本（DoPEFDPoti Modes 列表），Mode=1 实际是 EXT_SPEED_BIPOLAR（速度双极）。
# 位置相关的是：
# - Mode=0 EXT_POSITION（位置模式：旋钮位置 -> 目标位置）
# - Mode=4 EXT_POS_UP_DOWN（位置 Up/Down）
MODE_CANDIDATES = [0, 4]

# MoveCtrl: 0=Pos（与本项目 UI/脚本保持一致）
MOVE_CTRL_POS = 0

# 速度上限（mm/s -> m/s）
MAX_SPEED_MM_S = 10.0

# DxTrigger: 死区（越小越敏感）。先用 0，确认行为后再改 2/3。
DEAD_ZONE = 0

# Scale: 旋钮“digits”到位移的比例。
# 这个值和设备的旋钮分辨率有关：
# - 太小：你感觉“转了但几乎不动”
# - 太大：轻微转动就走很多
SCALE_FACTOR = 1.0

# Front-panel key bit for DigiPoti (PDF v2.24 Page 140)
PE_KEY_DPOTI = 0x0800

# Jog helpers（用于从 LOWER/UPPER LIMIT 脱离；不脱离限位很多命令会被安全逻辑阻止）
MOVE_CTRL_POS = 0
MOVE_HALT = 0
MOVE_UP = 1
MOVE_DOWN = 2
JOG_SPEED_MM_S = 2.0
JOG_SECONDS = 1.5


def decode_state_word(state_value: int) -> str:
    flags: list[str] = []
    if state_value & 0x01:
        flags.append("Bit0")
    if state_value & 0x02:
        flags.append("LOWER_LIMIT")
    if state_value & 0x04:
        flags.append("UPPER_LIMIT")
    if state_value & 0x08:
        flags.append("Bit3")
    if state_value & 0x10:
        flags.append("Bit4")
    return f"0x{state_value:08X} [{', '.join(flags) if flags else 'NONE'}]"


class DoPEDataFull(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Time", ctypes.c_double),
        ("SampleTime", ctypes.c_double),
        ("Position", ctypes.c_double),
        ("Force", ctypes.c_double),
        ("Extension", ctypes.c_double),
        ("SensorD", ctypes.c_double),
        ("Sensor4", ctypes.c_double),
        ("Sensor5", ctypes.c_double),
        ("Sensor6", ctypes.c_double),
        ("Sensor7", ctypes.c_double),
        ("Sensor8", ctypes.c_double),
        ("Sensor9", ctypes.c_double),
        ("Sensor10", ctypes.c_double),
        ("Status", ctypes.c_long),
        ("KeyActive", ctypes.c_uint16),
        ("KeyNew", ctypes.c_uint16),
        ("KeyGone", ctypes.c_uint16),
        ("Reserved", ctypes.c_byte * 64),
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

    dope.DoPESetNotification.argtypes = [ctypes.c_ulong, ctypes.c_ulong, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint]
    dope.DoPESetNotification.restype = ctypes.c_ulong

    dope.DoPESelSetup.argtypes = [
        ctypes.c_ulong,
        ctypes.c_ushort,
        ctypes.c_void_p,
        ctypes.POINTER(ctypes.c_ushort),
        ctypes.POINTER(ctypes.c_ushort),
    ]
    dope.DoPESelSetup.restype = ctypes.c_ulong

    dope.DoPEOn.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_ushort)]
    dope.DoPEOn.restype = ctypes.c_ulong

    dope.DoPECtrlTestValues.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
    dope.DoPECtrlTestValues.restype = ctypes.c_ulong

    dope.DoPETransmitData.argtypes = [ctypes.c_ulong, ctypes.c_ushort, ctypes.POINTER(ctypes.c_ushort)]
    dope.DoPETransmitData.restype = ctypes.c_ulong

    # DoPEFMove(DoPEHdl, Direction, MoveCtrl, Speed, lpusTAN) - 本项目 UI 使用的签名
    dope.DoPEFMove.argtypes = [
        ctypes.c_ulong,
        ctypes.c_ushort,
        ctypes.c_ushort,
        ctypes.c_double,
        ctypes.c_void_p,
    ]
    dope.DoPEFMove.restype = ctypes.c_ulong

    dope.DoPEGetData.argtypes = [ctypes.c_ulong, ctypes.POINTER(DoPEDataFull)]
    dope.DoPEGetData.restype = ctypes.c_ulong

    dope.DoPEGetState.argtypes = [ctypes.c_ulong, ctypes.POINTER(ctypes.c_long)]
    dope.DoPEGetState.restype = ctypes.c_ulong

    # 关键：你这版 DLL 的 Halt 实测需要两个参数 (Handle, Action)
    dope.DoPEHalt.argtypes = [ctypes.c_ulong, ctypes.c_ushort]
    dope.DoPEHalt.restype = ctypes.c_ulong

    dope.DoPECloseLink.argtypes = [ctypes.c_ulong]
    dope.DoPECloseLink.restype = ctypes.c_ulong

    # DoPEFDPoti(Hdl, MoveCtrl, MaxSpeed, SensorNo, DxTrigger, Mode, Scale, *Tan)
    dope.DoPEFDPoti.argtypes = [
        ctypes.c_ulong,
        ctypes.c_ushort,
        ctypes.c_double,
        ctypes.c_ushort,
        ctypes.c_ushort,
        ctypes.c_ushort,
        ctypes.c_double,
        ctypes.c_void_p,
    ]
    dope.DoPEFDPoti.restype = ctypes.c_ulong


def main() -> int:
    if not DLL_PATH.exists():
        print(f"❌ 找不到 DLL: {DLL_PATH}")
        return 1

    dope = ctypes.WinDLL(str(DLL_PATH))
    _define_api(dope)

    hdl = ctypes.c_ulong(0)
    print(f"🔌 连接 COM{COM_PORT + 1} ...")
    err = dope.DoPEOpenLink(COM_PORT, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl))
    if err != 0:
        print(f"❌ 连接失败: 0x{err:04x}")
        return 2

    try:
        print("⚙️ 初始化 Setup ...")
        dope.DoPESetNotification(hdl, 0xFFFFFFFF, None, None, 0)

        tan_first = ctypes.c_ushort(0)
        tan_last = ctypes.c_ushort(0)
        dope.DoPESelSetup(hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
        dope.DoPEOn(hdl, None)
        dope.DoPECtrlTestValues(hdl, 0)
        dope.DoPETransmitData(hdl, 1, None)

        time.sleep(0.2)
        st = ctypes.c_long(0)
        err_state = dope.DoPEGetState(hdl, ctypes.byref(st))
        if err_state == 0:
            print(f"🧾 GetState: {decode_state_word(int(st.value))}")
        else:
            print(f"🧾 GetState 失败: 0x{int(err_state):04x}")

        # 如果在限位，先建议脱离。否则 position/speed 类控制很可能被安全逻辑挡住。
        if err_state == 0:
            if int(st.value) & 0x02:
                cmd = input("检测到 LOWER_LIMIT。输入 'u' 回车：向上 jog 脱离限位；直接回车跳过：").strip().lower()
                if cmd == "u":
                    speed_m_s = JOG_SPEED_MM_S / 1000.0
                    print(f"Jog UP {JOG_SECONDS:.1f}s @ {JOG_SPEED_MM_S} mm/s ...")
                    err_j = dope.DoPEFMove(hdl, MOVE_UP, MOVE_CTRL_POS, speed_m_s, None)
                    print(f"DoPEFMove 返回: 0x{int(err_j):04x}")
                    time.sleep(JOG_SECONDS)
                    dope.DoPEFMove(hdl, MOVE_HALT, MOVE_CTRL_POS, 0.0, None)
            elif int(st.value) & 0x04:
                cmd = input("检测到 UPPER_LIMIT。输入 'd' 回车：向下 jog 脱离限位；直接回车跳过：").strip().lower()
                if cmd == "d":
                    speed_m_s = JOG_SPEED_MM_S / 1000.0
                    print(f"Jog DOWN {JOG_SECONDS:.1f}s @ {JOG_SPEED_MM_S} mm/s ...")
                    err_j = dope.DoPEFMove(hdl, MOVE_DOWN, MOVE_CTRL_POS, speed_m_s, None)
                    print(f"DoPEFMove 返回: 0x{int(err_j):04x}")
                    time.sleep(JOG_SECONDS)
                    dope.DoPEFMove(hdl, MOVE_HALT, MOVE_CTRL_POS, 0.0, None)

        print("\n" + "=" * 60)
        print("🎮 DigiPoti - Position 模式 (EXT_POSITION / EXT_POS_UP_DOWN)")
        print("=" * 60)
        print(f"SensorID: {SENSOR_NO} | Mode candidates: {MODE_CANDIDATES}")
        print(f"Scale: {SCALE_FACTOR} | DeadZone: {DEAD_ZONE} | MaxSpeed: {MAX_SPEED_MM_S} mm/s")
        print("👉 这是位置类模式：旋钮改变目标位置，机器会跟随到目标后停住")
        print("⚠️ 如果你在 LOWER_LIMIT，朝被禁止方向的目标会被拒绝（看起来就像完全不动）。")
        print("⚠️ 若转动旋钮后朝错误方向运动，可把 SCALE_FACTOR 改为负值试试。")
        print("⌨️ 按 Ctrl+C 退出并停止")
        print("-" * 60)

        max_speed_m_s = MAX_SPEED_MM_S / 1000.0
        selected_mode = None
        ret = None
        for mode in MODE_CANDIDATES:
            ret = dope.DoPEFDPoti(
                hdl,
                MOVE_CTRL_POS,
                max_speed_m_s,
                SENSOR_NO,
                DEAD_ZONE,
                mode,
                SCALE_FACTOR,
                None,
            )
            print(f"DoPEFDPoti(Mode={mode}) 返回: 0x{int(ret):04x}")
            if ret == 0:
                selected_mode = mode
                break

        if selected_mode is None:
            return 3

        print(f"✅ FDPoti 已激活：Mode={selected_mode}")

        data = DoPEDataFull()
        dope.DoPEGetData(hdl, ctypes.byref(data))
        start_pos = float(data.Position)
        start_ext = float(data.Extension)

        state_last = 0.0
        state_cache = ctypes.c_long(0)
        state_cache_err = 0

        while True:
            err_d = dope.DoPEGetData(hdl, ctypes.byref(data))
            if err_d != 0:
                time.sleep(0.05)
                continue

            now = time.time()
            if now - state_last >= 1.0:
                state_cache_err = dope.DoPEGetState(hdl, ctypes.byref(state_cache))
                state_last = now

            key_active = int(getattr(data, "KeyActive", 0))
            dpot_active = (key_active & PE_KEY_DPOTI) != 0
            knob = float(data.SensorD)

            state_str = decode_state_word(int(state_cache.value)) if state_cache_err == 0 else f"GetStateErr=0x{int(state_cache_err):04x}"
            print(
                f"\r📍 Pos: {float(data.Position):10.6f} (Δ{(float(data.Position)-start_pos):+.6f}) | "
                f"Ext: {float(data.Extension):10.6f} (Δ{(float(data.Extension)-start_ext):+.6f}) | "
                f"🎛️ Knob(SensorD): {knob:10.4f} | KeyActive: 0x{key_active:04x} ({'DPOTI' if dpot_active else '--'}) | {state_str}",
                end="",
                flush=True,
            )
            time.sleep(0.1)

    except KeyboardInterrupt:
        print("\n\n🛑 正在退出...")
        try:
            dope.DoPEHalt(hdl, 0)
            time.sleep(0.3)
        finally:
            dope.DoPECloseLink(hdl)
        print("✅ 已断开，控制权释放。")
        return 0
    finally:
        # 若中途 return/异常，尽量清理
        try:
            dope.DoPEHalt(hdl, 0)
        except Exception:
            pass
        try:
            dope.DoPECloseLink(hdl)
        except Exception:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
