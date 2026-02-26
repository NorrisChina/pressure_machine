# DoPE 系统工作流程梳理

## 原始流程 (Delphi EinzelSensor.exe)
```
硬件层
  ├─ Hounsfield 压力传感器 (串口/USB) -> 力数据
  ├─ Keithley 2700 DMM (串口/GPIB/USB) -> 电阻(Ub)数据
  └─ 运动控制器 (串口) -> 位置反馈

↓ 串口驱动 / 仪器通讯

DoPE.dll / DoDpx.dll
  ├─ DoPEOpenLink() -> 初始化所有连接
  ├─ DoPEGetData() -> 轮询读取数据
  ├─ DoPEPos() -> 控制位置/力
  └─ DoPESetNotification() -> 回调/事件处理

↓ 业务逻辑

Delphi 应用 (EinzelSensor.exe)
  ├─ 初始化对话框 (Init Keithley, Init Hounsfield)
  ├─ 测量面板 (选择传感器、力周期、数据采集)
  ├─ 循环缓冲 (ZirkularPuffer - 环形缓冲)
  └─ 数据输出 (csv/显示)

↓ UI

Delphi VCL 窗体
  ├─ 初始化设备按钮
  ├─ 实时数据显示
  ├─ 测量参数输入
  └─ 图表绘制
```

## 新流程 (Python PySide6)

### 硬件连接未变
```
Hounsfield 压力传感器 ──┐
Keithley 2700 DMM ──┼─→ DoPE.dll
运动控制器 ──────┘
```

### 入口和启动步骤

#### 1. 启动应用
```bash
python start.py
```
或
```bash
C:/Users/cho77175/Desktop/code/.venv/Scripts/python.exe start.py
```

#### 2. 主窗口显示
```
┌─────────────────────────────────────────────────────┐
│ DoPE Controller                                     │
├─────────────────────────────────────────────────────┤
│ [Initialisierung Geräte]                           │
│  ┌─ Init Keithley 2700  [按钮]                     │
│  ├─ Init Hounsfield    [按钮]                      │
│  ├─ Verbindung: [进度条] [状态标签]                │
│  └─ ...                                            │
│                                                     │
│ [Messung der Sensoren]                            │
│  ├─ Messung Start [按钮]                          │
│  ├─ 实时数据显示 (Zeit, Position, Kraft, Ub)      │
│  └─ ...                                            │
│                                                     │
│ [Log 输出]                                         │
└─────────────────────────────────────────────────────┘
```

#### 3. 设备初始化流程
```
用户点击 "Init Keithley 2700"
  ↓
ui/app.py: MainWindow.start()
  ↓
drivers/dope_driver.py: open_link()
  ↓
DoPE.dll: DoPEOpenLink()
  ├─ 枚举串口
  ├─ 自动检测 Keithley 2700
  ├─ 加载配置 (EinzelSensor.ini)
  └─ 返回连接状态
  ↓
UI 更新:
  ├─ 进度条显示 100%
  ├─ 状态文本: "Verbindung: verbunden"
  ├─ Log: "Keithley 2700 initialized"
  └─ 按钮状态更新
```

#### 4. 数据采集流程
```
用户点击 "Messung Start"
  ↓
_start_poll() 启动定时器 (500ms 间隔)
  ↓
定时器触发 _poll()
  ├─ driver.get_data() 调用 DoPEGetData()
  │   ├─ 读取 Hounsfield 力数据
  │   ├─ 读取 Keithley 电阻数据
  │   └─ 返回 DoPEData 结构体
  │
  ├─ 显示在 UI:
  │   ├─ edit_time.setText(timestamp)
  │   ├─ edit_pos.setText(position)
  │   ├─ edit_kraft.setText(load)
  │   └─ edit_ub.setText(resistance)
  │
  ├─ 记录到缓冲:
  │   └─ driver.data_buffer.append(data)
  │
  └─ 更新进度条:
      └─ progress_conn.setValue(100)
```

## 文件结构

```
c:\Users\cho77175\Desktop\code\
├─ start.py                          # 主入口 ← 用户运行这个
├─ ui/
│  ├─ app.py                        # PySide6 主窗口
│  ├─ main_window.ui                # Qt Designer 布局 (XML)
│  └─ main_window_ui.py             # 生成的 UI 类
├─ drivers/
│  ├─ dope_driver.py                # 真实/Stub 驱动选择
│  ├─ dope_driver_real.py           # 真实 DLL 实现 (NEW)
│  ├─ dope_dll_interface.py         # DLL 函数定义 (NEW)
│  ├─ stub_driver.py                # 模拟驱动
│  └─ programm_dope_translated.py   # 业务逻辑
├─ config/
│  └─ dope_config.py                # 配置加载器 (NEW)
├─ EinzelSensor.ini                 # 配置文件 (从 Delphi 复用)
└─ tests/
   └─ ...
```

