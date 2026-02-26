# This file was generated from main_window.ui (hand-maintained for stability)
from PyQt5 import QtCore, QtWidgets


class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(980, 720)
        self.centralwidget = QtWidgets.QWidget(MainWindow)

        # Outer layout
        self.verticalLayout = QtWidgets.QVBoxLayout(self.centralwidget)
        self.verticalLayout.setObjectName("verticalLayout")

        # --- Language & Device selector ---
        self.layout_lang = QtWidgets.QHBoxLayout()
        self.layout_lang.setObjectName("layout_lang")
        self.lbl_language = QtWidgets.QLabel(self.centralwidget)
        self.lbl_language.setObjectName("lbl_language")
        self.layout_lang.addWidget(self.lbl_language)
        self.combo_language = QtWidgets.QComboBox(self.centralwidget)
        self.combo_language.setObjectName("combo_language")
        self.combo_language.addItem("Deutsch")
        self.combo_language.addItem("English")
        self.combo_language.addItem("中文")
        self.combo_language.setMaximumWidth(150)
        self.layout_lang.addWidget(self.combo_language)
        
        # Device selector
        self.lbl_device = QtWidgets.QLabel(self.centralwidget)
        self.lbl_device.setObjectName("lbl_device")
        self.lbl_device.setText("Gerät:")
        self.layout_lang.addWidget(self.lbl_device)
        self.combo_device = QtWidgets.QComboBox(self.centralwidget)
        self.combo_device.setObjectName("combo_device")
        self.combo_device.addItem("Hounsfield")
        self.combo_device.addItem("Keithley")
        self.combo_device.setMaximumWidth(150)
        self.layout_lang.addWidget(self.combo_device)
        
        self.layout_lang.addStretch()
        self.verticalLayout.addLayout(self.layout_lang)

        # --- Initialization group ---
        self.grp_init = QtWidgets.QGroupBox(self.centralwidget)
        self.grp_init.setObjectName("grp_init")
        self.gridLayout_init = QtWidgets.QGridLayout(self.grp_init)
        self.gridLayout_init.setObjectName("gridLayout_init")

        # Row 0
        self.btn_init_keithley = QtWidgets.QPushButton(self.grp_init)
        self.btn_init_keithley.setObjectName("btn_init_keithley")
        self.gridLayout_init.addWidget(self.btn_init_keithley, 0, 0, 1, 1)

        self.lbl_sensor_val = QtWidgets.QLabel(self.grp_init)
        self.lbl_sensor_val.setObjectName("lbl_sensor_val")
        self.gridLayout_init.addWidget(self.lbl_sensor_val, 0, 1, 1, 1)

        self.btn_init_hounsfield = QtWidgets.QPushButton(self.grp_init)
        self.btn_init_hounsfield.setObjectName("btn_init_hounsfield")
        self.gridLayout_init.addWidget(self.btn_init_hounsfield, 1, 0, 1, 1)

        # Control Panel Button
        self.btn_open_control_panel = QtWidgets.QPushButton(self.grp_init)
        self.btn_open_control_panel.setObjectName("btn_open_control_panel")
        self.btn_open_control_panel.setText("打开控制面板")
        self.btn_open_control_panel.setStyleSheet("background-color: #2196F3; color: white; font-weight: bold; padding: 8px;")
        self.gridLayout_init.addWidget(self.btn_open_control_panel, 0, 2, 1, 1)

        self.layout_conn = QtWidgets.QHBoxLayout()
        self.layout_conn.setObjectName("layout_conn")
        self.lbl_conn_status = QtWidgets.QLabel(self.grp_init)
        self.lbl_conn_status.setObjectName("lbl_conn_status")
        self.layout_conn.addWidget(self.lbl_conn_status)
        self.progress_conn = QtWidgets.QProgressBar(self.grp_init)
        self.progress_conn.setObjectName("progress_conn")
        self.progress_conn.setMinimumSize(QtCore.QSize(200, 0))
        self.progress_conn.setValue(0)
        self.progress_conn.setTextVisible(True)
        self.layout_conn.addWidget(self.progress_conn)
        self.gridLayout_init.addLayout(self.layout_conn, 1, 1, 1, 2)

        self.lbl_kraftdose = QtWidgets.QLabel(self.grp_init)
        self.lbl_kraftdose.setObjectName("lbl_kraftdose")
        self.gridLayout_init.addWidget(self.lbl_kraftdose, 1, 3, 1, 1)

        # Row 2
        self.btn_move_on = QtWidgets.QPushButton(self.grp_init)
        self.btn_move_on.setObjectName("btn_move_on")
        self.gridLayout_init.addWidget(self.btn_move_on, 2, 0, 1, 1)

        self.layout_maxzug = QtWidgets.QHBoxLayout()
        self.layout_maxzug.setObjectName("layout_maxzug")
        self.lbl_max_zug = QtWidgets.QLabel(self.grp_init)
        self.lbl_max_zug.setObjectName("lbl_max_zug")
        self.layout_maxzug.addWidget(self.lbl_max_zug)
        self.spin_max_zug = QtWidgets.QSpinBox(self.grp_init)
        self.spin_max_zug.setObjectName("spin_max_zug")
        self.spin_max_zug.setMaximum(200000)
        self.spin_max_zug.setValue(500)
        self.layout_maxzug.addWidget(self.spin_max_zug)
        self.gridLayout_init.addLayout(self.layout_maxzug, 2, 1, 1, 1)

        self.layout_maxkraft = QtWidgets.QHBoxLayout()
        self.layout_maxkraft.setObjectName("layout_maxkraft")
        self.lbl_max_kraft = QtWidgets.QLabel(self.grp_init)
        self.lbl_max_kraft.setObjectName("lbl_max_kraft")
        self.layout_maxkraft.addWidget(self.lbl_max_kraft)
        self.spin_max_kraft = QtWidgets.QSpinBox(self.grp_init)
        self.spin_max_kraft.setObjectName("spin_max_kraft")
        self.spin_max_kraft.setMaximum(200000)
        self.spin_max_kraft.setValue(50)
        self.layout_maxkraft.addWidget(self.spin_max_kraft)
        self.gridLayout_init.addLayout(self.layout_maxkraft, 2, 2, 1, 1)

        self.chk_only_10kn = QtWidgets.QCheckBox(self.grp_init)
        self.chk_only_10kn.setObjectName("chk_only_10kn")
        self.gridLayout_init.addWidget(self.chk_only_10kn, 2, 3, 1, 1)

        # Row 3
        self.btn_move_stop = QtWidgets.QPushButton(self.grp_init)
        self.btn_move_stop.setObjectName("btn_move_stop")
        self.btn_move_stop.setStyleSheet("color: red; font-weight: bold;")
        self.gridLayout_init.addWidget(self.btn_move_stop, 3, 0, 1, 1)

        self.grp_move_mode = QtWidgets.QGroupBox(self.grp_init)
        self.grp_move_mode.setObjectName("grp_move_mode")
        self.layout_move_mode = QtWidgets.QHBoxLayout(self.grp_move_mode)
        self.layout_move_mode.setObjectName("layout_move_mode")
        self.rad_move_aus = QtWidgets.QRadioButton(self.grp_move_mode)
        self.rad_move_aus.setObjectName("rad_move_aus")
        self.rad_move_aus.setChecked(True)
        self.layout_move_mode.addWidget(self.rad_move_aus)
        self.rad_move_speed = QtWidgets.QRadioButton(self.grp_move_mode)
        self.rad_move_speed.setObjectName("rad_move_speed")
        self.layout_move_mode.addWidget(self.rad_move_speed)
        self.rad_move_position = QtWidgets.QRadioButton(self.grp_move_mode)
        self.rad_move_position.setObjectName("rad_move_position")
        self.layout_move_mode.addWidget(self.rad_move_position)
        self.gridLayout_init.addWidget(self.grp_move_mode, 3, 3, 1, 1)

        self.verticalLayout.addWidget(self.grp_init)

        # --- Measurement group ---
        self.grp_measure = QtWidgets.QGroupBox(self.centralwidget)
        self.grp_measure.setObjectName("grp_measure")
        self.gridLayout_meas = QtWidgets.QGridLayout(self.grp_measure)
        self.gridLayout_meas.setObjectName("gridLayout_meas")

        # Row 0 - Sample Name (Hounsfield)
        self.label_sample_name = QtWidgets.QLabel(self.grp_measure)
        self.label_sample_name.setObjectName("label_sample_name")
        self.gridLayout_meas.addWidget(self.label_sample_name, 0, 0, 1, 1)

        self.edit_sample_name = QtWidgets.QLineEdit(self.grp_measure)
        self.edit_sample_name.setObjectName("edit_sample_name")
        self.gridLayout_meas.addWidget(self.edit_sample_name, 0, 1, 1, 2)

        # Customize section
        self.lbl_startkraft_label = QtWidgets.QLabel(self.grp_measure)
        self.lbl_startkraft_label.setObjectName("lbl_startkraft_label")
        self.lbl_startkraft_label.setText("Startkraft [N]")
        self.lbl_startkraft_label.setVisible(False)
        self.gridLayout_meas.addWidget(self.lbl_startkraft_label, 0, 3, 1, 1)

        self.btn_customize = QtWidgets.QPushButton(self.grp_measure)
        self.btn_customize.setObjectName("btn_customize")
        self.btn_customize.setText("Customize")
        self.gridLayout_meas.addWidget(self.btn_customize, 0, 4, 1, 1)

        # Row 1
        self.label_time = QtWidgets.QLabel(self.grp_measure)
        self.label_time.setObjectName("label_time")
        self.gridLayout_meas.addWidget(self.label_time, 1, 0, 1, 1)

        self.edit_time = QtWidgets.QLineEdit(self.grp_measure)
        self.edit_time.setObjectName("edit_time")
        self.edit_time.setReadOnly(True)
        self.gridLayout_meas.addWidget(self.edit_time, 1, 1, 1, 1)

        self.label_pos = QtWidgets.QLabel(self.grp_measure)
        self.label_pos.setObjectName("label_pos")
        self.gridLayout_meas.addWidget(self.label_pos, 1, 2, 1, 1)

        self.edit_pos = QtWidgets.QLineEdit(self.grp_measure)
        self.edit_pos.setObjectName("edit_pos")
        self.edit_pos.setReadOnly(True)
        self.gridLayout_meas.addWidget(self.edit_pos, 1, 3, 1, 1)

        self.label_kraft = QtWidgets.QLabel(self.grp_measure)
        self.label_kraft.setObjectName("label_kraft")
        self.gridLayout_meas.addWidget(self.label_kraft, 1, 4, 1, 1)

        self.edit_kraft = QtWidgets.QLineEdit(self.grp_measure)
        self.edit_kraft.setObjectName("edit_kraft")
        self.edit_kraft.setReadOnly(True)
        self.gridLayout_meas.addWidget(self.edit_kraft, 1, 5, 1, 1)

        self.label_ub = QtWidgets.QLabel(self.grp_measure)
        self.label_ub.setObjectName("label_ub")
        self.gridLayout_meas.addWidget(self.label_ub, 1, 6, 1, 1)

        self.edit_ub = QtWidgets.QLineEdit(self.grp_measure)
        self.edit_ub.setObjectName("edit_ub")
        self.edit_ub.setReadOnly(True)
        self.gridLayout_meas.addWidget(self.edit_ub, 1, 7, 1, 1)

        # Row 2 - Customizable parameters (initially hidden)
        self.spin_startkraft = QtWidgets.QDoubleSpinBox(self.grp_measure)
        self.spin_startkraft.setObjectName("spin_startkraft")
        self.spin_startkraft.setVisible(False)
        self.gridLayout_meas.addWidget(self.spin_startkraft, 2, 1, 1, 1)
        self.spin_startkraft.setDecimals(2)
        self.spin_startkraft.setMaximum(1000000.0)
        # Row 2 - Labels for customizable parameters (initially hidden)
        self.label_startkraft = QtWidgets.QLabel(self.grp_measure)
        self.label_startkraft.setObjectName("label_startkraft")
        self.label_startkraft.setText("Startkraft [N]")
        self.label_startkraft.setVisible(False)
        self.gridLayout_meas.addWidget(self.label_startkraft, 2, 0, 1, 1)
        self.gridLayout_meas.addWidget(self.spin_startkraft, 2, 1, 1, 1)

        self.label_df = QtWidgets.QLabel(self.grp_measure)
        self.label_df.setObjectName("label_df")
        self.label_df.setVisible(False)
        self.gridLayout_meas.addWidget(self.label_df, 2, 2, 1, 1)

        self.spin_df = QtWidgets.QDoubleSpinBox(self.grp_measure)
        self.spin_df.setObjectName("spin_df")
        self.spin_df.setDecimals(2)
        self.spin_df.setMaximum(1000000.0)
        self.spin_df.setValue(2.0)
        self.spin_df.setVisible(False)
        self.gridLayout_meas.addWidget(self.spin_df, 2, 3, 1, 1)

        self.label_kraftstufen = QtWidgets.QLabel(self.grp_measure)
        self.label_kraftstufen.setObjectName("label_kraftstufen")
        self.label_kraftstufen.setVisible(False)
        self.gridLayout_meas.addWidget(self.label_kraftstufen, 2, 4, 1, 1)

        self.edit_kraftstufen = QtWidgets.QLineEdit(self.grp_measure)
        self.edit_kraftstufen.setObjectName("edit_kraftstufen")
        self.edit_kraftstufen.setVisible(False)
        self.gridLayout_meas.addWidget(self.edit_kraftstufen, 2, 5, 1, 1)

        self.label_nennkraft = QtWidgets.QLabel(self.grp_measure)
        self.label_nennkraft.setObjectName("label_nennkraft")
        self.label_nennkraft.setVisible(False)
        self.gridLayout_meas.addWidget(self.label_nennkraft, 2, 6, 1, 1)

        self.spin_nennkraft = QtWidgets.QSpinBox(self.grp_measure)
        self.spin_nennkraft.setObjectName("spin_nennkraft")
        self.spin_nennkraft.setMaximum(100000)
        self.spin_nennkraft.setValue(25)
        self.spin_nennkraft.setVisible(False)
        self.gridLayout_meas.addWidget(self.spin_nennkraft, 2, 7, 1, 1)

        # Row 3 (cycles only as in UI spec)
        self.label_zyklen = QtWidgets.QLabel(self.grp_measure)
        self.label_zyklen.setObjectName("label_zyklen")
        self.label_zyklen.setVisible(False)
        self.gridLayout_meas.addWidget(self.label_zyklen, 3, 6, 1, 1)

        self.spin_cycles = QtWidgets.QSpinBox(self.grp_measure)
        self.spin_cycles.setObjectName("spin_cycles")
        self.spin_cycles.setMaximum(100000)
        self.spin_cycles.setValue(1)
        self.spin_cycles.setVisible(False)
        self.gridLayout_meas.addWidget(self.spin_cycles, 3, 7, 1, 1)

        # Row 4 - Bottom action buttons (Start / Halt)
        self.btn_meas_start = QtWidgets.QPushButton(self.grp_measure)
        self.btn_meas_start.setObjectName("btn_meas_start")
        self.gridLayout_meas.addWidget(self.btn_meas_start, 4, 0, 1, 2)

        self.btn_meas_halt = QtWidgets.QPushButton(self.grp_measure)
        self.btn_meas_halt.setObjectName("btn_meas_halt")
        self.gridLayout_meas.addWidget(self.btn_meas_halt, 4, 2, 1, 2)

        self.verticalLayout.addWidget(self.grp_measure)

        # --- Keithley Measurement group (hidden by default) ---
        self.grp_keithley = QtWidgets.QGroupBox(self.centralwidget)
        self.grp_keithley.setObjectName("grp_keithley")
        self.grp_keithley.setTitle("Messungen")
        self.grp_keithley.setVisible(False)
        self.gridLayout_keithley = QtWidgets.QGridLayout(self.grp_keithley)
        self.gridLayout_keithley.setObjectName("gridLayout_keithley")

        # Row 0: Sample Name
        self.lbl_kei_probenerme = QtWidgets.QLabel(self.grp_keithley)
        self.lbl_kei_probenerme.setObjectName("lbl_kei_probenerme")
        self.lbl_kei_probenerme.setText("Probenerme")
        self.gridLayout_keithley.addWidget(self.lbl_kei_probenerme, 0, 0, 1, 1)

        self.edit_kei_probenerme = QtWidgets.QLineEdit(self.grp_keithley)
        self.edit_kei_probenerme.setObjectName("edit_kei_probenerme")
        self.gridLayout_keithley.addWidget(self.edit_kei_probenerme, 0, 1, 1, 1)

        # Row 1: Position [mm/V]
        self.lbl_kei_position = QtWidgets.QLabel(self.grp_keithley)
        self.lbl_kei_position.setObjectName("lbl_kei_position")
        self.lbl_kei_position.setText("Position [mm/V]")
        self.gridLayout_keithley.addWidget(self.lbl_kei_position, 1, 0, 1, 1)

        self.edit_kei_position = QtWidgets.QLineEdit(self.grp_keithley)
        self.edit_kei_position.setObjectName("edit_kei_position")
        self.gridLayout_keithley.addWidget(self.edit_kei_position, 1, 1, 1, 1)

        # Row 2: Zyklen and "Build Statistics" button
        self.lbl_kei_zyklen = QtWidgets.QLabel(self.grp_keithley)
        self.lbl_kei_zyklen.setObjectName("lbl_kei_zyklen")
        self.lbl_kei_zyklen.setText("Zyklen")
        self.gridLayout_keithley.addWidget(self.lbl_kei_zyklen, 2, 0, 1, 1)

        self.spin_kei_zyklen = QtWidgets.QSpinBox(self.grp_keithley)
        self.spin_kei_zyklen.setObjectName("spin_kei_zyklen")
        self.spin_kei_zyklen.setMaximum(100000)
        self.spin_kei_zyklen.setValue(1)
        self.gridLayout_keithley.addWidget(self.spin_kei_zyklen, 2, 1, 1, 1)

        self.btn_kei_bildung = QtWidgets.QPushButton(self.grp_keithley)
        self.btn_kei_bildung.setObjectName("btn_kei_bildung")
        self.btn_kei_bildung.setText("Bildung Stat")
        self.gridLayout_keithley.addWidget(self.btn_kei_bildung, 2, 2, 1, 1)

        # Row 3: D-delay
        self.lbl_kei_del = QtWidgets.QLabel(self.grp_keithley)
        self.lbl_kei_del.setObjectName("lbl_kei_del")
        self.lbl_kei_del.setText("D-delay [s]")
        self.gridLayout_keithley.addWidget(self.lbl_kei_del, 3, 0, 1, 1)

        self.spin_kei_del = QtWidgets.QSpinBox(self.grp_keithley)
        self.spin_kei_del.setObjectName("spin_kei_del")
        self.spin_kei_del.setMaximum(300)
        self.spin_kei_del.setValue(20)
        self.gridLayout_keithley.addWidget(self.spin_kei_del, 3, 1, 1, 1)

        # Row 4: Channels
        self.lbl_kei_channels = QtWidgets.QLabel(self.grp_keithley)
        self.lbl_kei_channels.setObjectName("lbl_kei_channels")
        self.lbl_kei_channels.setText("Channels:")
        self.gridLayout_keithley.addWidget(self.lbl_kei_channels, 4, 0, 1, 1)

        self.edit_kei_channels = QtWidgets.QLineEdit(self.grp_keithley)
        self.edit_kei_channels.setObjectName("edit_kei_channels")
        self.edit_kei_channels.setText("101,102")
        self.gridLayout_keithley.addWidget(self.edit_kei_channels, 4, 1, 1, 1)

        # Row 5: Bottom action buttons (Start / Halt) at the bottom
        self.btn_kei_start = QtWidgets.QPushButton(self.grp_keithley)
        self.btn_kei_start.setObjectName("btn_kei_start")
        self.btn_kei_start.setText("Start Messung")
        self.gridLayout_keithley.addWidget(self.btn_kei_start, 5, 0, 1, 2)

        self.btn_kei_stop = QtWidgets.QPushButton(self.grp_keithley)
        self.btn_kei_stop.setObjectName("btn_kei_stop")
        self.btn_kei_stop.setText("Bewegung Halt (强制停止)")
        self.gridLayout_keithley.addWidget(self.btn_kei_stop, 5, 2, 1, 1)
        
        self.verticalLayout.addWidget(self.grp_keithley)

        # Controller state label (kept for driver feedback)
        self.lbl_state = QtWidgets.QLabel(self.centralwidget)
        self.lbl_state.setObjectName("lbl_state")
        self.verticalLayout.addWidget(self.lbl_state)

        # Log output
        self.log = QtWidgets.QPlainTextEdit(self.centralwidget)
        self.log.setObjectName("log")
        self.log.setMinimumSize(QtCore.QSize(0, 150))
        self.verticalLayout.addWidget(self.log)

        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "DoPE Controller"))
        self.grp_init.setTitle(_translate("MainWindow", "Initialisierung Geräte"))
        self.btn_init_keithley.setText(_translate("MainWindow", "Init Keithley 2700"))
        self.lbl_sensor_val.setText(_translate("MainWindow", "Sensor: 10000 N"))
        self.btn_init_hounsfield.setText(_translate("MainWindow", "Init Hounsfield"))
        self.lbl_conn_status.setText(_translate("MainWindow", "Verbindung: getrennt"))
        self.progress_conn.setFormat(_translate("MainWindow", "%p%"))
        self.lbl_kraftdose.setText(_translate("MainWindow", "Kraftdose: - - -"))
        self.btn_move_on.setText(_translate("MainWindow", "Bewegung Ein"))
        self.lbl_max_zug.setText(_translate("MainWindow", "max. Zug [N]:"))
        self.lbl_max_kraft.setText(_translate("MainWindow", "max. Kraft [N]:"))
        self.chk_only_10kn.setText(_translate("MainWindow", "nur 10 kN-Dose"))
        self.btn_move_stop.setText(_translate("MainWindow", "Bewegung Halt (强制停止)"))
        self.grp_move_mode.setTitle(_translate("MainWindow", "Bewegung mit Poti:"))
        self.rad_move_aus.setText(_translate("MainWindow", "aus"))
        self.rad_move_speed.setText(_translate("MainWindow", "Geschwindigkeit"))
        self.rad_move_position.setText(_translate("MainWindow", "Position"))

        self.grp_measure.setTitle(_translate("MainWindow", "Messung der Sensoren"))
        self.label_sample_name.setText(_translate("MainWindow", "Sample Name"))
        self.btn_meas_start.setText(_translate("MainWindow", "Messung Start"))
        self.btn_meas_halt.setText(_translate("MainWindow", "Bewegung Halt (强制停止)"))
        self.btn_customize.setText(_translate("MainWindow", "Customize"))
        self.lbl_startkraft_label.setText(_translate("MainWindow", "Startkraft [N]"))
        self.label_time.setText(_translate("MainWindow", "Zeit:"))
        self.label_pos.setText(_translate("MainWindow", "Position:"))
        self.label_kraft.setText(_translate("MainWindow", "Kraft:"))
        self.label_ub.setText(_translate("MainWindow", "Ub [mV]:"))
        self.label_startkraft.setText(_translate("MainWindow", "Startkraft [N]"))
        self.label_df.setText(_translate("MainWindow", "dF [N/s]:"))
        self.label_kraftstufen.setText(_translate("MainWindow", "Kraftstufen:"))
        self.label_nennkraft.setText(_translate("MainWindow", "Nennkraft (FS) [N]:"))
        self.label_zyklen.setText(_translate("MainWindow", "Zyklen:"))
        self.edit_kraftstufen.setText(_translate("MainWindow", "0.5,10,15,20,25,20,15,10,5"))
        self.lbl_state.setText(_translate("MainWindow", "State: --"))

        # Keithley panel texts
        self.grp_keithley.setTitle(_translate("MainWindow", "Messungen"))
        self.lbl_kei_probenerme.setText(_translate("MainWindow", "Probenerme"))
        self.lbl_kei_position.setText(_translate("MainWindow", "Position [mm/V]"))
        self.lbl_kei_zyklen.setText(_translate("MainWindow", "Zyklen"))
        self.btn_kei_bildung.setText(_translate("MainWindow", "Bildung Stat"))
        self.lbl_kei_del.setText(_translate("MainWindow", "D-delay [s]"))
        self.lbl_kei_channels.setText(_translate("MainWindow", "Channels:"))
        self.btn_kei_start.setText(_translate("MainWindow", "Start Messung"))
