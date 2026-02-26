import ctypes
import os
from pathlib import Path

DLL_PATH = Path(__file__).parent / "drivers" / "DoPE.dll"

def list_exports(dll_path):
    import pefile
    pe = pefile.PE(str(dll_path))
    exports = []
    if hasattr(pe, 'DIRECTORY_ENTRY_EXPORT'):
        for exp in pe.DIRECTORY_ENTRY_EXPORT.symbols:
            if exp.name:
                exports.append(exp.name.decode())
    return exports

if __name__ == "__main__":
    try:
        import pefile
    except ImportError:
        print("请先安装 pefile: pip install pefile")
        exit(1)
    exports = list_exports(DLL_PATH)
    for name in exports:
        print(name)
