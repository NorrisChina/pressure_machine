import ctypes
import time
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"
COM_PORT = 7  # 对应 COM8

# 你反馈 SenD(3) 变化大：通常意味着面板旋钮数据确实在“SensorD通道”。
# 但 DoPEFDPoti 的 SensorNo 在不同设备/固件映射里可能是 9、3 或 0。
# 这里默认自动依次尝试，成功后会打印最终使用的 SensorID。
# 你现场验证：SensorID=3 能返回 0（可被接受）。
# 文档也提到 EDC 前面板 DigiPoti 常用 SensorNo=9。
SENSOR_CANDIDATES = [3, 9, 0]

# 注意：在本项目其它脚本里（FMove/Pos）速度是按 m/s 传给 DLL，UI 才显示 mm/s。
# 这里保持同样逻辑：以 mm/s 配置，内部转换为 m/s 传入。
MAX_SPEED_MM_S = 10.0
# DxTrigger: 编码器死区(需要变化多少“digits”才激活)。
# PDF v2.24 第116页：EDC frontpanel DigiPoti 推荐 2 或 3。
# 但如果你现场旋钮变化幅度很小，DxTrigger 太大可能会被当成抖动过滤。
# 先用 0 做排查（最敏感），确认能驱动 Position 后再调回 2/3。
DEAD_ZONE = 0
SCALE_FACTOR = 1.0
# PDF v2.24 Page 116: Various modes
# EXT_POSITION = 0
# EXT_RELATIVE = 1 (手轮/旋钮最常用：位置变化量=旋钮变化量*Scale)
# EXT_SPEED_UP_DOWN = 5 (很多设备上更直观：旋钮中间=0，上/下给速度)
# 你反馈“SensorD 变但 Position 不动”，最常见原因是 Absolute 模式(0)会触发保护/不接管。
# 这里强推先只测 Relative(1)。若仍不动，再把 5 加回去排查速度模式。
MODE_CANDIDATES = [1]

MOVE_CTRL_POS = 0

# Jog helpers (same direction semantics used in dope_ui_new.py / dope_move.py)
MOVE_HALT = 0
MOVE_UP = 1
MOVE_DOWN = 2

# 如果检测到限位，允许你用键盘确认做一个很小的 jog 脱离限位。
# 这一步是“诊断动作”：用来确认电机/驱动是否真的允许运动。
JOG_SPEED_MM_S = 2.0
JOG_SECONDS = 1.5

# Front-panel key bit for DigiPoti (PDF v2.24 Page 140)
PE_KEY_DPOTI = 0x0800

# 状态字的具体 bit 定义可能会因设备/固件不同而变化；这里仅做“可能 Drive ON”的快速提示。
STATE_DRIVE_ON_MASK = 0x0001

# “是否真正生效”的快速判定：在提示你旋转旋钮的窗口内
# 如果 SensorD 明显变化但 Position 基本不变，则认为该 (SensorID, Mode) 组合虽启动成功但未驱动运动。
# 验证窗口：用于自动判断“旋钮信号是否驱动了 Pos/Ext”。
# 注意：验证失败不再自动断开；脚本会继续运行，方便你慢慢转旋钮观察。
VERIFY_SECONDS = 8.0
SENSORD_DELTA_MIN = 0.5
POS_DELTA_MIN = 0.005
EXT_DELTA_MIN = 0.005


