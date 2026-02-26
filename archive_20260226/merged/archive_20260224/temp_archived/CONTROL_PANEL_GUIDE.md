# 控制面板快速启动指南

## 功能特性

### 1. 实时数据显示
- **当前位置** [mm]：蓝色大字显示
- **当前力** [N]：红色大字显示
- **运行时间** [s]：实时计时
- **循环次数**：当前测量循环数

### 2. 运动控制
- **位置控制**：
  - 输入目标位置 (-100 ~ 100 mm)
  - 设置移动速度 (0.1 ~ 50 mm/s)
  - 点击"移动到位置"执行

- **力控制**：
  - 输入目标力 (-10000 ~ 10000 N)
  - 设置加载速度 (0.1 ~ 100 N/s)
  - 点击"加载到目标力"执行

- **快捷操作**：
  - 回零位：立即回到 0mm 位置
  - 回休息位：回到默认休息位置 (-34mm)
  - 卸载力：将目标力设为 0N

### 3. 测量序列
- 设置循环次数 (1 ~ 10000)
- 设置采样间隔 (0.01 ~ 10 秒)
- 输入样品名称
- 自动采集数据并记录到日志

### 4. 紧急停止
- 🚨 红色大按钮
- 立即停止所有运动和测量
- 任何时候都可点击

### 5. 操作日志
- 显示所有操作历史
- 包含时间戳
- 显示成功/失败状态

## 快速启动

### 方法1：直接运行控制面板
```powershell
C:\Users\cho77175\Desktop\code\.venv32\Scripts\python.exe control_panel.py
```

### 方法2：从现有程序集成
在 `start.py` 或 `ui/app.py` 中添加：
```python
from control_panel import ControlPanelWindow

# 在适当的地方创建控制面板
control_window = ControlPanelWindow(driver=self.driver)
control_window.show()
```

### 方法3：作为独立窗口打开
在主窗口添加按钮：
```python
self.btn_open_control = QtWidgets.QPushButton("打开控制面板")
self.btn_open_control.clicked.connect(self._open_control_panel)

def _open_control_panel(self):
    from control_panel import ControlPanelWindow
    self.control_panel = ControlPanelWindow(driver=self.driver)
    self.control_panel.show()
```

## 使用流程

1. **启动程序**
   - 程序会自动检测设备连接状态
   - 绿色"已连接"表示正常，红色表示未连接

2. **位置控制测试**
   - 输入小的位置值（如 1.0mm）
   - 设置慢速度（如 1.0 mm/s）
   - 点击"移动到位置"
   - 观察实时位置变化

3. **力控制测试**
   - 确保样品已装夹
   - 输入小的力值（如 10N）
   - 设置慢速度（如 0.5 N/s）
   - 点击"加载到目标力"
   - 观察实时力值变化

4. **测量序列**
   - 输入样品名称
   - 设置循环次数和采样间隔
   - 点击"开始测量序列"
   - 数据会自动记录到日志
   - 可随时点击"停止序列"中断

5. **紧急情况**
   - 任何时候都可点击"🚨 紧急停止 🚨"
   - 所有运动立即停止

## 注意事项

⚠️ **安全警告**
- 首次使用时请使用小的位置/力值测试
- 确保设备周围无障碍物
- 随时准备按紧急停止
- 定期检查设备连接状态

⚠️ **数据采集**
- 实时数据每 100ms 更新一次
- 测量序列按设定间隔采样
- 所有操作都记录到日志

⚠️ **设备兼容性**
- 自动适配 Hounsfield 和 Keithley 设备
- 如果某功能不可用，日志会提示"驱动不支持"

## 故障排查

### 设备未连接
- 检查 USB/串口连接
- 查看设备管理器中的 COM 口
- 重启程序尝试重新连接

### 移动不响应
- 检查连接状态（顶部状态栏）
- 查看日志中的错误信息
- 尝试紧急停止后重新操作

### 数据不更新
- 检查驱动是否正确加载
- 确认设备已完成初始化
- 查看日志中的警告信息

## 技术细节

- **UI 框架**: PyQt5
- **更新频率**: 100ms (10Hz)
- **支持的驱动**: DopeDriver, DoPeDriver (真实硬件)
- **日志时间戳**: HH:MM:SS 格式

## 扩展功能

如需添加更多功能，可以编辑：
- `ui/control_panel_ui.py` - UI 布局
- `control_panel.py` - 业务逻辑
- `drivers/dope_driver*.py` - 驱动接口
