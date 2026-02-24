from PyQt5 import QtCore, QtWidgets
import collections
try:
    import pyqtgraph as pg
except Exception:
    pg = None
from ui.main_window_ui import Ui_MainWindow
from ui.translations import get_text
from drivers.programm_dope_translated import TSteuerungAblauf


class MainWindow(QtWidgets.QMainWindow):
    def __init__(self, driver=None, parent=None):
        super().__init__(parent)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)

        # Allow Ui to adjust size if generated UI set a default
        try:
            self.resize(800, 600)
        except Exception:
            pass

        self.driver = driver
        self._using_stub = False
        self.controller = None
        self.current_language = "de"  # Default German
        self.customize_mode = False  # Track customize mode state
        self.current_device = "Hounsfield"  # Default device

        # Timer for periodic polling
        self._timer = QtCore.QTimer(self)
        self._timer.setInterval(500)
        self._timer.timeout.connect(self._poll)
        self._last_data_ts = 0

        # Wire buttons (guard for absent widgets)
        if hasattr(self.ui, 'btn_init_keithley'):
            self.ui.btn_init_keithley.clicked.connect(self.start)
        if hasattr(self.ui, 'btn_init_hounsfield'):
            self.ui.btn_init_hounsfield.clicked.connect(self.start)
        if hasattr(self.ui, 'btn_meas_start'):
            self.ui.btn_meas_start.clicked.connect(self._start_poll)
        if hasattr(self.ui, 'btn_meas_halt'):
            self.ui.btn_meas_halt.clicked.connect(self._emergency_stop)
        if hasattr(self.ui, 'btn_customize'):
            self.ui.btn_customize.clicked.connect(self._toggle_customize)
        if hasattr(self.ui, 'btn_kei_start'):
            self.ui.btn_kei_start.clicked.connect(self._start_keithley_measurement)
        if hasattr(self.ui, 'btn_kei_stop'):
            self.ui.btn_kei_stop.clicked.connect(self._emergency_stop)
        if hasattr(self.ui, 'btn_kei_bildung'):
            self.ui.btn_kei_bildung.clicked.connect(self._copy_measurement_to_clipboard)
        if hasattr(self.ui, 'btn_move_on'):
            self.ui.btn_move_on.clicked.connect(lambda: self.log("Bewegung Ein (stub)"))
        if hasattr(self.ui, 'btn_move_stop'):
            self.ui.btn_move_stop.clicked.connect(self._emergency_stop)
        # Control panel button
        if hasattr(self.ui, 'btn_open_control_panel'):
            self.ui.btn_open_control_panel.clicked.connect(self._open_control_panel)
        # sequence controls (if present from earlier layout)
        if hasattr(self.ui, 'btn_seq_start'):
            self.ui.btn_seq_start.clicked.connect(self._start_sequence_ui)
        if hasattr(self.ui, 'btn_seq_stop'):
            self.ui.btn_seq_stop.clicked.connect(self._stop_sequence_ui)

        # initial UI state for legacy start/stop buttons
        if hasattr(self.ui, 'btn_stop'):
            self.ui.btn_stop.setEnabled(False)

        # Disable plot to avoid blocking debug log view
        self._plot_buf = None
        self._plot_curve = None
        self.plot_widget = None
        self.plot_curve = None

        # Device switcher
        if hasattr(self.ui, 'combo_device'):
            self.ui.combo_device.currentIndexChanged.connect(self._change_device)

        # Language switcher
        if hasattr(self.ui, 'combo_language'):
            self.ui.combo_language.currentIndexChanged.connect(self._change_language)
            self._update_ui_language()

        # helper to update state label from controller events
        def _update_state_label(text: str):
            try:
                if hasattr(self.ui, 'lbl_state'):
                    self.ui.lbl_state.setText(f"State: {text}")
            except Exception:
                pass

        self._update_state_label = _update_state_label

    def _change_device(self, index):
        """Change device mode (Hounsfield or Keithley)"""
        devices = ["Hounsfield", "Keithley"]
        self.current_device = devices[index] if index < len(devices) else "Hounsfield"
        self._update_ui_for_device()
        self.log(f"Device changed to: {self.current_device}")

    def _update_ui_for_device(self):
        """Update UI visibility based on selected device"""
        is_keithley = self.current_device == "Keithley"
        is_hounsfield = self.current_device == "Hounsfield"
        
        # Update init panel
        if hasattr(self.ui, 'btn_init_keithley'):
            self.ui.btn_init_keithley.setVisible(is_keithley)
        if hasattr(self.ui, 'btn_init_hounsfield'):
            self.ui.btn_init_hounsfield.setVisible(is_hounsfield)
        if hasattr(self.ui, 'lbl_sensor_val'):
            # Hide sensor label in Keithley mode per request
            self.ui.lbl_sensor_val.setVisible(is_hounsfield)
        
        # Update measurement panels
        if hasattr(self.ui, 'grp_measure'):
            self.ui.grp_measure.setVisible(is_hounsfield)
        if hasattr(self.ui, 'grp_keithley'):
            self.ui.grp_keithley.setVisible(is_keithley)
        
        # Hide motion controls for Keithley
        if hasattr(self.ui, 'btn_move_on'):
            self.ui.btn_move_on.setVisible(is_hounsfield)
        if hasattr(self.ui, 'btn_move_stop'):
            self.ui.btn_move_stop.setVisible(is_hounsfield)
        if hasattr(self.ui, 'grp_move_mode'):
            self.ui.grp_move_mode.setVisible(is_hounsfield)
        if hasattr(self.ui, 'lbl_max_zug'):
            self.ui.lbl_max_zug.setVisible(is_hounsfield)
        if hasattr(self.ui, 'spin_max_zug'):
            self.ui.spin_max_zug.setVisible(is_hounsfield)
        if hasattr(self.ui, 'lbl_max_kraft'):
            self.ui.lbl_max_kraft.setVisible(is_hounsfield)
        if hasattr(self.ui, 'spin_max_kraft'):
            self.ui.spin_max_kraft.setVisible(is_hounsfield)
        if hasattr(self.ui, 'chk_only_10kn'):
            self.ui.chk_only_10kn.setVisible(is_hounsfield)

    def _change_language(self, index):
        """Change UI language based on combo box selection"""
        lang_map = {0: "de", 1: "en", 2: "zh"}
        lang_names = {0: "Deutsch", 1: "English", 2: "中文"}
        self.current_language = lang_map.get(index, "de")
        self._update_ui_language()
        self.log(f"Language changed to: {lang_names.get(index, 'Deutsch')}")

    def _update_ui_language(self):
        """Update all UI text based on current language"""
        lang = self.current_language
        
        # Window title
        self.setWindowTitle(get_text("window_title", lang))
        
        # Language selector
        if hasattr(self.ui, 'lbl_language'):
            self.ui.lbl_language.setText(get_text("language", lang))
        if hasattr(self.ui, 'lbl_device'):
            self.ui.lbl_device.setText(get_text("device", lang))
        
        # Initialization group
        if hasattr(self.ui, 'grp_init'):
            self.ui.grp_init.setTitle(get_text("grp_init", lang))
        if hasattr(self.ui, 'btn_init_keithley'):
            self.ui.btn_init_keithley.setText(get_text("btn_init_keithley", lang))
        if hasattr(self.ui, 'btn_init_hounsfield'):
            self.ui.btn_init_hounsfield.setText(get_text("btn_init_hounsfield", lang))
        if hasattr(self.ui, 'lbl_sensor_val'):
            self.ui.lbl_sensor_val.setText(get_text("lbl_sensor_val", lang))
        if hasattr(self.ui, 'lbl_conn_status'):
            self.ui.lbl_conn_status.setText(get_text("lbl_conn_status_disconnected", lang))
        if hasattr(self.ui, 'lbl_kraftdose'):
            self.ui.lbl_kraftdose.setText(get_text("lbl_kraftdose", lang))
        if hasattr(self.ui, 'btn_move_on'):
            self.ui.btn_move_on.setText(get_text("btn_move_on", lang))
        if hasattr(self.ui, 'lbl_max_zug'):
            self.ui.lbl_max_zug.setText(get_text("lbl_max_zug", lang))
        if hasattr(self.ui, 'lbl_max_kraft'):
            self.ui.lbl_max_kraft.setText(get_text("lbl_max_kraft", lang))
        if hasattr(self.ui, 'chk_only_10kn'):
            self.ui.chk_only_10kn.setText(get_text("chk_only_10kn", lang))
        if hasattr(self.ui, 'btn_move_stop'):
            self.ui.btn_move_stop.setText(get_text("btn_move_stop", lang))
        if hasattr(self.ui, 'grp_move_mode'):
            self.ui.grp_move_mode.setTitle(get_text("grp_move_mode", lang))
        if hasattr(self.ui, 'rad_move_aus'):
            self.ui.rad_move_aus.setText(get_text("rad_move_aus", lang))
        if hasattr(self.ui, 'rad_move_speed'):
            self.ui.rad_move_speed.setText(get_text("rad_move_speed", lang))
        if hasattr(self.ui, 'rad_move_position'):
            self.ui.rad_move_position.setText(get_text("rad_move_position", lang))
        
        # Measurement group
        if hasattr(self.ui, 'grp_measure'):
            self.ui.grp_measure.setTitle(get_text("grp_measure", lang))
        if hasattr(self.ui, 'label_sample_name'):
            self.ui.label_sample_name.setText(get_text("label_sample_name", lang))
        if hasattr(self.ui, 'btn_meas_start'):
            self.ui.btn_meas_start.setText(get_text("btn_meas_start", lang))
        if hasattr(self.ui, 'btn_customize'):
            self.ui.btn_customize.setText(get_text("btn_customize", lang))
        if hasattr(self.ui, 'label_startkraft'):
            self.ui.label_startkraft.setText(get_text("label_startkraft", lang))
        if hasattr(self.ui, 'label_df'):
            self.ui.label_df.setText(get_text("label_df", lang))
        if hasattr(self.ui, 'label_kraftstufen'):
            self.ui.label_kraftstufen.setText(get_text("label_kraftstufen", lang))
        if hasattr(self.ui, 'label_nennkraft'):
            self.ui.label_nennkraft.setText(get_text("label_nennkraft", lang))
        if hasattr(self.ui, 'label_zyklen'):
            self.ui.label_zyklen.setText(get_text("label_zyklen", lang))
        if hasattr(self.ui, 'label_time'):
            self.ui.label_time.setText(get_text("label_time", lang))
        if hasattr(self.ui, 'label_pos'):
            self.ui.label_pos.setText(get_text("label_pos", lang))
        if hasattr(self.ui, 'label_kraft'):
            self.ui.label_kraft.setText(get_text("label_kraft", lang))
        if hasattr(self.ui, 'label_ub'):
            self.ui.label_ub.setText(get_text("label_ub", lang))
        if hasattr(self.ui, 'chk_startkraft'):
            self.ui.chk_startkraft.setText(get_text("chk_startkraft", lang))
        if hasattr(self.ui, 'label_df'):
            self.ui.label_df.setText(get_text("label_df", lang))
        if hasattr(self.ui, 'label_kraftstufen'):
            self.ui.label_kraftstufen.setText(get_text("label_kraftstufen", lang))
        if hasattr(self.ui, 'label_nennkraft'):
            self.ui.label_nennkraft.setText(get_text("label_nennkraft", lang))
        if hasattr(self.ui, 'label_zyklen'):
            self.ui.label_zyklen.setText(get_text("label_zyklen", lang))
        if hasattr(self.ui, 'lbl_state'):
            self.ui.lbl_state.setText(get_text("lbl_state", lang))
        
        # Keithley-specific labels
        if hasattr(self.ui, 'lbl_kei_erstellung_messung'):
            self.ui.lbl_kei_erstellung_messung.setText(get_text("lbl_kei_erstellung_messung", lang))
        if hasattr(self.ui, 'lbl_kei_standeort'):
            self.ui.lbl_kei_standeort.setText(get_text("lbl_kei_standeort", lang))
        if hasattr(self.ui, 'lbl_kei_standartl'):
            self.ui.lbl_kei_standartl.setText(get_text("lbl_kei_standartl", lang))
        if hasattr(self.ui, 'btn_kei_standeort'):
            self.ui.btn_kei_standeort.setText(get_text("lbl_kei_standartl", lang))
        if hasattr(self.ui, 'lbl_kei_position'):
            self.ui.lbl_kei_position.setText(get_text("lbl_kei_position", lang))
        if hasattr(self.ui, 'lbl_kei_zyklen'):
            self.ui.lbl_kei_zyklen.setText(get_text("lbl_kei_zyklen", lang))
        if hasattr(self.ui, 'btn_kei_start'):
            self.ui.btn_kei_start.setText(get_text("btn_kei_start", lang))
        if hasattr(self.ui, 'lbl_kei_probenerme'):
            self.ui.lbl_kei_probenerme.setText(get_text("lbl_kei_probenerme", lang))
        if hasattr(self.ui, 'chk_kei_bildung'):
            self.ui.chk_kei_bildung.setText(get_text("chk_kei_bildung", lang))
        if hasattr(self.ui, 'lbl_kei_del'):
            self.ui.lbl_kei_del.setText(get_text("lbl_kei_del", lang))
        if hasattr(self.ui, 'chk_kei_d_delay'):
            self.ui.chk_kei_d_delay.setText(get_text("chk_kei_d_delay", lang))
        if hasattr(self.ui, 'lbl_kei_channels'):
            self.ui.lbl_kei_channels.setText(get_text("lbl_kei_channels", lang))
        if hasattr(self.ui, 'chk_kei_scanner'):
            self.ui.chk_kei_scanner.setText(get_text("chk_kei_scanner", lang))

    def update_sensor_display(self, sensor_type="10000N"):
        """
        Update sensor display based on connected sensor type
        sensor_type: "100N", "1000N", or "10000N"
        """
        key_map = {
            "100N": "lbl_sensor_val_100n",
            "1000N": "lbl_sensor_val_1000n",
            "10000N": "lbl_sensor_val_10000n"
        }
        
        key = key_map.get(sensor_type, "lbl_sensor_val_10000n")
        if hasattr(self.ui, 'lbl_sensor_val'):
            self.ui.lbl_sensor_val.setText(get_text(key, self.current_language))

    def _log_sequence_event(self, ev, data):
        try:
            if ev == 5:
                # sequence finished
                self.log(f"Sequence finished: {data}")
            elif ev == 6:
                self.log(f"Sequence error: {data}")
            else:
                # ignore other event types here
                pass
        except Exception:
            pass

    def log(self, text: str):
        self.ui.log.appendPlainText(text)

    def _update_progress(self, connected: bool):
        try:
            if hasattr(self.ui, 'progress_conn'):
                self.ui.progress_conn.setValue(100 if connected else 0)
            if hasattr(self.ui, 'lbl_conn_status'):
                status_key = "lbl_conn_status_connected" if connected else "lbl_conn_status_disconnected"
                self.ui.lbl_conn_status.setText(get_text(status_key, self.current_language))
        except Exception:
            pass

    def _ensure_driver(self):
        # If no driver passed in, try to create the real driver and fall back
        # to our stub if the real one isn't available.
        if self.driver is not None:
            return

        try:
            from drivers.dope_driver import DopeDriver

            d = DopeDriver()
            if not d.loaded():
                raise RuntimeError("DOPE DLL not loaded")

            self.driver = d
            self._using_stub = False
            self.log(get_text("log_using_real_driver", self.current_language))
        except Exception as e:
            # 不再自动切换到模拟驱动，直接报错
            self.log(f"❌ {get_text('log_dll_load_error', self.current_language)}: {e}")
            self.log(get_text("log_dll_check", self.current_language))
            self.driver = None
            self._using_stub = False

    def start(self):
        self.log(get_text("log_start_pressed", self.current_language))
        self._ensure_driver()

        if not self.driver:
            self.log(get_text("log_no_driver", self.current_language))
            self._update_progress(False)
            return

        # Attempt to open the link if driver supports it
        connected = False
        open_fn = getattr(self.driver, "open_link", None)
        if callable(open_fn):
            try:
                # Real driver needs port and baudrate parameters
                if not self._using_stub:
                    # 自动尝试系统中的 COM 口 + 常见波特率，以防设备配置不同
                    baudrates = [9600, 19200, 115200]
                    apivers = [0x0289, 0x028A, 0x0288]  # DoPE DLL 版本尝试
                    ports_to_try = [5, 6, 3, 4]  # 按你的系统配置: COM5, COM6, 然后备用 COM3/4

                    result = None
                    port = None
                    baudrate_used = None

                    for b in baudrates:
                        for api in apivers:
                            for p in ports_to_try:
                                try:
                                    self.log(get_text("log_trying_com", self.current_language).format(p, b) + f" (apiver=0x{api:04X})")
                                    result = open_fn(port=p, baudrate=b, apiver=api)

                                    if isinstance(result, tuple) and len(result) >= 2:
                                        error_code = result[0]
                                        if error_code == 0:
                                            port = p
                                            baudrate_used = b
                                            self.log(f"✓ {get_text('log_com_ok', self.current_language).format(p)} (baud {b}, apiver=0x{api:04X})")
                                            break
                                        elif error_code == 0x800B:
                                            self.log(f"  {get_text('log_com_no_response', self.current_language).format(p)}")
                                        elif error_code == 0x8006:
                                            self.log(f"  {get_text('log_com_not_exist', self.current_language).format(p)}")
                                        elif error_code == 0x800A:
                                            self.log(f"  COM{p}: 校验和错误 / checksum error (0x800A) (apiver=0x{api:04X})")
                                        else:
                                            self.log(f"  {get_text('log_com_error', self.current_language).format(p, error_code)} (apiver=0x{api:04X})")
                                except Exception as e:
                                    self.log(f"  COM{p}: Exception {e}")
                            if port is not None:
                                break
                        if port is not None:
                            break

                    if port is None:
                        self.log(f"❌ {get_text('log_all_com_failed', self.current_language)}")
                    else:
                        self.log(f"Verbindung geöffnet auf COM{port} @ {baudrate_used} Baud")
                else:
                    # Stub driver doesn't need parameters
                    result = open_fn()
                
                self.log(f"open_link -> {result}")
                
                # Check if using real driver with DLL
                if not self._using_stub:
                    # Real driver returns (error_code, handle)
                    if isinstance(result, tuple) and len(result) >= 2:
                        error_code, handle = result[0], result[1]
                        
                        # DoPE error codes (from DLL documentation)
                        dope_errors = {
                            0: "成功",
                            0x8001: "DLL 未初始化",
                            0x8002: "无效句柄",
                            0x8003: "参数错误",
                            0x8004: "内存分配失败",
                            0x8005: "通信超时",
                            0x8006: "串口打开失败",
                            0x8007: "串口已被占用",
                            0x8008: "数据接收错误",
                            0x8009: "数据发送错误",
                            0x800A: "校验和错误",
                            0x800B: "设备无响应 (无硬件连接)",
                            0x800C: "命令执行失败",
                            0x800D: "版本不匹配",
                        }
                        
                        error_msg = dope_errors.get(error_code, f"未知错误 0x{error_code:04X}")
                        
                        if error_code == 0 and handle:
                            connected = True
                            self.log(f"✅ {get_text('log_hardware_connected', self.current_language)}")
                        else:
                            self.log(f"❌ {get_text('log_hardware_failed', self.current_language)}: {error_msg} (Error: {error_code} / 0x{error_code:04X})")
                            
                            if error_code == 0x800B:
                                self.log(f"→ {get_text('error_0x800B', self.current_language)}")
                                self.log(f"  {get_text('log_check_device', self.current_language)}")
                                self.log(f"  {get_text('log_wrong_com', self.current_language).format(port)}")
                            elif error_code == 0x8006:
                                self.log(f"→ {get_text('error_0x8006', self.current_language)}: COM{port}")
                            elif error_code == 0x8007:
                                self.log(f"→ {get_text('error_0x8007', self.current_language)}: COM{port}")
                    else:
                        self.log(f"⚠️ DLL 返回格式异常: {result}")
                else:
                    # Stub driver always returns True
                    connected = result
                    self.log("⚠️ 演示模式 (Demo mode) - 无真实硬件连接")
                    
            except Exception as e:
                self.log(f"❌ open_link() 错误: {e}")
                connected = False
        else:
            self.log("⚠️ Driver 不支持 open_link()")

        # Update connection status based on actual result
        self._update_progress(connected)
        
        if not connected and not self._using_stub:
            self.log(get_text("log_no_hardware", self.current_language))
            return

        # Start polling
        self._timer.start()
        # create controller and wire events
        try:
            if self.controller is None:
                self.controller = TSteuerungAblauf(driver=self.driver)
                try:
                    # register event handler to update UI state
                    self.controller.on_event(lambda ev, d: QtCore.QTimer.singleShot(0, lambda: self._update_state_label(self.controller.state)))
                    # also register for sequence events to log them
                    self.controller.on_event(lambda ev, d: QtCore.QTimer.singleShot(0, lambda ev=ev, d=d: self._log_sequence_event(ev, d)))
                except Exception:
                    pass
        except Exception:
            pass
        if hasattr(self.ui, 'btn_start'):
            self.ui.btn_start.setEnabled(False)
        if hasattr(self.ui, 'btn_stop'):
            self.ui.btn_stop.setEnabled(True)

    def stop(self):
        self.log(get_text("log_stop_pressed", self.current_language))
        self._timer.stop()

        close_fn = getattr(self.driver, "close", None)
        if callable(close_fn):
            try:
                close_fn()
                self.log("driver.close() OK")
            except Exception as e:
                self.log(f"driver.close() error: {e}")

        if hasattr(self.ui, 'btn_start'):
            self.ui.btn_start.setEnabled(True)
        if hasattr(self.ui, 'btn_stop'):
            self.ui.btn_stop.setEnabled(False)
        self._update_progress(False)

    def _start_poll(self):
        self.start()

    def _stop_poll(self):
        self.stop()

    def _start_keithley_measurement(self):
        """Start Keithley measurement"""
        self.log("Keithley measurement started (stub)")
        # Get values from UI
        zyklen = self.ui.spin_kei_zyklen.value() if hasattr(self.ui, 'spin_kei_zyklen') else 1
        channels = self.ui.edit_kei_channels.text() if hasattr(self.ui, 'edit_kei_channels') else "101,102"
        self.log(f"Measurement parameters: Zyklen={zyklen}, Channels={channels}")

    def _copy_measurement_to_clipboard(self):
        """Copy measurement data to clipboard (stub implementation)."""
        try:
            data = {
                'Position': getattr(self.ui, 'edit_kei_position').text() if hasattr(self.ui, 'edit_kei_position') else '',
                'Probenerme': getattr(self.ui, 'edit_kei_probenerme').text() if hasattr(self.ui, 'edit_kei_probenerme') else '',
                'Zyklen': getattr(self.ui, 'spin_kei_zyklen').value() if hasattr(self.ui, 'spin_kei_zyklen') else 0,
                'Channels': getattr(self.ui, 'edit_kei_channels').text() if hasattr(self.ui, 'edit_kei_channels') else ''
            }
            text = f"Probenerme: {data['Probenerme']}\nPosition: {data['Position']}\nZyklen: {data['Zyklen']}\nChannels: {data['Channels']}\n"
            cb = QtWidgets.QApplication.clipboard()
            cb.setText(text)
            self.log("✓ Statistik kopiert (Clipboard) – stub")
        except Exception as e:
            self.log(f"⚠️ Clipboard copy failed: {e}")

    def _emergency_stop(self):
        """Emergency stop - immediately stop all measurements and motion"""
        self.log(f"🚨 {get_text('log_emergency_stop', self.current_language)}")
        self._timer.stop()
        
        # Stop all motion
        if self.driver and hasattr(self.driver, 'emergency_stop'):
            try:
                self.driver.emergency_stop()
                self.log(f"✓ {get_text('log_hw_stop_sent', self.current_language)}")
            except Exception as e:
                self.log(f"⚠️ {get_text('log_stop_failed', self.current_language)}: {e}")
        
        # Stop measurement sequence
        if self.controller:
            try:
                self.controller.abort()
                self.log(f"✓ {get_text('log_sequence_aborted', self.current_language)}")
            except Exception:
                pass
        
        self._update_progress(False)
        self.log(f"→ {get_text('log_all_stopped', self.current_language)}")

    def _open_control_panel(self):
        """Open the advanced control panel window"""
        try:
            from control_panel import ControlPanelWindow
            
            # Create control panel if not exists
            if not hasattr(self, 'control_panel_window') or self.control_panel_window is None:
                self.control_panel_window = ControlPanelWindow(driver=self.driver, parent=self)
                self.log("✓ 控制面板已打开")
            
            # Show the window
            self.control_panel_window.show()
            self.control_panel_window.raise_()
            self.control_panel_window.activateWindow()
            
        except Exception as e:
            self.log(f"❌ 无法打开控制面板: {e}")
            import traceback
            traceback.print_exc()

    def _toggle_customize(self):
        """Toggle customize mode to show/hide customizable parameters"""
        self.customize_mode = not self.customize_mode
        
        # List of controls to toggle
        controls_to_toggle = [
            'label_startkraft', 'spin_startkraft',
            'label_df', 'spin_df',
            'label_kraftstufen', 'edit_kraftstufen',
            'label_nennkraft', 'spin_nennkraft',
            'label_zyklen', 'spin_cycles'
        ]
        
        # Toggle visibility for all customizable parameters
        for control_name in controls_to_toggle:
            if hasattr(self.ui, control_name):
                control = getattr(self.ui, control_name)
                control.setVisible(self.customize_mode)
        
        # Update button text to reflect state
        if hasattr(self.ui, 'btn_customize'):
            mode_text = get_text("btn_customize_active", self.current_language) if self.customize_mode else get_text("btn_customize", self.current_language)
            self.ui.btn_customize.setText(mode_text)
        
        status = "aktiviert" if self.customize_mode else "deaktiviert"
        self.log(f"Customize-Modus {status}")

    def _start_sequence_ui(self):
        try:
            cycles = int(self.ui.spin_cycles.value()) if hasattr(self.ui, 'spin_cycles') else 5
            interval = float(self.ui.double_interval.value()) if hasattr(self.ui, 'double_interval') else 0.1
            if self.controller is None:
                self.controller = TSteuerungAblauf(driver=self.driver)
                try:
                    self.controller.on_event(lambda ev, d: QtCore.QTimer.singleShot(0, lambda: self._update_state_label(self.controller.state)))
                    self.controller.on_event(lambda ev, d: QtCore.QTimer.singleShot(0, lambda ev=ev, d=d: self._log_sequence_event(ev, d)))
                except Exception:
                    pass
            ok = self.controller.start_sequence(cycles=cycles, interval=interval)
            self.log(f"start_sequence -> {ok} (cycles={cycles}, interval={interval})")
        except Exception as e:
            self.log(f"start_sequence raised: {e}")

    def _stop_sequence_ui(self):
        try:
            if self.controller is not None:
                ok = self.controller.stop_sequence()
                self.log(f"stop_sequence -> {ok}")
        except Exception as e:
            self.log(f"stop_sequence raised: {e}")

    def _poll(self):
        # Poll driver.get_data() and log a compact representation
        get_fn = getattr(self.driver, "get_data", None)
        if not callable(get_fn):
            self.log("Driver has no get_data()")
            return

        try:
            d = get_fn()
        except Exception as e:
            self.log(f"get_data() raised: {e}")
            return

        if d is None:
            self.log("get_data() returned None")
            self._update_progress(False)
            return

        # mark connection alive
        try:
            self._last_data_ts = QtCore.QDateTime.currentDateTime().toSecsSinceEpoch()
            self._update_progress(True)
        except Exception:
            pass

        # If driver returned a dict we already handle it above. Try to
        # detect ctypes.Structure instances (e.g., DoPEData) and pretty-print
        # important fields for the real driver.
        try:
            from ctypes import Structure as _CStruct
        except Exception:
            _CStruct = None

        if _CStruct is not None and isinstance(d, _CStruct):
            # Attempt to import the canonical DoPEData class to check type
            try:
                from drivers.dope_driver_structs import DoPEData

                is_dope = isinstance(d, DoPEData)
            except Exception:
                is_dope = False

            if is_dope:
                try:
                    cycles = getattr(d, "Cycles", None)
                    ts = getattr(d, "Time", None)
                    pos = getattr(d, "Position", None)
                    load = getattr(d, "Load", None)
                    ext = getattr(d, "Extension", None)
                    sd = getattr(d, "SensorD", None)
                    sensors = []
                    try:
                        raw_sensors = getattr(d, "Sensor", None)
                        if raw_sensors is not None:
                            sensors = [float(x) for x in raw_sensors]
                    except Exception:
                        sensors = []

                    # controller status may be an array of WORDs
                    ctrl0 = None
                    try:
                        cs = getattr(d, "CtrlStatus", None)
                        if cs is not None and len(cs) > 0:
                            ctrl0 = int(cs[0])
                    except Exception:
                        ctrl0 = None

                    ts_fmt = f"{ts:.3f}" if ts is not None else "None"
                    self.log(
                        f"Cycles={cycles} Time={ts_fmt} Pos={pos} Load={load} Ext={ext} SD={sd} Ctrl0={ctrl0} Sensors={sensors[:6]}"
                    )
                    return
                except Exception as e:
                    # Fall through to generic repr on error
                    self.log(f"Error formatting DoPEData: {e}")

        # Fallbacks: dict-like handled above; otherwise show repr
        if isinstance(d, dict):
            tick = d.get("tick")
            ts = d.get("timestamp")
            cs = d.get("ctrl_status")
            sensors = d.get("sensors")
            try:
                ts_fmt = f"{ts:.3f}" if ts is not None else "None"
            except Exception:
                ts_fmt = str(ts)
            self.log(f"tick={tick} ts={ts_fmt} status=0x{cs:02X} sensors={sensors}")
            # update sensor labels if available (format to 3 decimals)
            try:
                if hasattr(self.ui, 'sensor_labels') and sensors is not None:
                    for i in range(min(len(self.ui.sensor_labels), len(sensors))):
                        try:
                            val = float(sensors[i])
                            self.ui.sensor_labels[i].setText(f"S{i}: {val:.3f}")
                        except Exception:
                            self.ui.sensor_labels[i].setText(f"S{i}: {sensors[i]}")
            except Exception:
                pass
            # decode ctrl status flags if helper available
            try:
                from drivers.programm_dope_translated import decode_ctrl_status_word
                if cs is not None:
                    flags = decode_ctrl_status_word(int(cs))
                    # show a short flag summary in the log
                    active = [k for k, v in flags.items() if v]
                    if active:
                        self.log(f"flags: {','.join(active)}")
                    # Plotting disabled to avoid blocking debug log view
            except Exception:
                pass
            # update cycles/position/load labels
            try:
                if hasattr(self.ui, 'edit_time'):
                    val = d.get('timestamp') or d.get('Time')
                    self.ui.edit_time.setText(f"{val:.3f}" if isinstance(val, (int, float)) else str(val))
                if hasattr(self.ui, 'edit_pos'):
                    val = d.get('Position')
                    self.ui.edit_pos.setText(f"{val:.3f}" if isinstance(val, (int, float)) else str(val))
                if hasattr(self.ui, 'edit_kraft'):
                    val = d.get('Load') or d.get('Kraft') or d.get('ctrl_status')
                    self.ui.edit_kraft.setText(f"{val:.3f}" if isinstance(val, (int, float)) else str(val))
                if hasattr(self.ui, 'edit_ub'):
                    val = d.get('Ub') or d.get('ub')
                    self.ui.edit_ub.setText(f"{val:.3f}" if isinstance(val, (int, float)) else str(val))
            except Exception:
                pass
        else:
            self.log(repr(d))


def run_app(driver=None):
    app = QtWidgets.QApplication([])
    win = MainWindow(driver=driver)
    win.show()
    return app.exec()
