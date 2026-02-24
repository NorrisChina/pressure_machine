# 快速启动指南

## 1. 启动 UI

### 方式 A: 命令行 (推荐)
```bash
cd C:\Users\cho77175\Desktop\code
C:/Users/cho77175/Desktop/code/.venv/Scripts/python.exe start.py
```

### 方式 B: 用 Windows 资源管理器
```
打开: C:\Users\cho77175\Desktop\code
双击: start.py
```

### 方式 C: PowerShell
```powershell
C:/Users/cho77175/Desktop/code/.venv/Scripts/python.exe start.py
```

---

## 2. UI 主窗口功能

### 初始化面板 (Initialisierung Geräte)

| 按钮 | 功能 | 对应硬件 |
|------|------|--------|
| **Init Keithley 2700** | 初始化电阻测量仪 | Keithley 2700 DMM |
| **Init Hounsfield** | 初始化压力传感器 | Hounsfield |
| **Bewegung Ein** | 启动运动 | 电机/控制器 |
| **Bewegung Halt** | 停止运动 | 电机/控制器 (红色紧急停止) |
| **def Startposition** | 设置起始位置 | 记录当前位置 |
| **Gehe Pos Ruhe** | 返回休息位置 | 移动到预设位置 |

**连接状态指示:**
```
┌────────────────────────────────────────┐
│ Verbindung: getrennt   [====    ] 0%   │  ← 未连接
└────────────────────────────────────────┘

┌────────────────────────────────────────┐
│ Verbindung: verbunden  [==========] 100%│  ← 已连接
└────────────────────────────────────────┘
```

---

### 测量面板 (Messung der Sensoren)

| 输入/显示 | 说明 | 单位 |
|----------|------|------|
| **Sensor Nr** | 选择要测量的传感器 | 无 (0-4) |
| **Zeit** | 测量时间 | s |
| **Position** | 当前位置 | mm |
| **Kraft** | 当前力值 | N |
| **Ub [mV]** | 电压/电阻值 | mV |
| **Startkraft [N]** | 初始力设置 | N |
| **dF [N/s]** | 力变化率 | N/s |
| **Kraftstufen** | 多级力设置 | CSV 格式 |
| **Nennkraft (FS)** | 标称力 | N |
| **Zyklen** | 循环次数 | 无 |

**测量按钮:**
```
[annähern] [Kontrolle] [Messung Start] [Datei] [Datei] [Stop]
  靠近      验证          开始测量       保存   保存    停止
```

---

## 3. 连接流程示例

### 场景 A: 测量压力和电阻 (完整流程)

```
第 1 步: 启动应用
  → python start.py
  → 显示主窗口

第 2 步: 初始化设备
  → 点击 [Init Keithley 2700]
    ├─ DLL 打开连接
    ├─ 自动检测 COM 口
    ├─ Log 显示: "Keithley 2700 initialized"
    └─ 进度条: 0% → 100%
  
  → 点击 [Init Hounsfield]
    ├─ DLL 打开连接
    ├─ 加载 EinzelSensor.ini 配置
    ├─ Log 显示: "Hounsfield initialized"
    └─ 进度条: 100%

第 3 步: 设置参数 (在 "Messung der Sensoren" 面板)
  → Sensor Nr: 选择 "1" (10kN 力传感器)
  → Startkraft: 输入 0.8 N
  → dF: 输入 2.0 N/s
  → Nennkraft: 输入 25 N
  → Zyklen: 输入 3
  → Kraftstufen: "0.5,10,15,20,25,20,15,10,5" (已预填)

第 4 步: 启动测量
  → 点击 [Messung Start]
    ├─ _start_poll() 启动定时器
    ├─ 定时器每 500ms 读取一次数据
    ├─ 显示实时数据:
    │  ├─ Zeit: 0.523 s
    │  ├─ Position: 12.34 mm
    │  ├─ Kraft: 15.67 N
    │  └─ Ub [mV]: 245.8 mV
    ├─ Log 窗口滚动输出
    └─ 进度条持续更新

第 5 步: 监控数据
  → Log 输出例子:
    "Cycles=0 Time=0.523 Pos=12.34 Load=15.67 Ext=0.0 SD=0.0 Sensors=[245.8, ...]"
    "flags: DoPEEVT_DATAVAIL"
    "Cycles=1 Time=1.045 Pos=12.35 Load=15.68 ..."

第 6 步: 停止测量
  → 点击 [Stop]
    ├─ 定时器停止
    ├─ 连接保持打开
    ├─ 数据保存在内存缓冲
    └─ Log: "Stop pressed"

第 7 步: 导出数据 (可选)
  → 在 "Messung der Sensoren" 勾选 [Datei]
  → 数据自动保存到 CSV
  → 文件位置: output/ 目录
```

