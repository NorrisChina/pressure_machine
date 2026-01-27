"""
测试控制面板
使用模拟数据验证 UI 功能
"""

import sys
from PyQt5 import QtWidgets, QtCore


class MockDriver:
    """模拟驱动，用于测试控制面板"""
    
    def __init__(self):
        self.is_connected = True
        self._position = 0.0
        self._force = 0.0
        self._time = 0.0
        self._cycles = 0
        
        # 模拟数据定时器
        self._timer = QtCore.QTimer()
        self._timer.timeout.connect(self._update_sim_data)
        self._timer.start(50)  # 50ms 更新
    
    def loaded(self):
        return True
    
    def _update_sim_data(self):
        """模拟数据更新"""
        import random
        self._time += 0.05
        self._position += random.uniform(-0.01, 0.01)
        self._force += random.uniform(-0.5, 0.5)
        
        # 保持在合理范围
        self._position = max(-10, min(10, self._position))
        self._force = max(-100, min(100, self._force))
    
    def get_data(self):
        """返回模拟数据"""
        return {
            'Position': self._position,
            'Load': self._force,
            'Time': self._time,
            'Cycles': self._cycles
        }
    
    def move_to_position(self, target_pos, speed):
        """模拟位置移动"""
        print(f"[模拟] 移动到位置: {target_pos:.2f} mm @ {speed:.1f} mm/s")
        self._position = target_pos
        return True
    
    def move_to_load(self, target_force, speed):
        """模拟力加载"""
        print(f"[模拟] 加载到力: {target_force:.2f} N @ {speed:.1f} N/s")
        self._force = target_force
        return True
    
    def go_to_rest_position(self, speed=5.0):
        """模拟回休息位"""
        print("[模拟] 回休息位")
        self._position = -34.0
        return True
    
    def start_measurement_sequence(self, cycles, interval):
        """模拟测量序列"""
        print(f"[模拟] 开始测量序列: {cycles} 次, 间隔 {interval} 秒")
        self._cycles = 0
    
    def stop_sequence(self):
        """停止序列"""
        print("[模拟] 停止测量序列")
    
    def emergency_stop(self):
        """紧急停止"""
        print("[模拟] 🚨 紧急停止")
        self._position = 0.0
        self._force = 0.0


def main():
    print("="*60)
    print("控制面板测试程序")
    print("使用模拟驱动验证 UI 功能")
    print("="*60)
    
    app = QtWidgets.QApplication(sys.argv)
    
    # 创建模拟驱动
    mock_driver = MockDriver()
    print("✓ 模拟驱动已创建")
    
    # 导入控制面板
    from control_panel import ControlPanelWindow
    
    # 创建窗口
    window = ControlPanelWindow(driver=mock_driver)
    window.show()
    
    print("✓ 控制面板已启动（模拟模式）")
    print("\n测试功能:")
    print("  1. 实时数据会自动更新（随机模拟值）")
    print("  2. 位置/力控制会在终端打印命令")
    print("  3. 测量序列完全可用")
    print("  4. 紧急停止按钮正常工作")
    print("\n" + "="*60)
    
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
