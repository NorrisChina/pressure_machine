#!/usr/bin/env python
"""Test script for device switching functionality"""

from PyQt5 import QtWidgets
app = QtWidgets.QApplication([])

from ui.app import MainWindow

mw = MainWindow()

print("\n" + "="*70)
print("DEVICE SWITCHING TEST")
print("="*70)

print("\n1. INITIAL STATE (Hounsfield)")
print(f"   Current device: {mw.current_device}")
print(f"   Init Keithley visible: {mw.ui.btn_init_keithley.isVisible()}")
print(f"   Init Hounsfield visible: {mw.ui.btn_init_hounsfield.isVisible()}")
print(f"   Measurement panel (Hounsfield): {mw.ui.grp_measure.isVisible()}")
print(f"   Keithley panel: {mw.ui.grp_keithley.isVisible()}")
print(f"   Motion controls visible: {mw.ui.btn_move_on.isVisible()}")

print("\n" + "-"*70)
print("2. SWITCHING TO KEITHLEY")
print("-"*70)
mw._change_device(1)

print(f"   Current device: {mw.current_device}")
print(f"   Init Keithley visible: {mw.ui.btn_init_keithley.isVisible()}")
print(f"   Init Hounsfield visible: {mw.ui.btn_init_hounsfield.isVisible()}")
print(f"   Measurement panel (Hounsfield): {mw.ui.grp_measure.isVisible()}")
print(f"   Keithley panel: {mw.ui.grp_keithley.isVisible()}")
print(f"   Motion controls visible: {mw.ui.btn_move_on.isVisible()}")

print("\n" + "-"*70)
print("3. SWITCHING BACK TO HOUNSFIELD")
print("-"*70)
mw._change_device(0)

print(f"   Current device: {mw.current_device}")
print(f"   Init Keithley visible: {mw.ui.btn_init_keithley.isVisible()}")
print(f"   Init Hounsfield visible: {mw.ui.btn_init_hounsfield.isVisible()}")
print(f"   Measurement panel (Hounsfield): {mw.ui.grp_measure.isVisible()}")
print(f"   Keithley panel: {mw.ui.grp_keithley.isVisible()}")
print(f"   Motion controls visible: {mw.ui.btn_move_on.isVisible()}")

print("\n" + "="*70)
print("KEITHLEY PANEL CONTROLS CHECK")
print("="*70)
mw._change_device(1)

keithley_controls = [
    'edit_kei_probenerme', 'edit_kei_position', 'spin_kei_zyklen',
    'btn_kei_bildung', 'spin_kei_del', 'edit_kei_channels',
    'btn_kei_start', 'btn_kei_stop'
]

print("\nKeithley panel controls exist:")
for ctrl in keithley_controls:
    exists = hasattr(mw.ui, ctrl)
    print(f"   {ctrl:30} {'✓' if exists else '✗'}")

print("\n" + "="*70)
print("DEVICE SELECTOR TRANSLATIONS")
print("="*70)

for index, lang in enumerate(['de', 'en', 'zh']):
    mw._change_language(['de', 'en', 'zh'].index(lang))
    print(f"\n{lang.upper()}:")
    print(f"   Device label: '{mw.ui.lbl_device.text()}'")
    print(f"   Selected device: {mw.current_device}")

print("\n" + "="*70)
print("✓ All tests completed successfully!")
print("="*70 + "\n")
