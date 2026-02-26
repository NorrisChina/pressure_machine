"""
DoPE 配置加载器 - 从 EinzelSensor.ini 读取参数
"""

import configparser
from pathlib import Path
from typing import Dict, Optional


class DoPEConfig:
    """DoPE 系统配置"""

    def __init__(self, ini_path: Optional[str] = None):
        self.ini_path = Path(ini_path) if ini_path else Path(__file__).parent.parent / "EinzelSensor.ini"
        self.config = configparser.ConfigParser()
        self.grenzen = {}
        self.soft_limits = {}
        self.forms = {}
        self.ausgabe_biegung = {}
        
        self._load_config()

    def _load_config(self):
        """加载 ini 文件"""
        if self.ini_path.exists():
            self.config.read(self.ini_path, encoding='utf-8')
            self._parse_grenzen()
            self._parse_soft_limits()
            self._parse_forms()
            self._parse_ausgabe_biegung()
        else:
            print(f"Warning: Config file not found at {self.ini_path}")

    def _parse_grenzen(self):
        """解析 [Grenzen] - 传感器测量范围限值"""
        if "Grenzen" in self.config:
            for key, value in self.config["Grenzen"].items():
                try:
                    self.grenzen[key] = float(value)
                except ValueError:
                    self.grenzen[key] = value

    def _parse_soft_limits(self):
        """解析 [SoftLimits] - 软件机械限位"""
        if "SoftLimits" in self.config:
            for key, value in self.config["SoftLimits"].items():
                try:
                    self.soft_limits[key] = float(value)
                except ValueError:
                    self.soft_limits[key] = value

    def _parse_forms(self):
        """解析 [Forms] - 窗口尺寸"""
        if "Forms" in self.config:
            for key, value in self.config["Forms"].items():
                try:
                    self.forms[key] = int(value)
                except ValueError:
                    self.forms[key] = value

    def _parse_ausgabe_biegung(self):
        """解析 [AusgabeBiegung] - 输出弯曲参数"""
        if "AusgabeBiegung" in self.config:
            for key, value in self.config["AusgabeBiegung"].items():
                try:
                    # 处理布尔和数值
                    if value.lower() in ('true', '1', 'yes'):
                        self.ausgabe_biegung[key] = True
                    elif value.lower() in ('false', '0', 'no'):
                        self.ausgabe_biegung[key] = False
                    else:
                        self.ausgabe_biegung[key] = float(value)
                except (ValueError, AttributeError):
                    self.ausgabe_biegung[key] = value

    def get_grenzen(self, key: str, default=None):
        """获取测量范围限值"""
        return self.grenzen.get(key, default)

    def get_soft_limit(self, key: str, default=None):
        """获取软限位"""
        return self.soft_limits.get(key, default)

    def get_form_size(self, key: str = "Width", default=None):
        """获取窗口尺寸"""
        return self.forms.get(key, default)

    def get_biegung_param(self, key: str, default=None):
        """获取弯曲参数"""
        return self.ausgabe_biegung.get(key, default)

    def __repr__(self):
        return (
            f"DoPEConfig(\n"
            f"  Grenzen: {len(self.grenzen)} entries\n"
            f"  SoftLimits: {len(self.soft_limits)} entries\n"
            f"  Forms: {len(self.forms)} entries\n"
            f"  AusgabeBiegung: {len(self.ausgabe_biegung)} entries\n"
            f")"
        )


# 全局配置实例
_dope_config: Optional[DoPEConfig] = None


def get_dope_config(ini_path: Optional[str] = None) -> DoPEConfig:
    """获取或创建全局 DoPE 配置"""
    global _dope_config
    if _dope_config is None:
        _dope_config = DoPEConfig(ini_path)
    return _dope_config
