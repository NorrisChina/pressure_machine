# INTERFACE_STATUS.md — DOPE 接口完成度清单

说明：此文档列出仓库中与 DOPE API/结构相关的符号、当前实现状态、测试覆盖情况与后续建议。状态分类：
- translated: 已翻译并在 Python 中实现（可能为保守实现或 stub）。
- draft: 有草稿实现（ctypes 结构或函数签名），需实机/文档验证。
- needs-DLL: 依赖真实 `DOPE32.DLL` 或头文件以完成准确实现。
- not-implemented: 暂未实现或仅保留占位符。

---

## 概览（文件位置）
- `drivers/programm_dope_translated.py` — 高层翻译、数据类型（dataclass）、控制器骨架、工具函数。
- `drivers/dope_driver.py` — ctypes 驱动包装器（尝试加载 `DOPE32.DLL`，提供安全回退）。
- `drivers/dope_driver_structs.py` — ctypes `DoPEData`, `DoPESetup` 的草稿结构。  
- `drivers/stub_driver.py` — 用于离线测试的模拟驱动（已实现）。

---

## 接口与结构清单

### 1) 全局常量与工具
- `DOPE_API_VERSION` (`drivers/programm_dope_translated.py`)
  - 状态：translated
  - 说明：已设为 `0x0289`，用于初始化链接/校验。测试覆盖：有引用但无独立测试。

- `decode_ctrl_status_word(word:int)`
  - 状态：translated (heuristic)
  - 说明：基于 XLSX 提取的位掩码推测（`CTRL_READY=0x40`, `CTRL_MOVE=0x80`, `CTRL_FREE=0x8000`），用于 UI/状态机。需用真实样本校准位语义与扩展位。测试覆盖：通过整合测试。 

### 2) 高层 API 包装函数（Pascal 名称 -> Python wrapper）
- `DoPEOpenDeviceID(device_id)` (`programm_dope_translated`) 
  - 状态：translated (delegates to `DopeDriver.open_device_id` if present)
  - 说明：保守包装；若 `DopeDriver` 未提供具体方法则抛 `NotImplementedError`。

- `DoPEOpenFunctionID(func_id)`
  - 状态：translated (delegates)

- `DoPESetNotification(dhandle, evmask, callback, wnd_handle=None)`
  - 状态：translated -> delegates to `DopeDriver.set_notification` when available
  - 说明：高层包装；低层行为取决于 `DopeDriver.CALLBACK_TYPE` 的正确性（需 DLL 文档）。

- `DoPEGetData(*args, **kwargs)`
  - 状态：translated (delegates to `DopeDriver.get_data`)
  - 说明：在没有 DLL 时抛 `NotImplementedError`；`DopeDriver.get_data` 尝试多种导出名并返回 `(res, DoPEData)`，然后 `get_latest_data` 会转换为 dict。

- `DoPEOutChaDef`, `DoPEMachineDef`, `DoPEIOSignals`, `DoPESetup` (stubs)
  - 状态：not-implemented (占位符 / dataclass 另有同名实现)
  - 说明：这些在 `programm_dope_translated.py` 中为保守 stub 或 dataclass（见下）。

### 3) dataclasses（配置/定义）
- `DoPESetup` (dataclass) — `drivers/programm_dope_translated.py`
  - 状态：translated (Python dataclass)
  - 说明：提供 `from_dict`，但是真实字段/对齐需与 `DoPESetup` ctypes 定义和设备文档比对。测试覆盖：部分函数使用该 dataclass 的默认行为。

- `DoPEOutChaDef`, `DoPEMachineDef`, `DoPEIOSignals` (dataclasses)
  - 状态：translated (dataclass)
  - 说明：轻量 representation，供高层使用或从 driver 返回 dict 转换。实际字段需确认。

### 4) ctypes 结构草稿
- `DoPEData` (`drivers/dope_driver_structs.py`)
  - 状态：draft (ctypes Structure draft)
  - 说明：基于 PDF/提取的片段生成，使用 `_pack_ = 1` 并包含 `Cycles, Time, Position, Load, Extension, SensorD, Sensor[12], KeyActive/KeyNew/KeyGone, CtrlStatus[4], …` 等字段。
  - 风险：字段顺序、类型与对齐必须由设备头文件或实机验证（否则会解析错数据）。

- `DoPESetup` (`drivers/dope_driver_structs.py`)
  - 状态：draft
  - 说明：占位结构 `(SetupNo, UserScale, Reserved)`，需要完整定义。

### 5) 低层驱动包装器 `DopeDriver` (`drivers/dope_driver.py`)
- `DopeDriver._load()`
  - 状态：translated (attempts to load `DOPE32.DLL` using `WinDLL`)
- `DopeDriver.loaded()`
  - 状态：translated
- `DopeDriver.CALLBACK_TYPE` (WINFUNCTYPE prototype)
  - 状态：draft — prototype defined as `WINFUNCTYPE(None, c_void_p, c_uint, c_void_p, c_long)`
  - 说明：回调原型仍需与 DLL 文档确认（参数和 calling convention）。
- `set_notification(handle, event_mask, callback, notify_wnd, notify_msg)`
  - 状态：translated (binds `DoPESetNotification` when DLL available)
  - 说明：安全保留 Python-level callback even if DLL missing.
