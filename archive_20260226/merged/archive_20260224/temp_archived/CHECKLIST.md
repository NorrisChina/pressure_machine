# DOPE 仪器 — 上机前检查表（Check‑list）

说明：在把程序与真实仪器连接前，请逐项执行以下检查，优先保证人员与设备安全。

## 1. 环境与依赖
- 激活虚拟环境（在项目根目录）：
```powershell
.\.venv\Scripts\Activate.ps1
```
- 安装依赖（如果有 `requirements.txt`）：
```powershell
& .\.venv\Scripts\python.exe -m pip install -r requirements.txt
```
- 验证核心库可用（示例）：
```powershell
& .\.venv\Scripts\python.exe -c "import PySide6; print('PySide6 OK')"
```

## 2. 代码自检
- 运行全部单元测试：
```powershell
& .\.venv\Scripts\python.exe -m unittest discover tests -v
```
- 期望：所有测试通过（当前：18 个测试通过）。

## 3. 日志与备份
- 在连接硬件前备份当前设置/配置文件（若有）。
- 准备一个可写入的 `logs/` 目录（可选）：
```powershell
mkdir logs
```

## 4. DLL 与驱动
- 若使用真实 `DOPE32.DLL`，将 DLL 放置于可加载路径（项目根或系统路径）。
- 在 Python 中检查 DLL 是否被驱动加载：
```powershell
& .\.venv\Scripts\python.exe -c "from drivers.dope_driver import DopeDriver; print('loaded', DopeDriver().loaded())"
```
- 若返回 `False`，程序会自动使用 `StubDopeDriver`，可先离线验证 GUI 与流程。

## 5. 安全与测试策略（强制）
- 第一次连线/运行真实硬件时：
  - 确保仪器处于安全/空载模式或低速模式。
  - 人员保持在安全距离，急停（E‑STOP）可用并且熟悉位置。
  - 首次运行使用最保守的测试（例如 1‑3 个测量循环，或仅读取数据，不指令执行机构移动）。

## 6. 运行步骤（推荐顺序）
1. 运行单元测试。确认 OK。  
2. 以 `StubDopeDriver` 启动 UI：
```powershell
& .\.venv\Scripts\python.exe -m demo.ui_demo
```
3. 在 UI 中点击 `Start`，观察日志与传感器数据。  
4. 点击 `Start Sequence`（小循环、短间隔），观察 `Sequence finished` / `Sequence error`。  
5. 若一切正常，将 `DOPE32.DLL` 放入并重测（先不要发送动作命令，只读数据）。  
6. 在确认数据格式/字段正确且无机械动作后，逐步开启更复杂测试。

## 7. 故障快速排查
- DLL 加载失败：检查 DLL 位数（32/64）是否与 Python/Windows 架构匹配；检查导出函数名。  
- 数据字段错位：暂停交互，获取设备头文件或文档以修正 `ctypes.Structure` 定义。  
- 意外机械动作：立即触发急停并断开通信；不要继续测试，联系设备厂商或工程师。

---

此检查表为保守、安全优先的指导。若需要，我可以把该文件保存为项目根的 `CHECKLIST.md`（已生成）。
