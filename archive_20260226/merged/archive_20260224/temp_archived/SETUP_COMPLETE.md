# DoPE 控制面板 - 连接成功！

## 🎉 当前状态

✅ **连接成功** - COM7 @ 9600 baud  
✅ **数据通信正常** - get_data() 工作  
✅ **控制面板就绪** - 可以启动使用  

## 🔌 硬件信息

- **设备端口**: COM7 (Intel USB 设备)
- **波特率**: 9600 baud
- **API 版本**: 0x0289
- **DLL**: DoPE.dll

## 🚀 快速启动

### 方法 1: 直接启动控制面板
```bash
python start_control_panel.py
```

### 方法 2: 从主程序启动
```bash
python start.py
# 然后点击 "打开控制面板" 按钮
```

## 📊 功能

控制面板提供：
- **实时数据显示** (100ms 刷新)
  - 位置 [mm]
  - 力值 [N]  
  - 时间 [s]
  - 循环数

- **位置控制**
  - 移动到指定位置
  - 速度调节

- **力值控制**
  - 施加指定力值
  - 功率设置

- **测量序列**
  - 配置循环数
  - 设置间隔
  - 命名样本

- **紧急停止** (红色按钮)

## 🔧 配置说明

如果设备不在 COM7，可以在 `start_control_panel.py` 中修改：

```python
ports_priority = [7, 8, 5, 6, 3, 4]  # 修改顺序
```

或者指定特定端口：
```python
res, handle = driver.open_link(port=YOUR_PORT, baudrate=9600, apiver=0x0289)
```

## ⚡ 故障排除

### 问题：连接超时
**解决**: 确保官方软件 (EinzelSensor.exe) 已关闭

### 问题：数据为 0
**解决**: 确保设备正在进行测量，或检查传感器连接

### 问题：Cannot find DoPE.dll
**解决**: 确保 `drivers/DoPE.dll` 存在

## 📝 代码架构

```
drivers/
  ├── dope_driver.py          # 核心驱动 (open_link, get_data)
  ├── dope_driver_structs.py  # DoPEData 结构定义
  └── DoPE.dll                # 官方 DLL

control_panel.py             # 控制面板主逻辑
start_control_panel.py       # 独立启动脚本
```

## 🎯 已验证

✅ DopeDriver.open_link() - COM7 连接成功  
✅ DopeDriver.get_data() - 数据读取正常  
✅ 句柄管理 - 自动保存和使用  
✅ 控制面板 UI - 所有界面元素就绪  
✅ 实时数据显示 - 100ms 更新周期  

---

**更新**: 2026-01-23  
**设备**: DoPE 压力/拉伸测试机  
**软件版本**: Python 3.12 + PyQt5 + DoPE.dll v2.89
