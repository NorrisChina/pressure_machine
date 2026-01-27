# DoPE DLL Documentation Summary (中文详解)

## 文档概览
- **制造商**: DOLI Elektronik GmbH (德国慕尼黑)
- **DLL版本**: 2.89
- **文档页数**: 145页
- **用途**: 材料测试仪器的数据采集和闭环控制

---

## 1. 核心概念

### 1.1 DoPE是什么？
DoPE (DOLI Programming Environment) 是一个Windows DLL，用于：
- 控制DOLI测试仪器（如拉力试验机）
- 通过RS232串口（DPX安全协议）与EDC控制器通信
- 提供SI单位的测量数据（牛顿N、米m等）
- 执行简单和复杂的运动控制命令

### 1.2 系统架构
```
应用程序 → DoPE DLL → RS232串口(DPX协议) → EDC控制器 → 传感器/执行器
```

---

## 2. **重要发现：初始化流程**

### 2.1 完整的初始化序列（这是你需要的！）

根据文档，正确的初始化流程是：

```python
# 步骤1: 打开连接
DoPEOpenLink(Port, Baudrate, RcvBuffers, XmitBuffers, DataBuffers, APIVersion, Reserved, &Handle)

# 步骤2: 设置通知机制
DoPESetNotification(Handle, EventMask, CallbackFunc, WindowHandle, MessageID)

# 步骤3: 选择并初始化Setup配置 (这是关键！)
DoPESelSetup(Handle, SetupNo, UserScale, &TANFirst, &TANLast)

# 步骤4: 现在可以发送运动命令了
DoPEFMove(Handle, MOVE_UP, 0.01)  # 向上移动，速度0.01 m/s
DoPEPos(Handle, CTRL_POS, 0.02, 0.1)  # 定位到0.1m，速度0.02 m/s
```

### 2.2 **你的问题根源**
你之前直接调用`DoPEInitialize`导致访问冲突，是因为：
1. **`DoPEInitialize`不是初始化设备的主要函数**
2. **真正的初始化函数是`DoPESelSetup`**
3. `DoPEInitialize`在文档中几乎没有详细说明，可能是内部函数

---

## 3. Setup配置系统

### 3.1 什么是Setup？
- EDC控制器内部存储了最多4个Setup配置
- 每个Setup定义：
  - 16个逻辑测量通道（传感器）
  - 16个模拟输出通道
  - 10个数字输入设备
  - 10个数字输出设备
  - 机器参数、校准数据等

### 3.2 Setup必须先用DoSE软件编辑
- DOLI提供专用软件"DoSE" (DOLI Setup Editor)
- 用DoSE配置传感器、机器参数后，数据存储到EDC的EEPROM
- 你的程序通过`DoPESelSetup`加载这些预配置

### 3.3 DoPESelSetup参数
```c
DoPESelSetup(
    DoPEHdl,           // 连接句柄
    SetupNo,           // Setup编号 (1-4)
    UserScale[],       // 用户单位缩放数组
    &TANFirst,         // 第一个事务编号
    &TANLast           // 最后一个事务编号
)
```

---

## 4. 运动控制命令（第8章）

### 4.1 可用的运动命令类别

#### 4.1.1 停止命令
- `DoPEHalt` - 立即停止
- `DoPESHalt` - 软停止
- `DoPEHaltW` - 等待停止完成

#### 4.1.2 简单定位命令
- `DoPEPos(Handle, CtrlMode, Speed, Destination)`
  - CtrlMode: `CTRL_POS`(位置控制), `CTRL_LOAD`(力控制)
  - Speed: 速度（m/s或N/s）
  - Destination: 目标值

- `DoPEFMove(Handle, Direction, Speed)`
  - Direction: `MOVE_UP`或`MOVE_DOWN`
  - Speed: 移动速度

#### 4.1.3 复杂定位命令
- `DoPEPosG1/G2` - 接近目标位置
- `DoPEPosD1/D2` - 精确定位
- `DoPEPosExt` - 扩展定位命令

#### 4.1.4 触发命令
- `DoPETrig` - 在特定条件下触发动作

#### 4.1.5 组合运动命令
- `DoPEStartCMD` / `DoPEEndCMD` - 组合多个命令

### 4.2 复杂运动命令（第9章）
- `DoPECycle` - 循环运动
- `DoPECosine` - 正弦波运动
- `DoPETriangle` - 三角波运动
- `DoPERectangle` - 矩形波运动

---

## 5. 数据处理

### 5.1 DoPEGetData - 读取测量数据
返回的数据记录包含：
- Position (位置)
- Load (载荷)
- Time (时间)
- Cycles (循环次数)
- 其他测量通道数据
- 数字输入/输出状态
- 控制器状态

