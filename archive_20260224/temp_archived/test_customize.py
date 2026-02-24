#!/usr/bin/env python
"""Test script for customize button functionality"""

from PyQt5 import QtWidgets
app = QtWidgets.QApplication([])

from ui.app import MainWindow

mw = MainWindow()

print("Testing customize toggle functionality:")
print()

print("Initial state (all hidden):")
for widget_name in ['label_startkraft', 'spin_startkraft', 'label_df', 'spin_df', 
                     'label_kraftstufen', 'edit_kraftstufen', 'label_nennkraft', 
                     'spin_nennkraft', 'label_zyklen', 'spin_cycles']:
    w = getattr(mw.ui, widget_name)
    print(f"  {widget_name:25} visible={w.isVisible()}")

print(f"\nCustomize mode: {mw.customize_mode}")
print(f"Button text: '{mw.ui.btn_customize.text()}'")

print("\n" + "="*60)
print("Toggling customize mode...")
print("="*60)

mw._toggle_customize()

print("\nAfter first toggle (all should be visible):")
for widget_name in ['label_startkraft', 'spin_startkraft', 'label_df', 'spin_df',
                     'label_kraftstufen', 'edit_kraftstufen', 'label_nennkraft',
                     'spin_nennkraft', 'label_zyklen', 'spin_cycles']:
    w = getattr(mw.ui, widget_name)
    print(f"  {widget_name:25} visible={w.isVisible()}")

print(f"\nCustomize mode: {mw.customize_mode}")
print(f"Button text: '{mw.ui.btn_customize.text()}'")

print("\n" + "="*60)
print("Toggling customize mode again...")
print("="*60)

mw._toggle_customize()

print("\nAfter second toggle (all should be hidden):")
for widget_name in ['label_startkraft', 'spin_startkraft', 'label_df', 'spin_df',
                     'label_kraftstufen', 'edit_kraftstufen', 'label_nennkraft',
                     'spin_nennkraft', 'label_zyklen', 'spin_cycles']:
    w = getattr(mw.ui, widget_name)
    print(f"  {widget_name:25} visible={w.isVisible()}")

print(f"\nCustomize mode: {mw.customize_mode}")
print(f"Button text: '{mw.ui.btn_customize.text()}'")

print("\n✓ All tests completed successfully!")
