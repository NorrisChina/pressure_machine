# DoPE.dll 和 DoDpx.dll 文件说明

## 📋 简短回答

| 问题 | 答案 |
|------|------|
| **DoPE.dll 是什么?** | Delphi 应用的核心 DLL，控制 Hounsfield 压力传感器和 Keithley DMM |
| **DoDpx.dll 是什么?** | 底层驱动 DLL，被 DoPE.dll 调用，处理硬件串口通信 |
| **Python 启动需要吗?** | **可选** - 有 DLL = 真实硬件通信；没有 DLL = 模拟数据演示 |
| **如何选择?** | 无硬件 → 不需要放 DLL / 有硬件 → 放 DoPE.dll 到 drivers/ 或 System32 |

---

## 🏗️ 代码架构

### 原来的 Delphi 架构
```
┌─────────────────────────────────────┐
│  EinzelSensor.exe (Delphi VCL)      │
│                                     │
│  ├─ TDoPE (Delphi 类)               │
│  │  └─ DoPEOpenLink()               │
│  │  └─ DoPEGetData()                │
│  │  └─ DoPESetSensor()              │
│  │                                  │
│  ├─ TSteuerungMessung              │
│  └─ TZirkularPuffer                │
│                                     │
│  Keithley 2700 DMM ←─────────────┐ │
│  Hounsfield Sensor ←─────────────┼─┤
└─────────────────────────────────────┘
           ↓ (调用)
    ┌──────────────────┐
    │   DoPE.dll       │  ← 这是你现在问的
    │   (v2.89 API)    │
    │                  │
    │ DoPEOpenLink()   │
    │ DoPEGetData()    │
    │ DoPESetSensor()  │
    │ ...              │
    └────────┬─────────┘
             ↓ (调用)
    ┌──────────────────┐
    │   DoDpx.dll      │  ← 这是你现在问的
    │ (底层驱动)        │
    │                  │
    │ 串口通信          │
    │ 波特率控制        │
    │ 数据解析          │
    └────────┬─────────┘
             ↓
    ┌──────────────────┐
    │   Windows COM    │
    │   serial port    │
    │   API            │
    └────────┬─────────┘
             ↓
    ┌──────────────────┐
    │  USB/RS-232      │
    │                  │
    │  Keithley ──────┤
    │  Hounsfield ───┤
    │  Motor ───────┤
    └──────────────────┘
```

### 现在的 Python 架构
```
┌─────────────────────────────────────┐
│  start.py                           │
│  (Python 入口点)                    │
└────────────────┬────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│  ui/app.py (PySide6)                │
│  MainWindow 类                      │
│                                     │
│  按钮: Init Keithley, Init Hounsfield
│  显示: 实时数据                     │
└────────────────┬────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│  drivers/dope_driver.py             │
│  DopeDriver 类 (ctypes 包装)        │
│                                     │
│  open_link()   ←─ Python 调用       │
│  get_data()    ←─ Python 调用       │
│  set_sensor()  ←─ Python 调用       │
└────────────────┬────────────────────┘
                 ↓
    ┌──────────────────────┐
    │ DoPE.dll (可选)      │
    │                      │
    │ 如果存在:            │
    │ • Python 调用 ctypes │
    │ • ctypes 调用 DLL    │
    │ • DLL 控制硬件       │
    │                      │
    │ 如果不存在:          │
    │ • 跳过 DLL 加载       │
    │ • 切换到 Stub Driver │
    │ • 返回模拟数据       │
    └──────────────────────┘
             ↓ (如果存在)
    ┌──────────────────┐
    │   DoDpx.dll      │
    │ (被 DoPE 使用)    │
    └────────┬─────────┘
             ↓
       硬件通信
```

---

## 📝 文件详细说明

### DoPE.dll (主要 API)

**文件大小:** ~100-500 KB  
**版本:** v2.89 (0x0289)  
**来源:** DOPE GmbH (德国)  
**功能:** 

| 函数 | 用途 | 对应 Python |
|------|------|-----------|
| `DoPEOpenLink()` | 连接到硬件 | `driver.open_link()` |
| `DoPECloseLink()` | 断开连接 | `driver.close()` |
| `DoPEGetData()` | 读取传感器数据 | `driver.get_data()` |
| `DoPESetSensor()` | 选择传感器 | `driver.set_sensor()` |
| `DoPEPos()` | 移动到指定位置 | `driver.move_to_position()` |
| `DoPESetNotification()` | 设置事件回调 | `driver.set_notification()` |
| `DoPESetTime()` | 设置测试时间 | `driver.set_time()` |

**包含内容:**
- Hounsfield 传感器通信协议
- Keithley 2700 DMM 查询命令
- 运动控制算法
- 数据解析和缓冲
- 实时事件系统

---

### DoDpx.dll (底层驱动)

**文件大小:** ~50-200 KB  
**功能:** 