def decode_state_word(state_value: int) -> str:
    """Best-effort decode for DoPEGetState() (see temp/test_fmove_detailed.py)."""
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
        # NOTE: 这里的字段布局是“工程里验证能读到Pos/Force/SensorD”的布局，
        # 并不严格等同于 PDF 135 页的标准 DoPEData。
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
        # 下面三项：前面板按键（Active/New/Gone），来自 PDF Page 140。
        # 如果你的 DLL 数据记录确实包含它们，这里就能读到并用于确认是否进入 DPoti 模式。
        # 如果读出来一直是 0 或明显乱值，也不影响运动控制，只是作为诊断信息。
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

    # DoPEFMove(DoPEHdl, Direction, MoveCtrl, Speed, lpusTAN)
    # 这里采用本项目 UI 已验证的 5 参数签名。
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

    # 关键：你这版DLL的 Halt 实测需要两个参数 (Handle, Action)
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

    try:
        dope = ctypes.WinDLL(str(DLL_PATH))
    except Exception as e:
        print(f"❌ DLL 加载失败: {e}")
        return 1

    _define_api(dope)

    hdl = ctypes.c_ulong(0)
    print(f"🔌 连接 COM{COM_PORT + 1} ...")
    err = dope.DoPEOpenLink(COM_PORT, 9600, 10, 10, 10, 0x0289, None, ctypes.byref(hdl))
    if err != 0:
        print(f"❌ 连接失败: 0x{err:04x}")
        return 2

    print("⚙️ 初始化 Setup ...")
    dope.DoPESetNotification(hdl, 0xFFFFFFFF, None, None, 0)

    tan_first = ctypes.c_ushort(0)
    tan_last = ctypes.c_ushort(0)
    dope.DoPESelSetup(hdl, 1, None, ctypes.byref(tan_first), ctypes.byref(tan_last))
    dope.DoPEOn(hdl, None)
    dope.DoPECtrlTestValues(hdl, 0)
    dope.DoPETransmitData(hdl, 1, None)

    # 启动后立即读一次状态：帮助判断是否 Drive 真正励磁、以及面板 DPOTI 键是否激活。
    time.sleep(0.2)
    boot_data = DoPEDataFull()
    dope.DoPEGetData(hdl, ctypes.byref(boot_data))
    st = ctypes.c_long(0)
    err_state = dope.DoPEGetState(hdl, ctypes.byref(st))
    key_active0 = int(getattr(boot_data, "KeyActive", 0))
    dpot_active0 = (key_active0 & PE_KEY_DPOTI) != 0
    drive_on_guess = (int(boot_data.Status) & STATE_DRIVE_ON_MASK) != 0
    print(
        f"🧾 启动状态: Status=0x{int(boot_data.Status):08x} | DriveOn(bit0?)={'ON' if drive_on_guess else 'OFF'} | "
        f"KeyActive=0x{key_active0:04x} ({'DPOTI' if dpot_active0 else '--'})"
    )
    print(f"🧾 GetState: 0x{int(err_state):04x} -> {decode_state_word(int(st.value))}")

    # 额外提示：如果处在限位或驱动未励磁，任何控制都会被安全逻辑阻止。
    state_txt = decode_state_word(int(st.value))
    if "LOWER_LIMIT" in state_txt or "UPPER_LIMIT" in state_txt:
        print("⚠️ 检测到限位标志：建议先用面板/常规 jog 让横梁离开限位，再测试旋钮控制。")
        print("   你也可以在这里做一次很小的 jog 脱离限位（可选）。")
    if not drive_on_guess:
        print("⚠️ DriveOn(bit0?) 看起来是 OFF：如果面板 STOP/急停/保护未释放，电机不会动。")

    # 可选：限位时做一次小 jog，帮助确认“电机到底能不能动”。
    # LOWER_LIMIT -> 尝试 UP；UPPER_LIMIT -> 尝试 DOWN
    try:
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
    except EOFError:
        # 某些环境没有 stdin；直接跳过即可。
        pass

    print("\n" + "=" * 50)
    print("🎮 进入 DigiPoti (旋钮控制) 模式")
    print("=" * 50)
    print("👉 现在请准备转动机器面板上的大旋钮")
    print(f"⚠️ 最大速度限制: {MAX_SPEED_MM_S} mm/s")
    print("⌨️ 按 Ctrl+C 退出并停止（脚本不会自动断开）")
    print("-" * 50)

    max_speed_m_s = MAX_SPEED_MM_S / 1000.0

    selected_sensor = None
    selected_mode = None
    ret = None

    def _read_knob_value(data_v: DoPEDataFull, sensor_no: int) -> float:
        if sensor_no == 3:
            return float(data_v.SensorD)
        if 4 <= sensor_no <= 10:
            return float(getattr(data_v, f"Sensor{sensor_no}", 0.0))
        return float(data_v.SensorD)

    # 选择组合：只要 DoPEFDPoti 返回 0，就认为“已进入模式”。
    # 后续用 verify/监控来判断“是否真的驱动了 Pos/Ext”，但不会因为 verify 失败就退出。

    for sensor_no in SENSOR_CANDIDATES:
        for mode in MODE_CANDIDATES:
            print(f"\n🎛️ 尝试启动旋钮控制 (SensorID: {sensor_no}, Mode: {mode}) ...")
            ret = dope.DoPEFDPoti(
                hdl,
                MOVE_CTRL_POS,
                max_speed_m_s,
                sensor_no,
                DEAD_ZONE,
                mode,
                SCALE_FACTOR,
                None,
            )
            print(f"返回: 0x{ret:04x}")
            if ret != 0:
                time.sleep(0.1)
                continue

            selected_sensor = sensor_no
            selected_mode = mode
            break

        if selected_sensor is not None:
            break

    if selected_sensor is None:
        print(f"❌ 启动 DigiPoti 失败（最后一次返回 0x{ret:04x}）")
        print("建议：")
        print("- 确认面板旋钮是否启用/在正确模式")
        print("- 适当调整 DEAD_ZONE / SCALE_FACTOR / MODE_ABS")
        # 启动失败时避免做复杂动作，优先释放 COM 口
        try:
            dope.DoPEHalt(hdl, 0)
        finally:
            dope.DoPECloseLink(hdl)
        return 3

    print(f"\n✅ DigiPoti 已激活！当前使用 SensorID: {selected_sensor}, Mode: {selected_mode}")

    data = DoPEDataFull()
    print("\n(调试) 这里会持续显示 Pos/Ext/Force/Knob/KeyActive")
    print("提示：如果 KeyActive 一直不含 0x0800，试试在面板上按一下 'DigiPoti' 键再转旋钮。")
    print(f"自动验证：脚本会在前 {VERIFY_SECONDS:.0f}s 统计 ΔKnob/ΔPos/ΔExt（不会自动退出）。")
    try:
        dope.DoPEGetData(hdl, ctypes.byref(data))
        start_pos = float(data.Position)
        start_ext = float(data.Extension)
        start_time = time.time()

        knob0 = None
        knob_min = None
        knob_max = None
        pos_min = start_pos
        pos_max = start_pos
        ext_min = start_ext
        ext_max = start_ext
        verify_reported = False

        state_last_print = 0.0
        state_cache = ctypes.c_long(0)
        state_cache_err = 0
        while True:
            err_d = dope.DoPEGetData(hdl, ctypes.byref(data))
            if err_d != 0:
                time.sleep(0.05)
                continue

            now = time.time()
            key_active = getattr(data, "KeyActive", 0)
            dpot_active = (key_active & PE_KEY_DPOTI) != 0
            delta_pos = float(data.Position) - start_pos

            knob = _read_knob_value(data, selected_sensor)
            if knob0 is None:
                knob0 = knob
                knob_min = knob
                knob_max = knob
            else:
                knob_min = min(knob_min, knob)
                knob_max = max(knob_max, knob)
            pos_min = min(pos_min, float(data.Position))
            pos_max = max(pos_max, float(data.Position))
            ext_min = min(ext_min, float(data.Extension))
            ext_max = max(ext_max, float(data.Extension))

            # 每 1 秒读一次 GetState，帮助判断是否限位/状态异常。
            if now - state_last_print >= 1.0:
                state_cache_err = dope.DoPEGetState(hdl, ctypes.byref(state_cache))
                state_last_print = now

            # 在验证窗口结束时输出一次结论（但不中断）。
            if (not verify_reported) and (now - start_time >= VERIFY_SECONDS):
                dk = float(knob_max - knob_min) if knob_min is not None else 0.0
                dp = float(pos_max - pos_min)
                de = float(ext_max - ext_min)
                print("\n")
                print(f"🧪 自动验证结果({VERIFY_SECONDS:.0f}s): ΔKnob={dk:.6f}, ΔPos={dp:.6f}, ΔExt={de:.6f}")
                if dk < SENSORD_DELTA_MIN:
                    print("⚠️ 验证窗口内旋钮信号变化很小/为0：请在看到实时行后立刻连续快速转动旋钮，再观察 ΔKnob。")
                elif (dp < POS_DELTA_MIN) and (de < EXT_DELTA_MIN):
                    print("⚠️ 旋钮在变但 Pos/Ext 不动：常见原因是 Drive 未励磁、面板 STOP、或限位保护。")
                else:
                    print("✅ 检测到 Pos/Ext 发生变化：旋钮控制已生效。")
                verify_reported = True

            state_str = ""
            if state_cache_err == 0:
                state_str = decode_state_word(int(state_cache.value))
            else:
                state_str = f"GetStateErr=0x{int(state_cache_err):04x}"
            print(
                f"\r📍 Pos: {float(data.Position):10.6f} (Δ{delta_pos:+.6f}) | Ext: {float(data.Extension):10.6f} (Δ{(float(data.Extension)-start_ext):+.6f}) | "
                f"💪 Force: {float(data.Force):10.4f} | 🎛️ Knob: {float(knob):10.4f} | KeyActive: 0x{int(key_active):04x} ({'DPOTI' if dpot_active else '--'}) | {state_str}",
                end="",
                flush=True,
            )
            time.sleep(0.1)
    except KeyboardInterrupt:
        print("\n\n🛑 正在退出手控模式...")
        try:
            dope.DoPEHalt(hdl, 0)
            time.sleep(0.5)
        finally:
            dope.DoPECloseLink(hdl)
        print("✅ 已断开，控制权释放。")
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
