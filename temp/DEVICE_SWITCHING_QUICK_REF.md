# 设备切换功能 - 快速参考 (Quick Reference)

## 🎯 功能概览

在应用右上角添加了一个**设备选择器**，可在两种模式间切换：

### Hounsfield 模式 (默认)
- ✅ 显示标准压力传感器测量界面
- ✅ 包含运动控制和自定义参数
- ✅ Init按钮: "Init Hounsfield"

### Keithley 模式 
- ✅ 显示数字万用表测量界面
- ✅ 隐藏运动控制
- ✅ Init按钮: "Init Keithley"
- ✅ 包含您上传图片中的所有自定义设置

---

## 🖼️ UI变化

### 添加的元素

1. **设备选择器** (右上角，语言选择器旁)
   ```
   Gerät: [Hounsfield ▼]  ← 可以选择 Hounsfield 或 Keithley
   ```

2. **Keithley测量面板** (仅在选择Keithley时显示)
   - 包含: Erstellung Messung, Position, Zyklen, Channels等
   - 布局和您上传的图片一致

---

## 📝 翻译支持

✅ 所有标签都支持三种语言:
- 🇩🇪 Deutsch (德语)
- 🇬🇧 English (英语)
- 🇨🇳 中文

**设备标签翻译:**
| 语言 | 翻译 |
|------|------|
| DE | Gerät: |
| EN | Device: |
| ZH | 设备: |

---

## 🔧 控制列表

### Keithley测量面板的控制

| 控制名称 | 类型 | 说明 |
|---------|------|------|
| Erstellung Messung | 输入框 | 测量创建信息 |
| Standeort | 输入框 | 位置信息 |
| Standart | 按钮 | 标准化按钮 |
| Position [mm/V] | 数字框 | 位置设置 |
| Zyklen | 数字框 | 测量周期数 |
| Start Messung | 按钮 | 启动Keithley测量 |
| Probenerme | 输入框 | 样品名称 |
| ☐ Bildung Stat | 复选框 | 生成统计信息 |
| D-delay [s] | 数字框 | 延迟时间 |
| ☐ D-delay Info | 复选框 | 显示延迟信息 |
| Channels: | 输入框 | 通道配置 |
| ☐ Scanner | 复选框 | 扫描仪开关 |

---

## 🚀 使用步骤

### 切换到Keithley模式

1. 打开应用
2. 找到右上角的设备选择器
3. 点击 "Hounsfield" 下拉菜单
4. 选择 "Keithley"
5. UI自动切换到Keithley模式

### 在Keithley模式下进行测量

1. 填写 "Erstellung Messung" (测量描述)
2. 输入 "Standeort" (位置)
3. 设置 "Position" 值
4. 指定 "Zyklen" (测量次数)
5. 根据需要勾选复选框 (Bildung Stat, D-delay Info, Scanner)
6. 配置 "Channels" (通道，如 "101,102")
7. 点击 "Start Messung" 开始测量

### 切换回Hounsfield

在设备选择器中选择 "Hounsfield"，UI自动恢复

---

## 📋 文件修改清单

| 文件 | 修改内容 |
|------|---------|
| `ui/main_window_ui.py` | 添加设备选择器，新增Keithley测量面板 |
| `ui/app.py` | 添加设备切换逻辑和相关方法 |
| `ui/translations.py` | 添加所有Keithley标签的翻译 |

---

## ✅ 验证清单

- ✅ 设备选择器正常工作
- ✅ Hounsfield模式: 显示标准测量面板和运动控制
- ✅ Keithley模式: 显示自定义测量面板，隐藏运动控制
- ✅ 初始化按钮根据设备自动显示/隐藏
- ✅ 多语言翻译完整
- ✅ 所有Keithley控制都存在且可访问
- ✅ 无语法错误

---

## 🧪 测试脚本

### 功能测试
```bash
python test_device_switching.py
```

### UI测试 (显示窗口)
```bash
python test_device_switching_ui.py
```

---

## 💡 后续开发建议

如需完整功能，可在以下方法中添加实现:

1. **_start_keithley_measurement()** - 实现Keithley测量逻辑
2. **数据读取** - 集成Keithley DMM驱动
3. **结果处理** - 存储和显示测量结果
4. **错误处理** - 添加异常检测

