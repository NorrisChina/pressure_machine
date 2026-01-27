"""
设备控制面板 UI
提供完整的 Hounsfield/Keithley 设备控制界面
"""

from PyQt5 import QtCore, QtWidgets


class Ui_ControlPanel:
    def setupUi(self, ControlPanel):
        ControlPanel.setObjectName("ControlPanel")
        ControlPanel.resize(1000, 700)
        
        self.centralwidget = QtWidgets.QWidget(ControlPanel)
        self.centralwidget.setObjectName("centralwidget")
        
        self.mainLayout = QtWidgets.QVBoxLayout(self.centralwidget)
        self.mainLayout.setObjectName("mainLayout")
        
        # ===== 顶部状态栏 =====
        self.statusBar = QtWidgets.QGroupBox(self.centralwidget)
        self.statusBar.setObjectName("statusBar")
        self.statusBar.setTitle("设备状态")
        self.statusLayout = QtWidgets.QHBoxLayout(self.statusBar)
        
        self.lbl_connection = QtWidgets.QLabel(self.statusBar)
        self.lbl_connection.setObjectName("lbl_connection")
        self.lbl_connection.setText("连接状态: 已连接")
        self.lbl_connection.setStyleSheet("color: green; font-weight: bold; font-size: 14px;")
        self.statusLayout.addWidget(self.lbl_connection)
        
        self.statusLayout.addStretch()
        
        self.lbl_device_type = QtWidgets.QLabel(self.statusBar)
        self.lbl_device_type.setObjectName("lbl_device_type")
        self.lbl_device_type.setText("设备: Hounsfield")
        self.statusLayout.addWidget(self.lbl_device_type)
        
        self.mainLayout.addWidget(self.statusBar)
        
        # ===== 实时数据显示区域 =====
        self.grp_realtime = QtWidgets.QGroupBox(self.centralwidget)
        self.grp_realtime.setObjectName("grp_realtime")
        self.grp_realtime.setTitle("实时数据")
        self.gridLayout_realtime = QtWidgets.QGridLayout(self.grp_realtime)
        
        # 位置显示
        self.lbl_position_title = QtWidgets.QLabel(self.grp_realtime)
        self.lbl_position_title.setText("当前位置 [mm]:")
        self.lbl_position_title.setStyleSheet("font-weight: bold;")
        self.gridLayout_realtime.addWidget(self.lbl_position_title, 0, 0)
        
        self.lbl_position_value = QtWidgets.QLabel(self.grp_realtime)
        self.lbl_position_value.setObjectName("lbl_position_value")
        self.lbl_position_value.setText("0.00")
        self.lbl_position_value.setStyleSheet("font-size: 20px; color: blue;")
        self.gridLayout_realtime.addWidget(self.lbl_position_value, 0, 1)
        
        # 力显示
        self.lbl_force_title = QtWidgets.QLabel(self.grp_realtime)
        self.lbl_force_title.setText("当前力 [N]:")
        self.lbl_force_title.setStyleSheet("font-weight: bold;")
        self.gridLayout_realtime.addWidget(self.lbl_force_title, 0, 2)
        
        self.lbl_force_value = QtWidgets.QLabel(self.grp_realtime)
        self.lbl_force_value.setObjectName("lbl_force_value")
        self.lbl_force_value.setText("0.00")
        self.lbl_force_value.setStyleSheet("font-size: 20px; color: red;")
        self.gridLayout_realtime.addWidget(self.lbl_force_value, 0, 3)
        
        # 时间显示
        self.lbl_time_title = QtWidgets.QLabel(self.grp_realtime)
        self.lbl_time_title.setText("运行时间 [s]:")
        self.lbl_time_title.setStyleSheet("font-weight: bold;")
        self.gridLayout_realtime.addWidget(self.lbl_time_title, 1, 0)
        
        self.lbl_time_value = QtWidgets.QLabel(self.grp_realtime)
        self.lbl_time_value.setObjectName("lbl_time_value")
        self.lbl_time_value.setText("0.00")
        self.lbl_time_value.setStyleSheet("font-size: 16px;")
        self.gridLayout_realtime.addWidget(self.lbl_time_value, 1, 1)
        
        # 循环次数
        self.lbl_cycles_title = QtWidgets.QLabel(self.grp_realtime)
        self.lbl_cycles_title.setText("循环次数:")
        self.lbl_cycles_title.setStyleSheet("font-weight: bold;")
        self.gridLayout_realtime.addWidget(self.lbl_cycles_title, 1, 2)
        
        self.lbl_cycles_value = QtWidgets.QLabel(self.grp_realtime)
        self.lbl_cycles_value.setObjectName("lbl_cycles_value")
        self.lbl_cycles_value.setText("0")
        self.lbl_cycles_value.setStyleSheet("font-size: 16px;")
        self.gridLayout_realtime.addWidget(self.lbl_cycles_value, 1, 3)
        
        self.mainLayout.addWidget(self.grp_realtime)
        
        # ===== 运动控制区域 =====
        self.grp_motion = QtWidgets.QGroupBox(self.centralwidget)
        self.grp_motion.setObjectName("grp_motion")
        self.grp_motion.setTitle("运动控制")
        self.gridLayout_motion = QtWidgets.QGridLayout(self.grp_motion)
        
        # 位置控制
        self.lbl_target_pos = QtWidgets.QLabel(self.grp_motion)
        self.lbl_target_pos.setText("目标位置 [mm]:")
        self.gridLayout_motion.addWidget(self.lbl_target_pos, 0, 0)
        
        self.spin_target_pos = QtWidgets.QDoubleSpinBox(self.grp_motion)
        self.spin_target_pos.setObjectName("spin_target_pos")
        self.spin_target_pos.setDecimals(2)
        self.spin_target_pos.setRange(-100.0, 100.0)
        self.spin_target_pos.setValue(0.0)
        self.spin_target_pos.setSingleStep(0.1)
        self.gridLayout_motion.addWidget(self.spin_target_pos, 0, 1)
        
        self.lbl_pos_speed = QtWidgets.QLabel(self.grp_motion)
        self.lbl_pos_speed.setText("移动速度 [mm/s]:")
        self.gridLayout_motion.addWidget(self.lbl_pos_speed, 0, 2)
        
        self.spin_pos_speed = QtWidgets.QDoubleSpinBox(self.grp_motion)
        self.spin_pos_speed.setObjectName("spin_pos_speed")
        self.spin_pos_speed.setDecimals(1)
        self.spin_pos_speed.setRange(0.1, 50.0)
        self.spin_pos_speed.setValue(5.0)
        self.gridLayout_motion.addWidget(self.spin_pos_speed, 0, 3)
        
        self.btn_move_to_pos = QtWidgets.QPushButton(self.grp_motion)
        self.btn_move_to_pos.setObjectName("btn_move_to_pos")
        self.btn_move_to_pos.setText("移动到位置")
        self.btn_move_to_pos.setStyleSheet("background-color: #4CAF50; color: white; font-weight: bold; padding: 8px;")
        self.gridLayout_motion.addWidget(self.btn_move_to_pos, 0, 4)
        
        # 力控制
        self.lbl_target_force = QtWidgets.QLabel(self.grp_motion)
        self.lbl_target_force.setText("目标力 [N]:")
        self.gridLayout_motion.addWidget(self.lbl_target_force, 1, 0)
        
        self.spin_target_force = QtWidgets.QDoubleSpinBox(self.grp_motion)
        self.spin_target_force.setObjectName("spin_target_force")
        self.spin_target_force.setDecimals(2)
        self.spin_target_force.setRange(-10000.0, 10000.0)
        self.spin_target_force.setValue(0.0)
        self.spin_target_force.setSingleStep(1.0)
        self.gridLayout_motion.addWidget(self.spin_target_force, 1, 1)
        
        self.lbl_force_speed = QtWidgets.QLabel(self.grp_motion)
        self.lbl_force_speed.setText("加载速度 [N/s]:")
        self.gridLayout_motion.addWidget(self.lbl_force_speed, 1, 2)
        
        self.spin_force_speed = QtWidgets.QDoubleSpinBox(self.grp_motion)
        self.spin_force_speed.setObjectName("spin_force_speed")
        self.spin_force_speed.setDecimals(1)
        self.spin_force_speed.setRange(0.1, 100.0)
        self.spin_force_speed.setValue(1.0)
        self.gridLayout_motion.addWidget(self.spin_force_speed, 1, 3)
        
        self.btn_move_to_force = QtWidgets.QPushButton(self.grp_motion)
        self.btn_move_to_force.setObjectName("btn_move_to_force")
        self.btn_move_to_force.setText("加载到目标力")
        self.btn_move_to_force.setStyleSheet("background-color: #2196F3; color: white; font-weight: bold; padding: 8px;")
        self.gridLayout_motion.addWidget(self.btn_move_to_force, 1, 4)
        
        # 快捷按钮
        self.btn_go_zero = QtWidgets.QPushButton(self.grp_motion)
        self.btn_go_zero.setObjectName("btn_go_zero")
        self.btn_go_zero.setText("回零位")
        self.gridLayout_motion.addWidget(self.btn_go_zero, 2, 0)
        
        self.btn_go_rest = QtWidgets.QPushButton(self.grp_motion)
        self.btn_go_rest.setObjectName("btn_go_rest")
        self.btn_go_rest.setText("回休息位")
        self.gridLayout_motion.addWidget(self.btn_go_rest, 2, 1)
        
        self.btn_release_force = QtWidgets.QPushButton(self.grp_motion)
        self.btn_release_force.setObjectName("btn_release_force")
        self.btn_release_force.setText("卸载力")
        self.gridLayout_motion.addWidget(self.btn_release_force, 2, 2)

        # 点动控制
        self.lbl_jog_speed = QtWidgets.QLabel(self.grp_motion)
        self.lbl_jog_speed.setText("点动速度 [mm/s]:")
        self.gridLayout_motion.addWidget(self.lbl_jog_speed, 3, 0)

        self.spin_jog_speed = QtWidgets.QDoubleSpinBox(self.grp_motion)
        self.spin_jog_speed.setObjectName("spin_jog_speed")
        self.spin_jog_speed.setDecimals(2)
        self.spin_jog_speed.setRange(0.01, 20.0)
        self.spin_jog_speed.setValue(0.50)
        self.spin_jog_speed.setSingleStep(0.05)
        self.gridLayout_motion.addWidget(self.spin_jog_speed, 3, 1)

        self.btn_jog_up = QtWidgets.QPushButton(self.grp_motion)
        self.btn_jog_up.setObjectName("btn_jog_up")
        self.btn_jog_up.setText("点动向上")
        self.btn_jog_up.setStyleSheet("background-color: #4CAF50; color: white; font-weight: bold; padding: 6px;")
        self.gridLayout_motion.addWidget(self.btn_jog_up, 3, 2)

        self.btn_jog_down = QtWidgets.QPushButton(self.grp_motion)
        self.btn_jog_down.setObjectName("btn_jog_down")
        self.btn_jog_down.setText("点动向下")
        self.btn_jog_down.setStyleSheet("background-color: #2196F3; color: white; font-weight: bold; padding: 6px;")
        self.gridLayout_motion.addWidget(self.btn_jog_down, 3, 3)

        self.btn_jog_stop = QtWidgets.QPushButton(self.grp_motion)
        self.btn_jog_stop.setObjectName("btn_jog_stop")
        self.btn_jog_stop.setText("点动停止")
        self.btn_jog_stop.setStyleSheet("background-color: #FF9800; color: white; font-weight: bold; padding: 6px;")
        self.gridLayout_motion.addWidget(self.btn_jog_stop, 3, 4)
        
        self.mainLayout.addWidget(self.grp_motion)
        
        # ===== 测量序列控制 =====
        self.grp_sequence = QtWidgets.QGroupBox(self.centralwidget)
        self.grp_sequence.setObjectName("grp_sequence")
        self.grp_sequence.setTitle("测量序列")
        self.gridLayout_seq = QtWidgets.QGridLayout(self.grp_sequence)
        
        self.lbl_seq_cycles = QtWidgets.QLabel(self.grp_sequence)
        self.lbl_seq_cycles.setText("测量循环次数:")
        self.gridLayout_seq.addWidget(self.lbl_seq_cycles, 0, 0)
        
        self.spin_seq_cycles = QtWidgets.QSpinBox(self.grp_sequence)
        self.spin_seq_cycles.setObjectName("spin_seq_cycles")
        self.spin_seq_cycles.setRange(1, 10000)
        self.spin_seq_cycles.setValue(5)
        self.gridLayout_seq.addWidget(self.spin_seq_cycles, 0, 1)
        
        self.lbl_seq_interval = QtWidgets.QLabel(self.grp_sequence)
        self.lbl_seq_interval.setText("采样间隔 [s]:")
        self.gridLayout_seq.addWidget(self.lbl_seq_interval, 0, 2)
        
        self.spin_seq_interval = QtWidgets.QDoubleSpinBox(self.grp_sequence)
        self.spin_seq_interval.setObjectName("spin_seq_interval")
        self.spin_seq_interval.setDecimals(2)
        self.spin_seq_interval.setRange(0.01, 10.0)
        self.spin_seq_interval.setValue(0.1)
        self.gridLayout_seq.addWidget(self.spin_seq_interval, 0, 3)
        
        self.lbl_sample_name = QtWidgets.QLabel(self.grp_sequence)
        self.lbl_sample_name.setText("样品名称:")
        self.gridLayout_seq.addWidget(self.lbl_sample_name, 1, 0)
        
        self.edit_sample_name = QtWidgets.QLineEdit(self.grp_sequence)
        self.edit_sample_name.setObjectName("edit_sample_name")
        self.edit_sample_name.setPlaceholderText("输入样品名称...")
        self.gridLayout_seq.addWidget(self.edit_sample_name, 1, 1, 1, 3)
        
        self.btn_start_sequence = QtWidgets.QPushButton(self.grp_sequence)
        self.btn_start_sequence.setObjectName("btn_start_sequence")
        self.btn_start_sequence.setText("开始测量序列")
        self.btn_start_sequence.setStyleSheet("background-color: #4CAF50; color: white; font-weight: bold; padding: 10px; font-size: 14px;")
        self.gridLayout_seq.addWidget(self.btn_start_sequence, 2, 0, 1, 2)
        
        self.btn_stop_sequence = QtWidgets.QPushButton(self.grp_sequence)
        self.btn_stop_sequence.setObjectName("btn_stop_sequence")
        self.btn_stop_sequence.setText("停止序列")
        self.btn_stop_sequence.setStyleSheet("background-color: #FF9800; color: white; font-weight: bold; padding: 10px; font-size: 14px;")
        self.btn_stop_sequence.setEnabled(False)
        self.gridLayout_seq.addWidget(self.btn_stop_sequence, 2, 2, 1, 2)
        
        self.mainLayout.addWidget(self.grp_sequence)
        
        # ===== 紧急停止按钮 =====
        self.btn_emergency_stop = QtWidgets.QPushButton(self.centralwidget)
        self.btn_emergency_stop.setObjectName("btn_emergency_stop")
        self.btn_emergency_stop.setText("🚨 紧急停止 🚨")
        self.btn_emergency_stop.setStyleSheet(
            "background-color: #f44336; color: white; font-weight: bold; "
            "font-size: 18px; padding: 15px; border: 3px solid darkred;"
        )
        self.mainLayout.addWidget(self.btn_emergency_stop)
        
        # ===== 日志输出区域 =====
        self.grp_log = QtWidgets.QGroupBox(self.centralwidget)
        self.grp_log.setObjectName("grp_log")
        self.grp_log.setTitle("操作日志")
        self.logLayout = QtWidgets.QVBoxLayout(self.grp_log)
        
        self.txt_log = QtWidgets.QPlainTextEdit(self.grp_log)
        self.txt_log.setObjectName("txt_log")
        self.txt_log.setReadOnly(True)
        self.txt_log.setMaximumHeight(150)
        self.logLayout.addWidget(self.txt_log)
        
        self.mainLayout.addWidget(self.grp_log)
        
        ControlPanel.setCentralWidget(self.centralwidget)
        
        self.retranslateUi(ControlPanel)
        QtCore.QMetaObject.connectSlotsByName(ControlPanel)

    def retranslateUi(self, ControlPanel):
        _translate = QtCore.QCoreApplication.translate
        ControlPanel.setWindowTitle(_translate("ControlPanel", "设备控制面板"))
