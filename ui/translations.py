"""
Translation system for DoPE Controller
Supports German (de), English (en), and Chinese (zh)
"""

TRANSLATIONS = {
    # Window title
    "window_title": {
        "de": "DoPE Controller",
        "en": "DoPE Controller",
        "zh": "DoPE 控制器"
    },
    
    # Language selector
    "language": {
        "de": "Sprache:",
        "en": "Language:",
        "zh": "语言："
    },
    
    # Device selector
    "device": {
        "de": "Gerät:",
        "en": "Device:",
        "zh": "设备："
    },
    
    # Initialization group
    "grp_init": {
        "de": "Initialisierung Geräte",
        "en": "Device Initialization",
        "zh": "设备初始化"
    },
    "btn_init_keithley": {
        "de": "Init Keithley 2700",
        "en": "Init Keithley 2700",
        "zh": "初始化 Keithley 2700"
    },
    "btn_init_hounsfield": {
        "de": "Init Hounsfield",
        "en": "Init Hounsfield",
        "zh": "初始化 Hounsfield"
    },
    "lbl_sensor_val": {
        "de": "Sensor: 10000 N",
        "en": "Sensor: 10000 N",
        "zh": "传感器: 10000 N"
    },
    "lbl_sensor_val_100n": {
        "de": "Sensor: 100 N",
        "en": "Sensor: 100 N",
        "zh": "传感器: 100 N"
    },
    "lbl_sensor_val_1000n": {
        "de": "Sensor: 1000 N",
        "en": "Sensor: 1000 N",
        "zh": "传感器: 1000 N"
    },
    "lbl_sensor_val_10000n": {
        "de": "Sensor: 10000 N",
        "en": "Sensor: 10000 N",
        "zh": "传感器: 10000 N"
    },
    "lbl_conn_status_disconnected": {
        "de": "Verbindung: getrennt",
        "en": "Connection: disconnected",
        "zh": "连接: 已断开"
    },
    "lbl_conn_status_connected": {
        "de": "Verbindung: verbunden",
        "en": "Connection: connected",
        "zh": "连接: 已连接"
    },
    "lbl_kraftdose": {
        "de": "Kraftdose: - - -",
        "en": "Load cell: - - -"
    },
    "btn_move_on": {
        "de": "Bewegung Ein",
        "en": "Motion On"
    },
    "lbl_max_zug": {
        "de": "max. Zug [N]:",
        "en": "max. Tension [N]:"
    },
    "lbl_max_kraft": {
        "de": "max. Kraft [N]:",
        "en": "max. Force [N]:"
    },
    "chk_only_10kn": {
        "de": "nur 10 kN-Dose",
        "en": "only 10 kN cell"
    },
    "btn_move_stop": {
        "de": "Bewegung Halt (Notaus)",
        "en": "Motion Halt (Emergency)"
    },
    "grp_move_mode": {
        "de": "Bewegung mit Poti:",
        "en": "Motion with Poti:"
    },
    "rad_move_aus": {
        "de": "aus",
        "en": "off"
    },
    "rad_move_speed": {
        "de": "Geschwindigkeit",
        "en": "Speed"
    },
    "rad_move_position": {
        "de": "Position",
        "en": "Position"
    },
    
    # Measurement group
    "grp_measure": {
        "de": "Messung der Sensoren",
        "en": "Sensor Measurement"
    },
    "label_sample_name": {
        "de": "Probenerme",
        "en": "Sample Name",
        "zh": "样品名称"
    },
    "btn_annehmen": {
        "de": "annähern",
        "en": "approach"
    },
    "btn_kontrolle": {
        "de": "Kontrolle",
        "en": "Check"
    },
    "btn_meas_start": {
        "de": "Messung Start",
        "en": "Start Measurement"
    },
    "btn_meas_halt": {
        "de": "Bewegung Halt",
        "en": "Emergency Stop",
        "zh": "强制停止"
    },
    "btn_customize": {
        "de": "Customize",
        "en": "Customize",
        "zh": "自定义"
    },
    "btn_customize_active": {
        "de": "Customize ✓",
        "en": "Customize ✓",
        "zh": "自定义 ✓"
    },
    "chk_datei": {
        "de": "Datei",
        "en": "File"
    },
    "btn_meas_stop": {
        "de": "Stop",
        "en": "Stop"
    },
    "label_time": {
        "de": "Zeit:",
        "en": "Time:"
    },
    "label_pos": {
        "de": "Position:",
        "en": "Position:"
    },
    "label_kraft": {
        "de": "Kraft:",
        "en": "Force:"
    },
    "label_ub": {
        "de": "Ub [mV]:",
        "en": "Ub [mV]:"
    },
    "chk_startkraft": {
        "de": "Startkraft [N]",
        "en": "Start Force [N]"
    },
    "label_startkraft": {
        "de": "Startkraft [N]",
        "en": "Start Force [N]",
        "zh": "启动力 [N]"
    },
    "label_df": {
        "de": "dF [N/s]",
        "en": "dF [N/s]",
        "zh": "dF [N/s]"
    },
    "label_kraftstufen": {
        "de": "Kraftstufen:",
        "en": "Force Steps:",
        "zh": "力级："
    },
    "label_nennkraft": {
        "de": "Nennkraft (FS)",
        "en": "Nominal Force (FS)",
        "zh": "额定力 (FS)"
    },
    "label_zyklen": {
        "de": "Zyklen:",
        "en": "Cycles:",
        "zh": "周期："
    },
    
    # Keithley measurement group
    "lbl_kei_erstellung_messung": {
        "de": "Erstellung Messung",
        "en": "Measurement Creation",
        "zh": "测量创建"
    },
    "lbl_kei_standeort": {
        "de": "Standeort",
        "en": "Location",
        "zh": "位置"
    },
    "lbl_kei_standartl": {
        "de": "Standart",
        "en": "Standard",
        "zh": "标准"
    },
    "lbl_kei_position": {
        "de": "Position [mm/V]",
        "en": "Position [mm/V]",
        "zh": "位置 [mm/V]"
    },
    "lbl_kei_zyklen": {
        "de": "Zyklen",
        "en": "Cycles",
        "zh": "周期"
    },
    "btn_kei_start": {
        "de": "Start Messung",
        "en": "Start Measurement",
        "zh": "开始测量"
    },
    "lbl_kei_probenerme": {
        "de": "Probenerme",
        "en": "Sample Name",
        "zh": "样品名称"
    },
    "btn_kei_bildung": {
        "de": "Bildung Stat",
        "en": "Build Statistics",
        "zh": "生成统计"
    },
    "lbl_kei_del": {
        "de": "D-delay [s]",
        "en": "D-delay [s]",
        "zh": "D延迟 [s]"
    },
    "lbl_kei_channels": {
        "de": "Channels:",
        "en": "Channels:",
        "zh": "通道："
    },
    
    
    "lbl_state": {
        "de": "Status: --",
        "en": "State: --"
    },
    
    # Log messages
    "log_start_pressed": {
        "de": "Start gedrückt",
        "en": "Start pressed"
    },
    "log_stop_pressed": {
        "de": "Stop gedrückt",
        "en": "Stop pressed"
    },
    "log_using_real_driver": {
        "de": "Verwende echten DopeDriver",
        "en": "Using real DopeDriver"
    },
    "log_dll_load_error": {
        "de": "Fehler beim Laden der DoPE DLL",
        "en": "Failed to load DoPE DLL"
    },
    "log_dll_check": {
        "de": "Bitte stellen Sie sicher, dass DoPE.dll und DoDpx.dll im drivers/ Verzeichnis sind",
        "en": "Please ensure DoPE.dll and DoDpx.dll are in the drivers/ directory"
    },
    "log_no_driver": {
        "de": "Kein Treiber verfügbar",
        "en": "No driver available"
    },
    "log_trying_com": {
        "de": "Versuche Verbindung zu COM{}, {} Baud...",
        "en": "Trying connection to COM{}, {} baud..."
    },
    "log_com_ok": {
        "de": "COM{} antwortet normal",
        "en": "COM{} responding normally"
    },
    "log_com_no_response": {
        "de": "COM{}: Gerät antwortet nicht",
        "en": "COM{}: Device not responding"
    },
    "log_com_not_exist": {
        "de": "COM{}: Port existiert nicht",
        "en": "COM{}: Port does not exist"
    },
    "log_com_error": {
        "de": "COM{}: Fehler 0x{:04X}",
        "en": "COM{}: Error 0x{:04X}"
    },
    "log_all_com_failed": {
        "de": "Alle COM-Ports konnten nicht verbunden werden",
        "en": "Failed to connect to all COM ports"
    },
    "log_hardware_connected": {
        "de": "Hardware verbunden",
        "en": "Hardware connected"
    },
    "log_hardware_failed": {
        "de": "Hardware-Verbindung fehlgeschlagen",
        "en": "Hardware connection failed"
    },
    "log_check_device": {
        "de": "Bitte prüfen: 1) Gerät eingeschaltet 2) USB/Serielles Kabel verbunden 3) COM-Port im Geräte-Manager",
        "en": "Please check: 1) Device powered on 2) USB/Serial cable connected 3) COM port in Device Manager"
    },
    "log_wrong_com": {
        "de": "Hinweis: Aktueller Versuch COM{}, falls falsch bitte Code oder Konfiguration ändern",
        "en": "Note: Currently trying COM{}, if wrong please modify code or configuration"
    },
    "log_no_hardware": {
        "de": "Hinweis: Derzeit keine Hardware-Verbindung, Schaltfläche nur zum Testen der UI",
        "en": "Note: Currently no hardware connection, button for UI testing only"
    },
    "log_emergency_stop": {
        "de": "Notaus!",
        "en": "Emergency Stop!"
    },
    "log_hw_stop_sent": {
        "de": "Hardware-Stoppbefehl gesendet",
        "en": "Hardware stop command sent"
    },
    "log_stop_failed": {
        "de": "Stoppbefehl fehlgeschlagen",
        "en": "Stop command failed"
    },
    "log_sequence_aborted": {
        "de": "Messsequenz abgebrochen",
        "en": "Measurement sequence aborted"
    },
    "log_all_stopped": {
        "de": "Alle Vorgänge gestoppt, bitte Gerätestatus überprüfen",
        "en": "All operations stopped, please check device status"
    },
    
    # Error codes
    "error_0x800B": {
        "de": "Gerät antwortet nicht (keine Hardware-Verbindung)",
        "en": "Device not responding (no hardware connection)"
    },
    "error_0x8006": {
        "de": "Serieller Port konnte nicht geöffnet werden",
        "en": "Failed to open serial port"
    },
    "error_0x8007": {
        "de": "Serieller Port ist belegt",
        "en": "Serial port is in use"
    },
    "error_unknown": {
        "de": "Unbekannter Fehler",
        "en": "Unknown error"
    }
}


def get_text(key: str, lang: str = "de", **kwargs) -> str:
    """
    Get translated text for a given key
    
    Args:
        key: Translation key
        lang: Language code ('de', 'en', or 'zh')
        **kwargs: Format arguments for string formatting
    
    Returns:
        Translated text, or key if not found
    """
    if key not in TRANSLATIONS:
        return key
    
    # Try to get translation for requested language, fallback to German, then English
    text = TRANSLATIONS[key].get(lang)
    if text is None:
        text = TRANSLATIONS[key].get("de")
    if text is None:
        text = TRANSLATIONS[key].get("en", key)
    
    # Auto-generate Chinese if missing (simple fallback)
    if lang == "zh" and text == TRANSLATIONS[key].get("en"):
        # If no Chinese translation, use English
        pass
    
    # Apply formatting if kwargs provided
    if kwargs:
        try:
            text = text.format(**kwargs)
        except (KeyError, IndexError):
            pass
    
    return text
