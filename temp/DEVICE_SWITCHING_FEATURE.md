# Device Switching Feature Implementation - Summary

## 功能说明 (Feature Overview)

实现了一个设备选择系统，允许用户在两种工作模式之间切换：
1. **Hounsfield** - 压力传感器测量模式（默认）
2. **Keithley** - 数字万用表测量模式

---

## 主要改动 (Main Changes)

### 1. **ui/main_window_ui.py** - UI界面布局修改

#### 顶部工具栏
- ✅ 添加了 **设备选择器 (combo_device)**
  - 选项: "Hounsfield", "Keithley"
  - 位置: 语言选择器 (Sprache/Language) 的右侧

#### 初始化面板 (Initialisierung Geräte)
- 当选择 **Hounsfield** 时:
  - 显示 "Init Hounsfield" 按钮
  - 隐藏 "Init Keithley" 按钮
  
- 当选择 **Keithley** 时:
  - 显示 "Init Keithley" 按钮
  - 隐藏 "Init Hounsfield" 按钮

#### 测量面板
- ✅ 保留 **Hounsfield 测量面板** (`grp_measure`)
  - 标题: "Messung der Sensoren"
  - 内容: 传感器选择、启动按钮、自定义参数

- ✅ 新增 **Keithley 测量面板** (`grp_keithley`)
  - 标题: "Messungen"
  - 包含所有您上传图片中显示的自定义设置:
    * Erstellung Messung (测量创建)
    * Standeort (位置)
    * Position [mm/V] 
    * Zyklen (周期)
    * Probenerme (样品名称)
    * Bildung Stat (生成统计 - 复选框)
    * D-delay [s]
    * D-delay Info (复选框)
    * Channels (通道)
    * Scanner (复选框)

#### 运动控制 (Bewegung)
- 仅在 **Hounsfield** 模式下显示:
  - "Bewegung Ein" 按钮
  - "Bewegung Halt" 紧急停止按钮
  - 运动模式单选按钮组
  - max. Zug 和 max. Kraft 设置

---

### 2. **ui/app.py** - 功能实现

#### 新增属性
```python
self.current_device = "Hounsfield"  # 追踪当前设备
```

#### 新增方法

**_change_device(index)**
- 当设备选择器改变时调用
- 更新 `current_device` 
- 调用 `_update_ui_for_device()` 刷新界面

**_update_ui_for_device()**
- 根据 `current_device` 切换UI可见性
- 显示/隐藏相应的按钮和面板
- 自动隐藏不相关的控制组件

**_start_keithley_measurement()**
- 处理Keithley "Start Messung" 按钮点击
- 读取Keithley特定参数
- 记录测量参数到日志

#### 按钮连接
```python
if hasattr(self.ui, 'combo_device'):
    self.ui.combo_device.currentIndexChanged.connect(self._change_device)
if hasattr(self.ui, 'btn_kei_start'):
    self.ui.btn_kei_start.clicked.connect(self._start_keithley_measurement)
```

#### 语言支持更新
- 在 `_update_ui_language()` 中添加了所有Keithley面板标签的翻译
- 所有标签支持德语(de)、英语(en)、中文(zh)

---

### 3. **ui/translations.py** - 多语言翻译

#### 新增翻译键

**设备选择器**
```python
"device": {
    "de": "Gerät:",
    "en": "Device:",
    "zh": "设备："
}
```

**Keithley面板标签**
```python
"lbl_kei_erstellung_messung": {"de": "Erstellung Messung", "en": "Measurement Creation", "zh": "测量创建"}
"lbl_kei_standeort": {"de": "Standeort", "en": "Location", "zh": "位置"}
"lbl_kei_standartl": {"de": "Standart", "en": "Standard", "zh": "标准"}
"lbl_kei_position": {"de": "Position [mm/V]", "en": "Position [mm/V]", "zh": "位置 [mm/V]"}
"lbl_kei_zyklen": {"de": "Zyklen", "en": "Cycles", "zh": "周期"}
"btn_kei_start": {"de": "Start Messung", "en": "Start Measurement", "zh": "开始测量"}
"lbl_kei_probenerme": {"de": "Probenerme", "en": "Sample Name", "zh": "样品名称"}
"chk_kei_bildung": {"de": "Bildung Stat", "en": "Build Statistics", "zh": "生成统计"}
"lbl_kei_del": {"de": "D-delay [s]", "en": "D-delay [s]", "zh": "D延迟 [s]"}
"chk_kei_d_delay": {"de": "D-delay Info", "en": "D-delay Info", "zh": "D延迟信息"}
"lbl_kei_channels": {"de": "Channels:", "en": "Channels:", "zh": "通道："}
"chk_kei_scanner": {"de": "Scanner", "en": "Scanner", "zh": "扫描仪"}
```

---

## 工作流程 (Workflow)

### 用户操作流程

1. **启动应用**
   - 默认显示 Hounsfield 模式
   - 标准的测量面板可见

2. **切换到Keithley**
   - 在右上角 "Gerät:" 下拉菜单选择 "Keithley"
   - UI自动切换到Keithley模式:
     - 隐藏: Hounsfield测量面板、运动控制
     - 显示: Keithley测量面板、Init Keithley按钮
   - 日志显示: "Device changed to: Keithley"

3. **使用Keithley界面**
   - 填写测量参数
   - 点击 "Start Messung" 开始测量
   - 系统读取所有参数并记录

4. **切换回Hounsfield**
   - 在设备选择器选择 "Hounsfield"
   - UI恢复到原始状态

5. **语言切换**
   - 支持Deutsch、English、中文
   - 所有Keithley标签都会相应翻译

---

## 测试验证 (Testing & Verification)

✅ **创建的测试脚本**

1. **test_device_switching.py** - 功能测试
   - 验证设备切换逻辑
   - 检查UI元素可见性
   - 验证所有Keithley控制存在
   - 测试多语言翻译

2. **test_device_switching_ui.py** - 视觉测试
   - 显示完整UI窗口
   - 允许手动测试设备切换
   - 验证实际UI行为

### 验证结果
✅ 无语法错误
✅ 所有Keithley控制面板完整
✅ 设备切换功能工作正常
✅ 多语言翻译完整
✅ UI元素正确显示/隐藏

---

## UI布局对比

### Hounsfield 模式
```
[语言选择] [设备选择: Hounsfield]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Initialisierung Geräte
[Init Hounsfield] [传感器显示]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Messung der Sensoren
[传感器选择] [Messung Start] [Customize]
[时间] [位置] [力值] [Ub]
[自定义参数]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Bewegung
[Bewegung Ein] [max. Zug] [max. Kraft] [nur 10 kN-Dose]
[Bewegung Halt] [运动模式选择]
```

### Keithley 模式
```
[语言选择] [设备选择: Keithley]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Initialisierung Geräte
[Init Keithley]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Messungen (自定义Keithley界面)
[Erstellung] [Standeort] [Standart按钮]
[Position mm/V] [Zyklen] [Start Messung]
[Probenerme] ☐Bildung Stat
[D-delay s] ☐D-delay Info
[Channels] ☐Scanner
```

---

## 运行方式

```bash
# 启动应用
C:\Users\cho77175\Desktop\code\.venv32\Scripts\python.exe start.py

# 或
python start.py
```

---

## 注意事项

1. 必须使用 `.venv32` 中的Python（32位）
2. 设备切换时会自动隐藏/显示相关控制
3. 所有控制都有完整的多语言支持
4. Keithley测量面板的具体功能可在需要时实现

