This folder contains Qt Designer UI files for the project.

Files:
- main_window.ui : Main application window with Start/Stop buttons and log area.

To convert the .ui to Python using the venv-installed pyside6-uic (PowerShell):

$env:VIRTUAL_ENV = "C:\Users\cho77175\Desktop\code\.venv"
& "C:\Users\cho77175\Desktop\code\.venv\Scripts\pyside6-uic.exe" ui\main_window.ui -o ui\main_window_ui.py

Or, using python -m PySide6.scripts.uic:
& "C:\Users\cho77175\Desktop\code\.venv\Scripts\python.exe" -m PySide6.scripts.uic ui\main_window.ui -o ui\main_window_ui.py

If `pyside6-uic` is not available in the venv, install PySide6 into the venv and retry:
& "C:\Users\cho77175\Desktop\code\.venv\Scripts\python.exe" -m pip install PySide6
