"""
控制面板主程序
连接 UI 和驱动，实现完整的设备控制功能
"""

from PyQt5 import QtCore, QtWidgets
from ui.control_panel_ui import Ui_ControlPanel
import time


class ControlPanelWindow(QtWidgets.QMainWindow):
    def __init__(self, driver=None, parent=None):
        super().__init__(parent)
        self.ui = Ui_ControlPanel()
        self.ui.setupUi(self)
        
        self.driver = driver
        self._sequence_running = False
        self._sequence_timer = QtCore.QTimer(self)
        self._sequence_timer.timeout.connect(self._sequence_tick)
        self._sequence_count = 0
        
        # 实时数据更新定时器
        self._update_timer = QtCore.QTimer(self)
        self._update_timer.setInterval(100)  # 100ms 更新一次
        self._update_timer.timeout.connect(self._update_realtime_data)
        self._update_timer.start()
        
        # 连接按钮信号
        self.ui.btn_move_to_pos.clicked.connect(self._move_to_position)
        self.ui.btn_move_to_force.clicked.connect(self._move_to_force)
        self.ui.btn_go_zero.clicked.connect(self._go_zero)
        self.ui.btn_go_rest.clicked.connect(self._go_rest)
        self.ui.btn_release_force.clicked.connect(self._release_force)
        self.ui.btn_jog_up.clicked.connect(self._jog_up)
        self.ui.btn_jog_down.clicked.connect(self._jog_down)
        self.ui.btn_jog_stop.clicked.connect(self._jog_stop)
        self.ui.btn_start_sequence.clicked.connect(self._start_sequence)
        self.ui.btn_stop_sequence.clicked.connect(self._stop_sequence)
        self.ui.btn_emergency_stop.clicked.connect(self._emergency_stop)
        
        self._log("控制面板已启动")
        self._check_connection()
    
    def _log(self, message):
        """输出日志"""
        timestamp = time.strftime("%H:%M:%S")
        self.ui.txt_log.appendPlainText(f"[{timestamp}] {message}")
    
    def _check_connection(self):
        """检查设备连接状态"""
        if self.driver is None:
            self.ui.lbl_connection.setText("连接状态: 未连接")
            self.ui.lbl_connection.setStyleSheet("color: red; font-weight: bold; font-size: 14px;")
            self._log("⚠️ 警告: 驱动未初始化")
            return False
        
        try:
            if hasattr(self.driver, 'is_connected'):
                is_connected = self.driver.is_connected
            elif hasattr(self.driver, 'loaded'):
                is_connected = self.driver.loaded()
            else:
                is_connected = True
            
            if is_connected:
                self.ui.lbl_connection.setText("连接状态: 已连接")
                self.ui.lbl_connection.setStyleSheet("color: green; font-weight: bold; font-size: 14px;")
                return True
            else:
                self.ui.lbl_connection.setText("连接状态: 连接断开")
                self.ui.lbl_connection.setStyleSheet("color: orange; font-weight: bold; font-size: 14px;")
                return False
        except Exception as e:
            self._log(f"连接检查失败: {e}")
            return False
    
    def _update_realtime_data(self):
        """更新实时数据显示"""
        if not self.driver:
            return
        
        try:
            # 尝试获取最新数据
            if hasattr(self.driver, 'get_data'):
                # 调用 get_data，会自动使用保存的 handle
                result = self.driver.get_data()
                
                # 处理返回值：可能是 (error_code, data) 或直接是data
                data = None
                error_code = None
                if isinstance(result, tuple) and len(result) >= 2:
                    error_code, data = result[0], result[1]
                    # 0x8001 也认为是有效返回，继续处理数据
                    if error_code not in [0, 0x8001]:
                        return  # 读取失败，静默跳过
                else:
                    data = result
                
                if data:
                    # DoPEData 是 ctypes 结构体，需要转换
                    if hasattr(data, '__class__') and 'DoPEData' in str(data.__class__):
                        # ctypes 结构体：提取字段
                        try:
                            pos = getattr(data, 'Position', 0.0)
                            load = getattr(data, 'Load', 0.0)
                            time_val = getattr(data, 'Time', 0.0)
                            cycles = getattr(data, 'Cycles', 0)
                            
                            self.ui.lbl_position_value.setText(f"{float(pos):.2f}")
                            self.ui.lbl_force_value.setText(f"{float(load):.2f}")
                            self.ui.lbl_time_value.setText(f"{float(time_val):.2f}")
                            self.ui.lbl_cycles_value.setText(f"{int(cycles)}")
                            return
                        except Exception:
                            pass  # 静默失败，继续尝试其他格式
                    
                    # 更新位置
                    if hasattr(data, 'position'):
                        self.ui.lbl_position_value.setText(f"{data.position:.2f}")
                    elif isinstance(data, dict) and 'Position' in data:
                        self.ui.lbl_position_value.setText(f"{data['Position']:.2f}")
                    
                    # 更新力
                    if hasattr(data, 'load'):
                        self.ui.lbl_force_value.setText(f"{data.load:.2f}")
                    elif isinstance(data, dict) and 'Load' in data:
                        self.ui.lbl_force_value.setText(f"{data['Load']:.2f}")
                    
                    # 更新时间
                    if hasattr(data, 'timestamp'):
                        self.ui.lbl_time_value.setText(f"{data.timestamp:.2f}")
                    elif isinstance(data, dict) and 'Time' in data:
                        self.ui.lbl_time_value.setText(f"{data['Time']:.2f}")
                    
                    # 更新循环次数
                    if hasattr(data, 'cycles'):
                        self.ui.lbl_cycles_value.setText(f"{data.cycles}")
                    elif isinstance(data, dict) and 'Cycles' in data:
                        self.ui.lbl_cycles_value.setText(f"{data['Cycles']}")
            
            elif hasattr(self.driver, 'last_data') and self.driver.last_data:
                data = self.driver.last_data
                if hasattr(data, 'position'):
                    self.ui.lbl_position_value.setText(f"{data.position:.2f}")
                if hasattr(data, 'load'):
                    self.ui.lbl_force_value.setText(f"{data.load:.2f}")
                if hasattr(data, 'timestamp'):
                    self.ui.lbl_time_value.setText(f"{data.timestamp:.2f}")
                if hasattr(data, 'cycles'):
                    self.ui.lbl_cycles_value.setText(f"{data.cycles}")
        
        except Exception as e:
            # 静默失败，避免日志过多
            pass
    
    def _move_to_position(self):
        """移动到指定位置"""
        if not self._check_connection():
            self._log("❌ 设备未连接，无法移动")
            return
        
        target_pos = self.ui.spin_target_pos.value()
        speed = self.ui.spin_pos_speed.value()
        
        self._log(f"移动到位置: {target_pos:.2f} mm, 速度: {speed:.1f} mm/s")
        
        try:
            if hasattr(self.driver, 'move_to_position'):
                success = self.driver.move_to_position(target_pos, speed)
                if success:
                    self._log(f"✓ 开始移动到 {target_pos:.2f} mm")
                else:
                    self._log(f"❌ 移动命令失败")
            else:
                self._log("⚠️ 驱动不支持位置控制")
        except Exception as e:
            self._log(f"❌ 移动失败: {e}")
    
    def _move_to_force(self):
        """移动到指定力"""
        if not self._check_connection():
            self._log("❌ 设备未连接，无法加载")
            return
        
        target_force = self.ui.spin_target_force.value()
        speed = self.ui.spin_force_speed.value()
        
        self._log(f"加载到力: {target_force:.2f} N, 速度: {speed:.1f} N/s")
        
        try:
            if hasattr(self.driver, 'move_to_load'):
                success = self.driver.move_to_load(target_force, speed)
                if success:
                    self._log(f"✓ 开始加载到 {target_force:.2f} N")
                else:
                    self._log(f"❌ 加载命令失败")
            else:
                self._log("⚠️ 驱动不支持力控制")
        except Exception as e:
            self._log(f"❌ 加载失败: {e}")
    
    def _go_zero(self):
        """回零位"""
        if not self._check_connection():
            self._log("❌ 设备未连接")
            return
        
        self._log("回零位...")
        self.ui.spin_target_pos.setValue(0.0)
        self._move_to_position()
    
    def _go_rest(self):
        """回休息位"""
        if not self._check_connection():
            self._log("❌ 设备未连接")
            return
        
        self._log("回休息位...")
        
        try:
            if hasattr(self.driver, 'go_to_rest_position'):
                success = self.driver.go_to_rest_position()
                if success:
                    self._log("✓ 移动到休息位")
                else:
                    self._log("❌ 移动失败")
            else:
                # 默认休息位 -34mm
                self.ui.spin_target_pos.setValue(-34.0)
                self._move_to_position()
        except Exception as e:
            self._log(f"❌ 回休息位失败: {e}")

    def _jog_up(self):
        if not self._check_connection():
            self._log("❌ 设备未连接，无法点动")
            return
        speed = self.ui.spin_jog_speed.value()
        self._log(f"点动向上，速度 {speed:.2f} mm/s")
        try:
            if hasattr(self.driver, 'jog_up'):
                self.driver.jog_up(speed)
            elif hasattr(self.driver, 'move_up'):
                self.driver.move_up(speed)
        except Exception as e:
            self._log(f"❌ 点动向上失败: {e}")

    def _jog_down(self):
        if not self._check_connection():
            self._log("❌ 设备未连接，无法点动")
            return
        speed = self.ui.spin_jog_speed.value()
        self._log(f"点动向下，速度 {speed:.2f} mm/s")
        try:
            if hasattr(self.driver, 'jog_down'):
                self.driver.jog_down(speed)
            elif hasattr(self.driver, 'move_down'):
                self.driver.move_down(speed)
        except Exception as e:
            self._log(f"❌ 点动向下失败: {e}")

    def _jog_stop(self):
        if not self._check_connection():
            self._log("❌ 设备未连接，无法停止")
            return
        self._log("点动停止")
        try:
            if hasattr(self.driver, 'jog_stop'):
                self.driver.jog_stop()
            elif hasattr(self.driver, 'stop'):
                self.driver.stop()
        except Exception as e:
            self._log(f"❌ 点动停止失败: {e}")
    
    def _release_force(self):
        """卸载力"""
        if not self._check_connection():
            self._log("❌ 设备未连接")
            return
        
        self._log("卸载力...")
        self.ui.spin_target_force.setValue(0.0)
        self._move_to_force()
    
    def _start_sequence(self):
        """开始测量序列"""
        if not self._check_connection():
            self._log("❌ 设备未连接，无法开始测量")
            return
        
        if self._sequence_running:
            self._log("⚠️ 序列已在运行中")
            return
        
        cycles = self.ui.spin_seq_cycles.value()
        interval = self.ui.spin_seq_interval.value()
        sample_name = self.ui.edit_sample_name.text() or "未命名样品"
        
        self._log("="*50)
        self._log(f"开始测量序列: {sample_name}")
        self._log(f"循环次数: {cycles}, 采样间隔: {interval}s")
        self._log("="*50)
        
        self._sequence_running = True
        self._sequence_count = 0
        self.ui.btn_start_sequence.setEnabled(False)
        self.ui.btn_stop_sequence.setEnabled(True)
        
        # 启动序列定时器
        self._sequence_timer.setInterval(int(interval * 1000))
        self._sequence_timer.start()
        
        # 如果驱动支持，调用测量序列方法
        try:
            if hasattr(self.driver, 'start_measurement_sequence'):
                self.driver.start_measurement_sequence(cycles, interval)
        except Exception as e:
            self._log(f"⚠️ 驱动序列启动失败: {e}")
    
    def _sequence_tick(self):
        """测量序列的一次采样"""
        if not self._sequence_running:
            return
        
        max_cycles = self.ui.spin_seq_cycles.value()
        self._sequence_count += 1
        
        self._log(f"采样 #{self._sequence_count}/{max_cycles}")
        
        # 获取当前数据
        try:
            if hasattr(self.driver, 'get_data'):
                result = self.driver.get_data()
                
                # 处理返回值
                data = None
                error_code = None
                if isinstance(result, tuple) and len(result) >= 2:
                    error_code, data = result[0], result[1]
                    # 0x8001 可能也是有效的返回码，继续处理
                    if error_code not in [0, 0x8001]:
                        self._log(f"  数据读取失败: 错误码 0x{error_code:04X}")
                        return
                else:
                    data = result
                
                if data:
                    # ctypes 结构体
                    if hasattr(data, '__class__') and 'DoPEData' in str(data.__class__):
                        try:
                            pos = float(getattr(data, 'Position', 0.0))
                            load = float(getattr(data, 'Load', 0.0))
                            self._log(f"  位置: {pos:.2f} mm, 力: {load:.2f} N")
                        except Exception as e:
                            self._log(f"  数据提取失败: {e}")
                        return
                    
                    # 普通对象
                    if hasattr(data, 'position') and hasattr(data, 'load'):
                        self._log(f"  位置: {data.position:.2f} mm, 力: {data.load:.2f} N")
                    elif isinstance(data, dict):
                        pos = data.get('Position', 0)
                        load = data.get('Load', 0)
                        self._log(f"  位置: {pos:.2f} mm, 力: {load:.2f} N")
                else:
                    self._log(f"  无数据返回")
        except Exception as e:
            self._log(f"  异常: {e}")
        
        # 检查是否完成
        if self._sequence_count >= max_cycles:
            self._stop_sequence()
            self._log("="*50)
            self._log("✓ 测量序列完成")
            self._log("="*50)
    
    def _stop_sequence(self):
        """停止测量序列"""
        if not self._sequence_running:
            return
        
        self._log("停止测量序列")
        self._sequence_running = False
        self._sequence_timer.stop()
        self.ui.btn_start_sequence.setEnabled(True)
        self.ui.btn_stop_sequence.setEnabled(False)
        
        # 如果驱动支持，调用停止方法
        try:
            if hasattr(self.driver, 'stop_sequence'):
                self.driver.stop_sequence()
        except Exception as e:
            self._log(f"⚠️ 驱动序列停止失败: {e}")
    
    def _emergency_stop(self):
        """紧急停止"""
        self._log("🚨🚨🚨 紧急停止 🚨🚨🚨")
        
        # 停止所有序列
        if self._sequence_running:
            self._stop_sequence()
        
        # 停止驱动
        try:
            if hasattr(self.driver, 'emergency_stop'):
                self.driver.emergency_stop()
                self._log("✓ 驱动紧急停止完成")
            elif hasattr(self.driver, 'stop'):
                self.driver.stop()
                self._log("✓ 驱动停止完成")
            else:
                self._log("⚠️ 驱动不支持紧急停止方法")
        except Exception as e:
            self._log(f"❌ 紧急停止失败: {e}")
        
        # 更新 UI
        self.ui.btn_start_sequence.setEnabled(True)
        self.ui.btn_stop_sequence.setEnabled(False)


if __name__ == '__main__':
    import sys
    
    app = QtWidgets.QApplication(sys.argv)
    
    # 尝试加载真实驱动
    driver = None
    try:
        from drivers.dope_driver import DopeDriver
        driver = DopeDriver()
        if driver.loaded():
            print("✓ 驱动加载成功")
            # 尝试连接
            result = driver.open_link(port=5, baudrate=9600)
            if isinstance(result, tuple) and result[0] == 0:
                print("✓ 设备连接成功")
        else:
            print("⚠️ DLL 未加载，使用模拟模式")
            driver = None
    except Exception as e:
        print(f"⚠️ 驱动加载失败: {e}")
        driver = None
    
    window = ControlPanelWindow(driver=driver)
    window.show()
    
    sys.exit(app.exec_())