| 功能 | 说明 |
|------|------|
| Windows COM 端口管理 | 打开、配置、关闭串口 |
| 波特率控制 | 设置 9600, 19200 等速度 |
| 数据帧处理 | 帧同步、校验和验证 |
| 缓冲管理 | 接收/发送缓冲 (RxBuf, TxBuf) |
| 中断处理 | Windows 事件通知 |

**依赖关系:**
```
DoPE.dll 内部调用:
  ├─ DoPx_Init()
  ├─ DoPx_OpenPort()
  ├─ DoPx_SendData()
  ├─ DoPx_ReceiveData()
  └─ DoPx_Close()
```

---

## ⚙️ Python 启动时发生的事

### 场景 1: DLL 存在（有硬件）

```python
# 步骤 1: start.py 启动应用
python start.py

# 步骤 2: ui/app.py 创建 MainWindow
from drivers.dope_driver import DopeDriver
driver = DopeDriver()  # 自动查找 DoPE.dll

# 步骤 3: DopeDriver.__init__() 尝试加载 DLL
#   • 检查 drivers/DoPE.dll (项目目录)
#   • 检查 System32/DoPE.dll (Windows 系统目录)
#   • 检查 PATH 环境变量中其他位置
#   → 找到 DoPE.dll → 加载成功 ✅

# 步骤 4: 用户点击 "Init Keithley"
app.start()
  ↓
driver.open_link(port=3, baudrate=9600, ...)
  ↓
ctypes 调用 DoPE.dll 中的 DoPEOpenLink()
  ↓
DoPE.dll 调用 DoDpx.dll 初始化串口
  ↓
DoDpx.dll 调用 Windows COM API
  ↓
串口打开，通信建立 ✅

# 步骤 5: 定时器每 500ms 读取一次数据
_poll()
  ↓
driver.get_data()
  ↓
ctypes 调用 DoPE.dll 中的 DoPEGetData()
  ↓
DoPE.dll 通过 DoDpx.dll 读取串口数据
  ↓
返回 DoPEData 结构 (Cycles, Time, Position, Load, ...)
  ↓
UI 显示实时数据 ✅
```

### 场景 2: DLL 不存在（无硬件或演示模式）

```python
# 步骤 1-2: 同上

# 步骤 3: DopeDriver.__init__() 尝试加载 DLL
#   • 检查 drivers/DoPE.dll → 不存在 ❌
#   • 检查 System32/DoPE.dll → 不存在 ❌
#   • 检查 PATH → 不存在 ❌
#   → 加载失败，self.dll = None

# 步骤 4: driver.loaded() == False
#   → ui/app.py 检测到 DLL 未加载
#   → 自动切换到 StubDriver
#   → 打印 "Using StubDriver (DLL not available)"

# 步骤 5: 模拟数据流程
_poll()
  ↓
stub_driver.get_data()
  ↓
生成随机数据 (Time += 0.05s, Position ± random, Load ± random, ...)
  ↓
返回模拟 DoPEData
  ↓
UI 显示模拟数据 ✅
```

---

## 🚀 实际使用场景

### 场景 A: 测试阶段（无真实硬件）

**不需要 DLL**

```bash
# 直接运行，Python 自动使用模拟数据
python start.py

# UI 出现，数据是随机生成的
# 用于测试 UI 逻辑、按钮响应等
```

**为什么有用:**
- ✅ 测试 UI 功能无需硬件
- ✅ 快速迭代 UI 设计
- ✅ 验证数据处理逻辑
- ✅ 团队协作时不需要所有人都有硬件

---

### 场景 B: 真实测试（有硬件）

**需要放置 DLL**

```bash
# 方式 1: 放到项目目录
cp DoPE.dll C:\Users\cho77175\Desktop\code\drivers\
python start.py
# ✅ 工作

# 方式 2: 放到 Windows 系统目录
cp DoPE.dll C:\Windows\System32\
python start.py
# ✅ 工作

# 方式 3: 放到 PATH 中的某个目录
setx PATH "%PATH%;C:\Path\To\DLLs"
python start.py
# ✅ 工作
```

**关键步骤:**
1. 复制 DoPE.dll 到某个位置
2. 运行 `python start.py`
3. 点击 "Init Keithley" 按钮
4. 观察 Log 输出
   - ✅ 成功: `"DoPEOpenLink OK, handle=0x12345678"`
   - ❌ 失败: `"DoPEOpenLink error: XXXX"` 或 `"DLL not found"`

---

## 🔍 诊断：DLL 是否被加载？

### 方式 1: 检查 Python Log

运行 Python 代码：
```python
from drivers.dope_driver import DopeDriver

driver = DopeDriver()
if driver.loaded():
    print("✅ DoPE.dll 已加载")
    print(f"DLL 路径: {driver.dll_path}")
else:
    print("❌ DoPE.dll 未加载，使用 StubDriver")
```

### 方式 2: 用 PowerShell 检查文件