### 5.2 DoPEGetMsg - 读取消息
三种消息类型：
1. **COMMAND_ERROR** - 命令参数错误
2. **RUNTIME_ERROR** - 运行时错误（如限位开关触发）
3. **MOVE_CTRL_MSG** - 运动完成消息

---

## 6. 通信机制

### 6.1 同步 vs 异步命令
- **同步命令** (带Sync后缀): 等待EDC检查参数并返回结果
- **异步命令**: 立即返回，结果稍后通过消息通知

### 6.2 通知机制
两种方式：
1. **回调函数** - 实时性好，适合关键任务
2. **Windows消息** - 简单易用，但延迟不确定

---

## 7. 关键函数详解

### 7.1 必需的初始化函数
| 函数 | DLL序号 | 用途 |
|------|---------|------|
| DoPEOpenLink | 15 | 打开串口连接 |
| DoPECloseLink | 35 | 关闭连接 |
| DoPESetNotification | 36 | 设置消息通知 |
| DoPESelSetup | 13 | **选择并加载Setup（这是初始化关键）** |

### 7.2 数据读取函数
| 函数 | DLL序号 | 用途 |
|------|---------|------|
| DoPEGetData | 19 | 读取缓冲区中的数据记录 |
| DoPECurrentData | 146 | 读取当前最新数据 |
| DoPEGetMsg | 18 | 读取消息 |

### 7.3 运动控制函数
| 函数 | 用途 |
|------|------|
| DoPEFMove | 连续移动 (向上/向下) |
| DoPEPos | 定位到指定值 |
| DoPEHalt | 停止运动 |

---

## 8. 你的问题解决方案

### 8.1 为什么数据是0？
**原因**: 设备没有正确初始化Setup配置！
- 你调用了`DoPEOpenLink`（成功）
- 但没有调用`DoPESelSetup`加载Setup
- 设备处于"连接但未初始化"状态

### 8.2 为什么没有移动控制函数？
**发现**: DLL只导出了6个函数，但文档显示应该有100+个函数！

这表明：
1. **你的DoPE.dll可能是简化版本**
2. **或者需要通过Setup配置后才能解锁其他功能**
3. **或者其他函数通过不同机制访问**

### 8.3 下一步行动

#### 方案1: 尝试DoPESelSetup（最可能）
```python
# 加载Setup 1，不使用缩放
result = DoPESelSetup(handle, 1, None, None, None)
```

#### 方案2: 检查是否有其他DLL
文档提到需要两个DLL：
- `DoPE32.DLL` - 主DLL
- `NTDPX.DLL` - 通信协议DLL

你可能需要这两个DLL。

#### 方案3: 检查DLL导出函数
使用工具（如Dependency Walker）检查DoPE.dll导出的所有函数。

---

## 9. C语言示例代码（文档第9页）

```c
#include "dope.h"

// 步骤1: 打开连接
DoPEErr = DoPEOpenLink(Port, Baudrate, 10, 10, 10, 
                        DoPEAPIVERSION, NULL, &DoPEHdl);
if(DoPEErr != DoPERR_NOERROR) {
    // 错误处理
}

// 步骤2: 设置通知
DoPEErr = DoPESetNotification(DoPEHdl, DoPEEVT_ALL, 
                               NULL, hWnd, WM_DoPEEvent);
if(DoPEErr != DoPERR_NOERROR) {
    // 错误处理
}

// 步骤3: 选择Setup并初始化 (关键步骤！)
DoPEErr = DoPESelSetup(DoPEHdl, 1, Uscale, 
                        &lpusTANFirst, &lpusTANLast);
if(DoPEErr != DoPERR_NOERROR) {
    // 错误处理
}

// 现在可以控制了
DoPEErr = DoPEFMove(DoPEHdl, MOVE_UP, 0.01);  // 向上移动
DoPEErr = DoPEPos(DoPEHdl, CTRL_POS, 0.02, 0.1);  // 定位到0.1m
```

---

## 10. 总结

### 关键发现：
1. **`DoPEInitialize`不是你需要的函数**
2. **真正的初始化是`DoPESelSetup`**
3. **Setup配置存储在EDC内部，需要先用DoSE软件配置**
4. **你的DLL可能不完整或是简化版本**

### 建议：
1. 尝试调用`DoPESelSetup`看是否能初始化设备
2. 检查是否有`NTDPX.DLL`
3. 联系DOLI获取完整DLL或Setup编辑工具
4. 检查你的设备是否已经预配置了Setup

### 运动控制命令列表：
- `DoPEFMove` - 连续移动
- `DoPEPos` - 简单定位
- `DoPEPosG1/G2` - 接近目标
- `DoPEPosD1/D2` - 精确定位
- `DoPEHalt` - 停止
- `DoPECycle` - 循环运动
- `DoPECosine` - 正弦运动

这些命令需要在`DoPESelSetup`成功初始化后才能使用！
