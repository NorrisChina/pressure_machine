#!/usr/bin/env python
"""Visual test for customize button - shows the UI window"""

import sys
from PyQt5 import QtWidgets, QtCore

def test_customize_ui():
    app = QtWidgets.QApplication(sys.argv)
    
    from ui.app import MainWindow
    
    window = MainWindow()
    window.setWindowTitle("Customize Mode Test")
    window.resize(1000, 600)
    
    # Add a test to show/hide customize controls
    print("\n" + "="*70)
    print("CUSTOMIZE BUTTON TEST")
    print("="*70)
    print("\n1. The UI window is now open")
    print("2. Initially, all customizable parameters (startkraft, dF, kraftstufen, nennkraft, zyklen) are HIDDEN")
    print("3. Click the 'Customize' button in Row 0 to toggle visibility")
    print("4. The button text will change to 'Customize ✓' when active")
    print("5. All hidden parameters will become visible when customize mode is active")
    print("\nWindow closing in 60 seconds... or close manually to exit.")
    print("="*70 + "\n")
    
    window.show()
    
    # Auto-close after 60 seconds for automated testing
    QtCore.QTimer.singleShot(60000, app.quit)
    
    sys.exit(app.exec_())

if __name__ == '__main__':
    test_customize_ui()