```powershell
# 检查项目目录
Test-Path "C:\Users\cho77175\Desktop\code\drivers\DoPE.dll"

# 检查 System32
Test-Path "C:\Windows\System32\DoPE.dll"

# 查找所有 DoPE.dll
Get-ChildItem -Path "C:\" -Name "DoPE.dll" -Recurse -ErrorAction SilentlyContinue
```

### 方式 3: 运行 UI 并观察

```bash
python start.py
```

查看窗口 Log 栏：
```
Verbindung: getrennt
Using StubDriver (DLL not available)
  ← 如果看到这个，说明 DLL 未加载

或

Verbindung: verbunden (100%)
DoPEOpenLink OK
  ← 如果看到这个，说明 DLL 已加载
```

---

## 💾 文件放置指南

### 最简单的方式（推荐）

```
C:\Users\cho77175\Desktop\code\
├─ drivers/
│  ├─ DoPE.dll          ← 放这里
│  ├─ dope_driver.py
│  ├─ dope_dll_interface.py
│  └─ ...
├─ start.py
└─ ...
```

**操作:**
```powershell
# 假设你有 DoPE.dll 文件
Copy-Item "C:\path\to\DoPE.dll" "C:\Users\cho77175\Desktop\code\drivers\"
```

**检查:**
```powershell
ls C:\Users\cho77175\Desktop\code\drivers\DoPE.dll
```

---

### 备选方式（System32）

```powershell
# 需要管理员权限
Copy-Item "C:\path\to\DoPE.dll" "C:\Windows\System32\" -Force
```

**优点:** Python 会自动找到  
**缺点:** 需要管理员权限，可能影响其他程序

---

## 📊 对比表：有无 DLL

| 特性 | 有 DLL | 无 DLL |
|------|--------|--------|
| **UI 启动** | ✅ 快速 | ✅ 快速 |
| **数据来源** | 真实硬件 | 随机生成 |
| **需要硬件** | ✅ 必需 | ❌ 不需要 |
| **波特率设置** | 从 ini 读取 | 无所谓 |
| **Keithley** | 真实连接 | 模拟数据 |
| **Hounsfield** | 真实传感器 | 模拟值 |
| **性能** | 取决于硬件 | 快速 (全 CPU) |
| **用途** | 生产测试 | 开发测试 |
| **依赖** | DoPE.dll + DoDpx.dll | 仅 Python |

---

## 🎯 总结与建议

### 你应该做什么？

#### 选项 A: 快速开始（推荐）
```bash
# 1. 不做任何事，直接运行
python start.py

# 2. 看到模拟数据 → UI 工作正常
# 3. 测试所有按钮功能
# 4. 确认 UI 符合需求
```

**用处:** 验证 Python/PySide6 代码正确性

---

#### 选项 B: 连接真实硬件
```bash
# 1. 获取 DoPE.dll (从原始 Delphi 安装或 DOPE GmbH)
# 2. 复制到 drivers/ 目录
cp DoPE.dll drivers/

# 3. 运行应用
python start.py

# 4. 点击初始化按钮测试硬件连接
```

**用处:** 真实测量和数据采集

---

#### 选项 C: 同时支持两者
```python
# 在 ui/app.py 中
try:
    driver = DopeDriver()
    if driver.loaded():
        print("Real hardware mode")
    else:
        print("Demo mode (no hardware)")
except:
    print("Demo mode (error)")
```

**用处:** 开发时用模拟，测试时用真实

---

### DLL 文件清单

你需要以下文件（用于真实硬件）:
```
□ DoPE.dll      (主要文件，必需)
□ DoDpx.dll     (可选，通常 DoPE.dll 内部自动加载)
```

**如何获取:**
- ✅ 从原始 Delphi EinzelSensor.exe 安装目录复制
- ✅ 从 DOPE GmbH 官网下载
- ✅ 从系统 PATH 中查找
- ❌ 不需要下载 (Python 代码已完整)

---

## 📞 故障排查

| 问题 | 症状 | 解决方案 |
|------|------|--------|
| **DLL 未找到** | Log: "DLL not available" | 放置 DoPE.dll 到 drivers/ 或 System32 |
| **DLL 版本不匹配** | 崩溃或数据错误 | 确保 DLL 版本是 2.89 (0x0289) |
| **串口权限** | 连接失败 | 以管理员运行 Python |
| **硬件未连接** | DLL OK 但无数据 | 检查 USB/RS-232 连接和设备管理器 |

---

## ✅ 你现在可以做什么

```bash
# 立即测试（无需 DLL）
python start.py

# 预期结果：
# ✅ UI 窗口打开
# ✅ Log 显示 "Using StubDriver"
# ✅ 可点击所有按钮
# ✅ 看到模拟数据流动
```

**下一步（当你有 DLL 时）:**
```bash
# 1. 获取 DoPE.dll
# 2. 放到 drivers/
# 3. 重新运行 python start.py
# 4. 观察 Log 是否显示 "DoPEOpenLink OK"
```

