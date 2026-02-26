#!/usr/bin/env python
"""Visual test for device switching - shows the UI window"""

import sys
from PyQt5 import QtWidgets, QtCore

def test_device_switching_ui():
    app = QtWidgets.QApplication(sys.argv)
    
    from ui.app import MainWindow
    
    window = MainWindow()
    window.setWindowTitle("Device Switching Test")
    window.resize(1000, 700)
    
    print("\n" + "="*70)
    print("DEVICE SWITCHING UI TEST")
    print("="*70)
    print("\n✓ UI Window is now open")
    print("\n使用方法 (How to use):")
    print("1. 在右上角的 'Gerät:' (Device) 下拉菜单中选择:")
    print("   - Hounsfield: 显示标准的测量面板（Messung der Sensoren）")
    print("   - Keithley:   显示自定义的Keithley测量面板（Messungen）")
    print("\n2. 选择Hounsfield时:")
    print("   - Init Keithley 按钮 隐藏")
    print("   - Init Hounsfield 按钮 显示")
    print("   - 显示标准的测量面板和运动控制")
    print("\n3. 选择Keithley时:")
    print("   - Init Hounsfield 按钮 隐藏")
    print("   - Init Keithley 按钮 显示")
    print("   - 隐藏标准测量面板和运动控制")
    print("   - 显示Keithley自定义测量面板（如上传的图片所示）")
    print("\n4. 测试语言切换 - 验证所有标签都正确翻译")
    print("\nWindow will close in 120 seconds or when you close it manually.")
    print("="*70 + "\n")
    
    window.show()
    
    # Auto-close after 120 seconds for automated testing
    QtCore.QTimer.singleShot(120000, app.quit)
    
    sys.exit(app.exec_())

if __name__ == '__main__':
    test_device_switching_ui()
