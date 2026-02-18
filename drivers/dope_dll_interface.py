"""
DoPE DLL 接口定义 - 基于 Programm_DOPE 文档
DoPEAPIVERSION = 0x0289 (2.89)

主要 DLL 函数和数据结构定义
"""

from ctypes import (
    c_uint8, c_uint16, c_uint32, c_uint64, c_double, c_char_p, c_void_p,
    POINTER, Structure, WINFUNCTYPE, CDLL
)
from typing import Optional


# ============================================================================
# DoPE 数据结构定义 (来自 Houns02.pas, DoPEData 结构)
# ============================================================================

class DoPEData(Structure):
    """
    DoPE 主数据结构
    对应 Delphi 中的 DoPEData record
    版本 2.73+ 含有 SENSOR_DP (DigiPoti)
    """
    _fields_ = [
        ("Cycles", c_uint32),           # 循环计数
        ("Time", c_double),             # 时间 [s]
        ("Position", c_double),         # 位置 [mm]
        ("Load", c_double),             # 力 [N]
        ("Extension", c_double),        # 延伸 [mm]
        ("SensorD", c_double),          # SENSOR_D (DigiPoti 信号)
        ("CtrlStatus", c_uint16 * 4),   # 控制状态字 (多个 WORD)
        ("Sensor", c_double * 8),       # 传感器数组 (Sensor 0..7)
    ]


class DoPEOutChaDef(Structure):
    """输出通道定义"""
    _fields_ = [
        ("ChNum", c_uint16),            # 通道号
        ("Type", c_uint16),             # 类型
    ]


class DoPEMachineDef(Structure):
    """机器定义"""
    _fields_ = [
        ("Version", c_uint32),          # 版本
        ("SerialNum", c_uint32),        # 序列号
    ]


class DoPEIOSignals(Structure):
    """I/O 信号"""
    _fields_ = [
        ("inputs", c_uint16),           # 输入数
        ("outputs", c_uint16),          # 输出数
    ]


class DoPESetup(Structure):
    """DoPE 设置"""
    _fields_ = [
        ("SetupNum", c_uint16),         # 设置编号
        ("Description", c_char_p),      # 描述
    ]


# ============================================================================
# 传感器定义 (来自文档 "Ermittlung der Sensor-Eigenschaften")
# ============================================================================

# 传感器编号定义
SENSOR_S = 0   # 位置传感器 (X7)
SENSOR_F = 1   # 10kN 力传感器 (X14)
SENSOR_D = 3   # DigiPoti (X63)
SENSOR_4 = 4   # 力传感器 100N/1kN (X21B)
SENSOR_DP = 3  # DigiPoti (版本 2.73+ 别名)

# 控制命令
CTRL_POS = 0    # 位置控制
CTRL_LOAD = 1   # 力控制
CTRL_EXTENSION = 2  # 延伸控制


# ============================================================================
# DoPE 事件掩码
# ============================================================================

DoPEEVT_DATAVAIL = 0x01      # 数据可用
DoPEEVT_ERROR = 0x02         # 错误
DoPEEVT_TIMEOUT = 0x04       # 超时


# ============================================================================
# 回调函数类型
# ============================================================================

DoPECallBackFunc = WINFUNCTYPE(
    c_uint32,           # 返回值
    c_void_p,           # hWnd
    c_uint32,           # uMsg
    c_uint32,           # DoPEHdl
    c_uint32            # Event
)


# ============================================================================
# DoPE DLL 函数签名
# ============================================================================

class DoPEDLL:
    """
    DoPE DLL 函数包装
    主要函数来自文档 "DoPE-Funktionen" 部分
    """

    def __init__(self, dll_path: Optional[str] = None):
        """
        加载 DoPE DLL
        
        Args:
            dll_path: DLL 文件路径（如 DoPE.dll 或 DoDpx.dll）
                     如未指定，尝试从系统路径加载
        """
        try:
            if dll_path:
                self.dll = CDLL(dll_path)
            else:
                # 尝试系统路径中的标准名称
                try:
                    self.dll = CDLL("DoPE.dll")
                except OSError:
                    self.dll = CDLL("DoDpx.dll")
            
            self._setup_functions()
            self.loaded = True
        except OSError as e:
            print(f"Warning: Cannot load DoPE DLL: {e}")
            self.dll = None
            self.loaded = False

    def _setup_functions(self):
        """设置函数原型"""
        if not self.dll:
            return

        # 初始化/清理
        self.DoPEOpenDll = self.dll.DoPEOpenDll
        self.DoPEOpenDll.argtypes = [c_char_p]
        self.DoPEOpenDll.restype = c_void_p

        self.DoPECloseDll = self.dll.DoPECloseDll
        self.DoPECloseDll.argtypes = []
        self.DoPECloseDll.restype = None

        # 连接管理
        self.DoPEOpenLink = self.dll.DoPEOpenLink
        self.DoPEOpenLink.argtypes = [c_void_p]
        self.DoPEOpenLink.restype = c_uint32

        self.DoPECloseLink = self.dll.DoPECloseLink
        self.DoPECloseLink.argtypes = [c_void_p]
        self.DoPECloseLink.restype = c_uint32

        # 数据获取
        self.DoPEGetData = self.dll.DoPEGetData
        self.DoPEGetData.argtypes = [c_void_p, POINTER(DoPEData)]
        self.DoPEGetData.restype = c_uint32

        # 设置参数
        self.DoPESetNotification = self.dll.DoPESetNotification
        self.DoPESetNotification.argtypes = [
            c_void_p,              # DHandle
            c_uint32,              # EvMask
            DoPECallBackFunc,      # CallBack 或 None
            c_void_p,              # WndHandle
            c_uint32               # Message
        ]
        self.DoPESetNotification.restype = c_uint32

        # 位置控制
        self.DoPEPos = self.dll.DoPEPos
        self.DoPEPos.argtypes = [
            c_void_p,              # DHandle
            c_uint16,              # Control (CTRL_POS/CTRL_LOAD)
            c_double,              # Speed
            c_double,              # Target
            POINTER(c_uint16)      # lpusTAN (optional)
        ]
        self.DoPEPos.restype = c_uint32

        # 连续移动 (速度控制)
        self.DoPEFMove = getattr(self.dll, "DoPEFMove", None)
        if self.DoPEFMove is not None:
            self.DoPEFMove.argtypes = [
                c_void_p,          # DHandle
                c_uint16,          # Direction (MOVE_UP/MOVE_DOWN/MOVE_HALT)
                c_uint16,          # MoveCtrl (CTRL_POS/CTRL_LOAD/CTRL_EXTENSION)
                c_double,          # Speed
                POINTER(c_uint16)  # lpusTAN (optional)
            ]
            self.DoPEFMove.restype = c_uint32

        # 设置时间
        self.DoPESetTime = self.dll.DoPESetTime
        self.DoPESetTime.argtypes = [c_void_p, c_double]
        self.DoPESetTime.restype = c_uint32

    def open(self, config_path: Optional[str] = None) -> bool:
        """打开 DLL 和连接"""
        if not self.loaded:
            return False
        try:
            handle = self.DoPEOpenDll(config_path.encode() if config_path else None)
            return handle is not None
        except Exception as e:
            print(f"Error opening DoPE: {e}")
            return False

    def close(self):
        """关闭 DLL"""
        if self.loaded:
            try:
                self.DoPECloseDll()
            except Exception as e:
                print(f"Error closing DoPE: {e}")

    def __repr__(self):
        return f"DoPEDLL(loaded={self.loaded})"