- `register_event_callback(callback)`
  - 状态：translated (stores `_py_event_callback`)
- `open_link(port, baudrate, ...)` → wrapper for `DoPEOpenLink`
  - 状态：draft/translated (attempts to call `DoPEOpenLink` if present)
  - 说明：argtypes present but signatures are conservative — must be validated.
- `get_data(handle)`
  - 状态：draft/translated (tries multiple exported names, sets conservative argtypes)
  - 说明：Will attempt `DoPEGetData`, `DoPEGetMeasData`, etc. Implementation returns `(res, DoPEData)` when successful; raises `NotImplementedError` if no binding found.
- `_dopedata_to_dict(data)`
  - 状态：translated (helper converting ctypes struct -> dict)
- `get_latest_data(handle)`
  - 状态：translated (returns `(res, dict)` if DLL present and binding successful; otherwise `(None,None)`).

**注意：** 低层绑定（argtypes/restype）在当前实现中使用了保守猜测，必须利用实际 DLL 导出表和头文件进行确认和修正。

### 6) 控制器与测量模块（已实现骨架）
- `TMyDoPEData` (Eintragen, Lese, scale_and_map)
  - 状态：translated (实现完整，可接受 dict 或 ctypes.Structure)
  - 测试覆盖：有对应的单元测试（scale/mapping 测试通过）。

- `TZirkularPuffer`（循环缓冲）
  - 状态：translated（实现写/读/清空）
  - 测试覆盖：有缓冲测试。

- `TSteuerungAblauf`
  - 状态：translated（事件转发、内部状态机、序列计数、超时、事件发射）
  - 说明：实现了事件码映射（1=DATA, 2=CTRL_READY, 3=CTRL_MOVE, 4=CTRL_FREE, 5=SEQ_FINISH, 6=SEQ_ERROR）和 `start_loop`, `start_sequence`, `start_sequence` 会创建 `TSteuerungMessung` 并启动 watcher，`start_loop`/`stop_loop` 实现背景线程。
  - 测试覆盖：有多项单元测试覆盖事件、序列、超时与状态切换。

- `TSteuerungMessung`
  - 状态：translated（测量循环、写入 `TZirkularPuffer`, `start_measurement_sequence`）
  - 说明：实现为轮询 driver 的 `get_latest_data` 或 `get_data`，并把样本写入缓冲；不主动下发控制命令到设备（安全保守）。
  - 测试覆盖：有相关测试验证缓冲写入与序列收集。

### 7) Stub 驱动
- `StubDopeDriver` (`drivers/stub_driver.py`)
  - 状态：translated (fully implemented)
  - 提供方法：`loaded()`, `open_link()`, `register_callback()`, `close()`, `get_data()` — 返回 dict 样本并偶尔触发回调。
  - 测试覆盖：广泛用于单元测试。

---

## 覆盖与缺口快速汇总
- 已实现并经过单元测试的项（good to go in stub mode）:
  - `TMyDoPEData`, `TZirkularPuffer`, `TSteuerungAblauf`（骨架与核心事件）、`TSteuerungMessung`, `StubDopeDriver`。
  - 高层包装函数对 `DopeDriver` 的委托（在无 DLL 时抛或回退）。
- 需要真实 DLL / 头文件核验并完成的项（high priority）:
  - `DoPEData` ctypes 精确定义（field offsets、types、pack/alignment）
  - `DopeDriver` 的函数签名（`DoPEOpenLink`, `DoPESetNotification`, `DoPEGetData`, 写入/控制函数等）的校验
  - `CALLBACK_TYPE` 原型的最终确认
  - 任何会引起机械动作的 API（输出通道写、移动命令等）的实现与安全封装
- 可以在没有 DLL 的情况下继续增强的项（medium priority）:
  - 把剩余 Pascal 状态机细节逐句翻译并以单元测试驱动（可用 stub 验证）
  - UI 的更多安全选项（例如“安全模式”、“低速运行”复选框）与日志持久化

---

## 建议的下一步计划（执行优先级）
1. 如果你能提供 `DOPE32.DLL` 或 C header，优先让我们完成 `drivers/dope_driver_structs.py` 与 `dope_driver.py` 的低层绑定验证 —— 这是把系统连接到真实硬件的关键。  
2. 实机前准备一组“低风险”脚本（我可以生成），用于：读取样本、打印结构字段偏移、比较 `decode_ctrl_status_word` 与真实 `ctrl_status` 值。  
3. 将 `INTERFACE_STATUS.md` 与 `CHECKLIST.md`、`TEST_SCENARIOS.md` 一起纳入发布说明，并把核心测试脚本放入 `demo/` 目录供现场运行。  

---

如果你要我把此 `INTERFACE_STATUS.md` 放到仓库根目录（我已经创建它），接下来你想我：
- A. 立即等待并在你上传 DLL 后进行低层 binding 验证；或
- B. 继续把剩余 Pascal 控制逻辑完整翻译（保持 stub 驱动下可测）；或
- C. 生成“低风险”现场脚本（读取/验证结构/位掩码）便于周一快速确认。 

请选择 A、B 或 C（或提供其它指示），我将继续操作。