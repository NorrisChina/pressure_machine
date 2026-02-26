"""
真实 DoPE 驱动实现
集成 DLL、配置和数据处理
"""

from typing import Dict, Optional, List, Tuple
from dataclasses import dataclass
from config.dope_config import get_dope_config
from drivers.dope_dll_interface import DoPEDLL, DoPEData, SENSOR_F, SENSOR_4, CTRL_POS, CTRL_LOAD
import time


@dataclass
class DoPEMeasurement:
    """单次测量数据"""
    cycles: int
    timestamp: float
    position: float  # [mm]
    load: float      # [N]
    extension: float # [mm]
    sensor_d: float  # DigiPoti 信号
    ctrl_status: int
    sensors: List[float]  # 传感器阵列


class DoPeDriver:
    """
    真实 DoPE 驱动
    对应 Delphi 的 TDoPE 类
    """

    def __init__(self, dll_path: Optional[str] = None, config_path: Optional[str] = None):
        """
        初始化驱动
        
        Args:
            dll_path: DoPE.dll 或 DoDpx.dll 的路径
            config_path: EinzelSensor.ini 的路径
        """
        self.dll = DoPEDLL(dll_path)
        self.config = get_dope_config(config_path)
        self.handle = None
        self.is_connected = False
        
        # 传感器配置
        self.selected_sensor = SENSOR_F  # 默认 10kN 力传感器
        self.use_sensor_4 = False
        
        # 数据缓冲
        self.last_data: Optional[DoPEMeasurement] = None
        self.data_buffer: List[DoPEMeasurement] = []

    def loaded(self) -> bool:
        """检查 DLL 是否成功加载"""
        return self.dll.loaded

    def open_link(self) -> bool:
        """
        打开 DoPE 连接
        对应 Delphi: TDoPE.OpenLink
        """
        if not self.loaded():
            print("DLL not loaded")
            return False

        try:
            # 打开 DLL
            if not self.dll.open():
                print("Failed to open DLL")
                return False

            self.is_connected = True
            print("DoPE connection opened")
            return True
        except Exception as e:
            print(f"Error opening DoPE link: {e}")
            self.is_connected = False
            return False

    def close(self):
        """
        关闭连接
        对应 Delphi: TDoPE.CloseLink, CloseDll
        """
        if self.dll:
            self.dll.close()
        self.is_connected = False
        print("DoPE connection closed")

    def get_data(self) -> Optional[DoPEMeasurement]:
        """
        获取当前测量数据
        对应 Delphi: TDoPE.HoleDoPEDaten1 / DoPEGetData
        
        Returns:
            DoPEMeasurement 或 None 如果失败
        """
        if not self.is_connected or not self.dll.loaded:
            return None

        try:
            dope_data = DoPEData()
            # 调用 DLL 函数
            result = self.dll.DoPEGetData(self.handle, dope_data)
            
            if result != 0:
                return None

            # 转换为 Python 对象
            meas = DoPEMeasurement(
                cycles=dope_data.Cycles,
                timestamp=dope_data.Time,
                position=dope_data.Position,
                load=dope_data.Load,
                extension=dope_data.Extension,
                sensor_d=dope_data.SensorD,
                ctrl_status=dope_data.CtrlStatus[0],
                sensors=[float(s) for s in dope_data.Sensor]
            )

            self.last_data = meas
            return meas
        except Exception as e:
            print(f"Error getting DoPE data: {e}")
            return None

    def move_to_position(self, target_pos: float, speed: float = 5.0) -> bool:
        """
        移动到指定位置
        对应 Delphi: TDoPE.BewegungZielPositionZyklen -> DoPEPos
        
        Args:
            target_pos: 目标位置 [mm]
            speed: 移动速度 [mm/s]
        
        Returns:
            成功返回 True
        """
        if not self.is_connected:
            print("Not connected")
            return False

        try:
            tan = None
            result = self.dll.DoPEPos(
                self.handle,
                CTRL_POS,
                speed,
                target_pos,
                tan
            )
            return result == 0
        except Exception as e:
            print(f"Error moving to position: {e}")
            return False

    def move_to_load(self, target_load: float, speed: float = 1.0) -> bool:
        """
        移动到指定力
        对应 Delphi: TDoPE.BewegungZielKraftZyklen -> DoPEPosG2
        
        Args:
            target_load: 目标力 [N]
            speed: 力控制速度 [N/s]
        
        Returns:
            成功返回 True
        """
        if not self.is_connected:
            print("Not connected")
            return False

        try:
            tan = None
            result = self.dll.DoPEPos(
                self.handle,
                CTRL_LOAD,
                speed,
                target_load,
                tan
            )
            return result == 0
        except Exception as e:
            print(f"Error moving to load: {e}")
            return False

    def go_to_rest_position(self, speed: float = 5.0) -> bool:
        """
        返回休息位置
        对应 Delphi: TDoPE.GehePosRuhe
        """
        rest_pos = self.config.get_soft_limit("LimitX4Min", -34.0)
        return self.move_to_position(rest_pos, speed)

    def set_sensor(self, sensor_id: int):
        """
        选择传感器
        对应 Delphi: TDoPE.Boo_KraftSensor4
        
        Args:
            sensor_id: SENSOR_F (1) 或 SENSOR_4 (4)
        """
        self.selected_sensor = sensor_id
        self.use_sensor_4 = (sensor_id == SENSOR_4)
        print(f"Selected sensor: {sensor_id}")

    def set_time(self, time_val: float = 0.0):
        """
        设置时间计数器
        对应 Delphi: TDoPE.SetzeZeit
        """
        if self.dll.loaded:
            try:
                self.dll.DoPESetTime(self.handle, time_val)
            except Exception as e:
                print(f"Error setting time: {e}")

    def record_data(self):
        """
        记录当前数据到缓冲
        对应 Delphi: TZirkularPuffer.SchreibeDaten
        """
        data = self.get_data()
        if data:
            self.data_buffer.append(data)

    def get_buffer(self) -> List[DoPEMeasurement]:
        """获取数据缓冲"""
        return self.data_buffer.copy()

    def clear_buffer(self):
        """清空数据缓冲"""
        self.data_buffer.clear()

    def get_sensor_limits(self, sensor_id: int = None) -> Dict[str, float]:
        """获取传感器的测量范围限值"""
        if sensor_id is None:
            sensor_id = self.selected_sensor

        # 从配置读取
        limits = {
            f"min_{sensor_id}": self.config.get_grenzen(f"MinGrenzen{sensor_id}", 0),
            f"max_{sensor_id}": self.config.get_grenzen(f"MaxGrenzen{sensor_id}", 1000),
        }
        return limits

    def __repr__(self):
        return (
            f"DoPeDriver(\n"
            f"  DLL loaded: {self.loaded()}\n"
            f"  Connected: {self.is_connected}\n"
            f"  Sensor: {self.selected_sensor}\n"
            f"  Buffer: {len(self.data_buffer)} samples\n"
            f")"
        )
