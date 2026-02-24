# DOPE 仪器测试场景（详细）

本文件列出应在 Stub 驱动和真实硬件两种情形下进行的测试场景、步骤与判定标准。

---

## 场景 1：自动化单元测试
- **目的**：验证代码逻辑（缓冲、事件、序列、缩放等）是否正确。
- **前置条件**：虚拟环境激活，依赖安装。
- **执行**：
```powershell
& .\.venv\Scripts\python.exe -m unittest discover tests -v
```
- **期望**：所有测试通过（OK）。

---

## 场景 2：UI + Stub 驱动交互（功能测试）
- **目的**：验证 UI、日志、显示与序列控制在离线模拟下工作。
- **前置条件**：无 DLL，使用内置 `StubDopeDriver`。
- **执行步骤**：
  1. 启动 UI：`& .\.venv\Scripts\python.exe -m demo.ui_demo`。
  2. 点击 `Start`，观察日志（应显示使用 Stub 驱动并打印样本）。
  3. 点击 `Start Sequence`（默认 5 cycles），观察 `Sequence finished`。 
- **期望结果**：日志有样本、传感器标签更新、序列完成。 

---

## 场景 3：DLL 加载验证（静态）
- **目的**：确认 `DOPE32.DLL` 能被 Python wrapper 加载和识别。
- **前置条件**：将 `DOPE32.DLL` 放入项目目录或系统路径。
- **执行步骤**：
```powershell
& .\.venv\Scripts\python.exe -c "from drivers.dope_driver import DopeDriver; d=DopeDriver(); print('loaded', d.loaded())"
```
- **期望结果**：返回 `True` 表示已加载；否则继续使用 Stub。  
- **备注**：加载成功不等于结构/签名正确，仍需现场验证各函数行为。

---

## 场景 4：事件/状态机集成测试
- **目的**：验证驱动事件（DATA_AVAILABLE、CTRL_MOVE 等）能正确驱动 `TSteuerungAblauf` 状态机。
- **前置条件**：可用的 Stub 或真实驱动（建议先用 Stub）。
- **执行步骤**：
  - 在 UI 或 REPL 中创建 `TSteuerungAblauf(driver=...)` 并 `start_loop()`。
  - 观察 `lbl_state` 在 `CTRL_MOVE` 时变为 `RUNNING`，在序列完成或空闲时变为 `FINISH/IDLE`。
- **期望**：状态变化符合事件触发。

---

## 场景 5：测量循环与缓冲一致性
- **目的**：验证 `TSteuerungMessung` 将样本写入 `TZirkularPuffer`，并且 `start_measurement_sequence` 收集到预期数。
- **步骤**：
  - 使用 Stub，调用 `start_measurement_sequence(cycles=N, interval=t)`。
  - 检查返回值及 `read_buffer()` 的长度。
- **期望**：返回值等于 N，缓冲长度为 N。

---

## 场景 6：序列超时与错误处理
- **目的**：在无事件到来时，系统能标记超时并进入 `STATE_ERROR`。
- **步骤**：
  - 设置 `ctrl._seq_timeout` 为较小值（例如 0.05），调用 `start_sequence(cycles=10)`，不发送任何 `CTRL_MOVE`。 
  - 等待超时，观察 `STATE_ERROR` 与日志 `Sequence error: {'reason': 'timeout'}`。
- **期望**：超时后进入 `STATE_ERROR`，测量线程停止。

---

## 场景 7：真实硬件低风险验证（谨慎进行）
- **目的**：以最小风险验证真实设备的数据通路（仅读取样本）。
- **前置条件**：设备处于空载或安全模式，急停就绪。
- **步骤**：
  1. 放置 `DOPE32.DLL` 并确认 `DopeDriver().loaded()` 为 `True`。
  2. 启动 UI，点击 `Start`，观察是否有稳定样本返回。
  3. 记录字段：`Cycles`、`Time`、`Position`、`Load`、`sensors`、`ctrl_status`。
- **期望**：样本字段可解析，数值在合理范围，无机械意外动作。

---

## 场景 8：功能性/控制动作（仅在了解设备协议后进行）
- **目的**：验证控制命令、生效与安全（例如移动、重置、零点设定）。
- **前提**：必须有设备手册、明确 API 调用与单位后再测试。
- **步骤**：严格按照厂商说明执行，先小幅度低速动作，再放大测试。  
- **期望**：动作符合命令且有相应状态/位置反馈；若异常立即急停。

---

## 日志与判定
- GUI 日志（`log`）与单元测试输出为首要判定依据。  
- 任何导致机械动作的测试必须首先通过“低风险验证”，并由人员在安全环境中监护。

---

## 限制与需要额外信息的项
- 下面测试需要设备厂商提供的函数签名、结构字段顺序与位掩码定义：
  - 精确的 `DoPEData` 字段对齐（字节顺序、pack/align）
  - 回调约定（stdcall vs cdecl）以及回调参数语义
  - 可用的控制命令（移动、复位、输出通道写入等）

如需我把这些测试场景自动化为脚本或生成一个 `TEST_RUNNER.md`，我可以继续生成。