---

### 场景 B: 快速诊断 (Stub 模式 - 无硬件)

```
第 1 步: 启动应用
  → python start.py

第 2 步: 点击 [Init Keithley 2700]
  → 检测到 DLL 未加载
  → 自动切换到 Stub 驱动
  → Log: "Using StubDopeDriver (DLL not available)"
  → 进度条: 100% (模拟数据)

第 3 步: 点击 [Messung Start]
  → 定时器启动
  → 模拟数据出现在 UI:
    ├─ Zeit: 递增
    ├─ Position: 随机 ±20mm
    ├─ Kraft: 随机 0-50N
    ├─ Ub: 随机电压

第 4 步: 验证 UI 功能
  → 检查所有按钮是否响应
  → 检查日志输出是否正常
  → 无需硬件即可测试 UI 逻辑
```

---

## 4. 数据文件位置

### 输入文件
```
C:\Users\cho77175\Desktop\code\EinzelSensor.ini
  └─ 配置文件 (波特率、限值等)
```

### 输出文件
```
C:\Users\cho77175\Desktop\code\output\
  ├─ messung_YYYY-MM-DD_HH-MM-SS.csv
  ├─ messung_YYYY-MM-DD_HH-MM-SS.csv
  └─ ...
```

### CSV 格式
```csv
Cycles,Time[s],Position[mm],Load[N],Extension[mm],SensorD,CtrlStatus,Sensor0,...
0,0.523,12.34,15.67,0.0,0.0,0x0001,245.8,...
1,1.045,12.35,15.68,0.01,0.0,0x0001,245.9,...
2,1.567,12.36,15.69,0.02,0.0,0x0001,246.0,...
...
```

---

## 5. 故障排查

### Q1: 启动时出现 "ModuleNotFoundError"
```
错误: ModuleNotFoundError: No module named 'PySide6'

解决:
  1. 激活虚拟环境:
     C:/Users/cho77175/Desktop/code/.venv/Scripts/activate
  
  2. 安装依赖:
     pip install PySide6 pyqtgraph configparser
  
  3. 重新运行:
     python start.py
```

### Q2: UI 窗口打不开
```
错误: Display not found / No display available

原因: 运行在无 GUI 的环境 (远程 SSH)

解决:
  1. 确保运行在本地 Windows 桌面
  2. 检查 GPU/驱动是否正常
  3. 尝试: python -c "from PySide6 import QtWidgets; print('OK')"
```

### Q3: "DoPE DLL not loaded"
```
错误: DLL 初始化失败

原因: DoPE.dll 或 DoDpx.dll 不在系统路径

解决:
  1. 复制 DLL 到项目:
     C:\Users\cho77175\Desktop\code\drivers\DoPE.dll
  
  2. 或复制到系统目录:
     C:\Windows\System32\DoPE.dll
  
  3. 或在代码中指定路径:
     driver = DoPeDriver(dll_path="C:\\path\\to\\DoPE.dll")
```

### Q4: 连接后无数据
```
错误: 进度条显示 100%，但无 Log 输出

原因: 硬件未连接或波特率错误

解决:
  1. 检查 Hounsfield 和 Keithley 的电源和连接
  2. 用 Windows 设备管理器检查 COM 口号
  3. 验证 EinzelSensor.ini 中的波特率设置
  4. 用 Delphi 版 EinzelSensor.exe 验证硬件是否正常
```