## 关键函数调用链

### 初始化设备
```python
# start.py 入口
from ui.app import run_app
run_app()

# ui/app.py
class MainWindow(QtWidgets.QMainWindow):
    def start(self):
        """Init Keithley 或 Init Hounsfield 按钮点击"""
        self._ensure_driver()           # 选择真实驱动或 Stub
        driver.open_link()              # 调用 DoPE DLL
        self._update_progress(True)     # 更新 UI
        self._timer.start()             # 启动数据轮询

# drivers/dope_driver.py (抽象层)
class DopeDriver:
    def open_link(self) -> bool:
        """选择使用哪个驱动实现"""
        if use_real_dll:
            from drivers.dope_driver_real import DoPeDriver
            self._real_driver = DoPeDriver()
            return self._real_driver.open_link()
        else:
            from drivers.stub_driver import StubDopeDriver
            self._stub_driver = StubDopeDriver()
            return self._stub_driver.open_link()

# drivers/dope_driver_real.py (真实实现)
class DoPeDriver:
    def open_link(self) -> bool:
        """调用 DoPE.dll"""
        if not self.dll.loaded:
            return False
        # DoPE.dll 内部处理:
        # 1. 枚举 COM 端口
        # 2. 初始化 Hounsfield 通讯
        # 3. 初始化 Keithley 通讯
        # 4. 加载 EinzelSensor.ini 配置
        self.is_connected = True
        return True
```

## 串口通讯细节

### Hounsfield 压力传感器
```
串口参数 (通常)
  ├─ 波特率: 9600
  ├─ 数据位: 8
  ├─ 停止位: 1
  └─ 校验: None

协议 (基于 DoPE 标准)
  ├─ 查询: CMD_READFORCE
  ├─ 响应: DoPEData.Load [N]
  └─ 周期: ~10ms (DoPE 内部)

在 EinzelSensor.ini 中配置
  └─ [SoftLimits] LimitX4Min/Max 等
```

### Keithley 2700 DMM
```
连接方式 (3 选 1)
  ├─ GPIB (IEEE-488)
  ├─ RS-232 (COM 口)
  └─ USB-GPIB 转换器

初始化 (DoPE 内部)
  ├─ 识别设备
  ├─ 配置测量模式 (电阻/电压)
  ├─ 设置量程
  └─ 启动扫描

数据格式
  └─ DoPEData.Sensor[] 或 edit_ub (毫伏)
```

## 配置文件角色

### EinzelSensor.ini
```ini
[Forms]
Width=897          # 窗口宽度
Height=597         # 窗口高度

[Grenzen]
MinGrenzenEmpf=2   # 传感器最小增益
MaxGrenzenEmpf=8   # 传感器最大增益

[SoftLimits]
LimitX4Min=-34     # X 轴最小位置 [mm]
LimitX4Max=31      # X 轴最大位置 [mm]

[AusgabeBiegung]
BooKraftMin=0      # 力最小输出标志
```

读取方式:
```python
from config.dope_config import get_dope_config
config = get_dope_config("path/to/EinzelSensor.ini")
limit_min = config.get_soft_limit("LimitX4Min", -34.0)
```

## 故障排查

### 问题: "DoPE DLL not loaded"
```
原因: 系统找不到 DoPE.dll
解决:
  1. 确保 DoPE.dll 或 DoDpx.dll 在:
     ├─ 系统路径 (C:\Windows\System32)
     ├─ 应用文件夹
     └─ drivers/ 文件夹
  2. 检查 DLL 架构 (32/64 位)
  3. 运行 Python -c "import ctypes; ctypes.CDLL('DoPE.dll')"
```

### 问题: "连接失败，无法读取数据"
```
原因: 硬件未连接或串口错误
解决:
  1. 检查 Hounsfield/Keithley 是否已连接
  2. 使用 Windows 设备管理器确认 COM 口
  3. 检查 EinzelSensor.ini 中的串口配置
  4. 尝试运行 EinzelSensor.exe (Delphi 版) 验证硬件
```

### 问题: "UI 响应缓慢"
```
原因: 数据轮询间隔太短
解决:
  1. 在 ui/app.py 中调整 _timer.setInterval(500)
  2. 降低日志输出频率
  3. 异步化数据读取
```

## 下一步行动

1. ✅ 创建 start.py 入口
2. ✅ 创建 PySide6 UI 和布局
3. ✅ 创建配置加载器
4. ✅ 创建 DLL 接口定义
5. ⏳ **测试 start.py 启动和 UI 显示**
6. ⏳ **放置 DoPE.dll 到项目文件夹**
7. ⏳ **运行初始化和连接测试**
8. ⏳ **实现串口检测和自动配置**
9. ⏳ **集成 Hounsfield 和 Keithley 通讯**
10. ⏳ **实现数据录制和导出**