---

## 6. 常见设置

### 改变定时器间隔 (数据采集频率)
```python
# ui/app.py, MainWindow.__init__() 中:
self._timer.setInterval(500)  # 500ms (当前)
# 改为:
self._timer.setInterval(100)  # 100ms (更快)
self._timer.setInterval(1000) # 1000ms (更慢)
```

### 改变窗口大小
```python
# ui/app.py, MainWindow.__init__() 中:
self.resize(800, 600)
# 改为:
self.resize(1024, 768)
# 或从 EinzelSensor.ini 读取:
width = config.get_form_size("Width", 980)
height = config.get_form_size("Height", 720)
self.resize(width, height)
```

### 改变默认传感器
```python
# ui/app.py, MainWindow.start() 中:
# 默认: Sensor 1 (10kN)
# 改为 Sensor 4 (100N/1kN):
if hasattr(self.driver, 'set_sensor'):
    self.driver.set_sensor(4)
```

---

## 7. 文件树

```
C:\Users\cho77175\Desktop\code\
│
├─ start.py                          ← 这是你运行的文件
│
├─ ui/
│  ├─ __init__.py
│  ├─ app.py                        ← PySide6 主窗口
│  ├─ main_window.ui                ← Qt Designer 布局
│  └─ main_window_ui.py             ← 自动生成的 UI 代码
│
├─ drivers/
│  ├─ __init__.py
│  ├─ dope_driver.py                ← 驱动选择 (真实 or Stub)
│  ├─ dope_driver_real.py           ← 真实 DLL 实现
│  ├─ dope_dll_interface.py         ← DLL 函数定义
│  ├─ stub_driver.py                ← 模拟驱动
│  ├─ programm_dope_translated.py   ← 业务逻辑
│  └─ (DoPE.dll)                    ← 放这里或 System32
│
├─ config/
│  ├─ __init__.py
│  └─ dope_config.py                ← 配置加载器
│
├─ output/                           ← CSV 输出文件夹
│  └─ (空)
│
├─ EinzelSensor.ini                 ← 配置文件 (从 Delphi 复用)
├─ Programm_DOPE.xlsx               ← 文档
├─ Seriell-DLL-DOPE.pdf             ← DLL 文档
│
├─ WORKFLOW.md                       ← 详细工作流 (你在这里)
├─ README.md                         ← 快速入门指南
├─ tests/                            ← 单元测试
│  └─ ...
│
└─ .venv/                            ← Python 虚拟环境
   └─ ...
```

---

## 8. 下一步

1. **测试启动:** `python start.py`
2. **放置 DLL:** 将 DoPE.dll 复制到 `drivers/` 或 `System32`
3. **验证硬件:** 用设备管理器检查 COM 口
4. **运行初始化:** 点击按钮测试连接
5. **采集数据:** 点击 "Messung Start" 开始测量

---

## 9. 常见命令

```bash
# 启动应用
python start.py

# 运行测试
python -m pytest tests/

# 查看虚拟环境中的包
pip list

# 安装新包
pip install package_name

# 查看 Python 版本
python --version

# 测试 DoPE.dll 加载
python -c "import ctypes; d=ctypes.CDLL('DoPE.dll'); print('DLL OK')"
```

---

## 总结

**原来的流程:**
```
EinzelSensor.exe (Delphi) → DoPE.dll → 硬件
```

**现在的流程:**
```
start.py (Python) → ui/app.py (PySide6) → drivers/ → DoPE.dll → 硬件
  ↑
  用户运行这个
```

**关键变化:**
- ✅ UI 从 Delphi VCL 改为 PySide6
- ✅ 业务逻辑保留在 Python
- ✅ DoPE.dll 仍然是核心 (C++)
- ✅ EinzelSensor.ini 配置文件复用
- ⏳ 需要放置 DoPE.dll

**测试清单:**
- [ ] 启动 UI
- [ ] 初始化 Keithley
- [ ] 初始化 Hounsfield
- [ ] 采集测试数据
- [ ] 验证数据输出

