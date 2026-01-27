"""
Basic DoPE driver wrapper (ctypes) - initial implementation.

This module provides:
- loading of `DOPE32.DLL` (if present)
- placeholder ctypes definitions and callback type
- light-weight Python wrapper methods for core functions (signatures only)

Do NOT call control functions on real hardware until the structures
and signatures are fully verified against the manual.
"""
from ctypes import (
    WinDLL,
    c_void_p,
    c_uint,
    c_ulong,
    c_int,
    c_long,
    POINTER,
    byref,
    CFUNCTYPE,
)
import ctypes
import os

from drivers.dope_driver_structs import DoPEData


class DopeDriver:
    def __init__(self, dll_path=None):
        # 默认在当前模块目录查找 DLL
        # 尝试 DoPE.dll (主要) 或 DoDpx.dll (备用)
        if dll_path is None:
            import os
            current_dir = os.path.dirname(os.path.abspath(__file__))
            dope_path = os.path.join(current_dir, "DoPE.dll")
            dodpx_path = os.path.join(current_dir, "DoDpx.dll")
            
            # 优先使用 DoPE.dll
            if os.path.exists(dope_path):
                dll_path = dope_path
            elif os.path.exists(dodpx_path):
                dll_path = dodpx_path
            else:
                dll_path = dope_path
        
        self.dll_path = dll_path
        self.dll = None
        self.callback_ref = None
        self.handle = None
        self._load()

    def _load(self):
        try:
            if os.path.isabs(self.dll_path) and os.path.exists(self.dll_path):
                self.dll = WinDLL(self.dll_path)
            else:
                self.dll = WinDLL(self.dll_path)
        except OSError as e:
            print(f"Failed to load DLL from {self.dll_path}: {e}")
            self.dll = None

    def loaded(self):
        return self.dll is not None

    # Callback prototype: void CALLBACK NotifyProc(HWND, UINT, DOPE_HANDLE, LPARAM);
    CALLBACK_TYPE = ctypes.WINFUNCTYPE(None, c_void_p, c_uint, c_void_p, c_long)

    def set_notification(self, handle, event_mask, callback_func, notify_wnd=0, notify_msg=0):
        """Register callback (wrapper for DoPESetNotification).

        This method only sets up argtypes/restype and keeps a Python
        reference to the callback to avoid GC. It does not validate
        the event mask or call the DLL if the DLL is not loaded.
        """
        if not self.loaded():
            # Keep Python-level callback even if DLL not loaded; useful for stubs
            self._py_event_callback = callback_func
            return None

        try:
            fn = self.dll.DoPESetNotification
        except AttributeError:
            raise RuntimeError("DoPESetNotification not found in DLL")

        # Keep callback reference alive
        self.callback_ref = DopeDriver.CALLBACK_TYPE(callback_func) if callback_func is not None else None

        fn.argtypes = [c_void_p, c_uint, DopeDriver.CALLBACK_TYPE, c_void_p, c_uint]
        fn.restype = c_int

        return fn(handle, event_mask, self.callback_ref, notify_wnd, notify_msg)

    def register_event_callback(self, callback):
        """Register a Python-level event callback for higher-level use.

        Callback signature: callback(event:int, data:Any)
        """
        # store for potential use by wrapper or stubs
        self._py_event_callback = callback
        return True

    def open_link(self, port, baudrate, rcvbuf=10, xmitbuf=10, databuf=50, apiver=0x0289, reserved=0):
        """Wrapper for DoPEOpenLink. Returns (error_code, handle) tuple."""
        if not self.loaded():
            return None, None
        
        try:
            fn = self.dll.DoPEOpenLink
        except AttributeError:
            raise RuntimeError("DoPEOpenLink not found in DLL")

        fn.argtypes = [c_uint, c_uint, c_uint, c_uint, c_uint, c_uint, c_void_p, POINTER(c_void_p)]
        fn.restype = c_int

        handle = c_void_p()
        res = fn(port, baudrate, rcvbuf, xmitbuf, databuf, apiver, reserved, byref(handle))
        
        # 保存句柄（如果连接成功）
        if res == 0:
            self.handle = handle
        
        return res, handle

    def _bind_fmove(self):
        fn = getattr(self.dll, 'DoPEFMove', None)
        if not fn:
            raise RuntimeError('DoPEFMove not found in DLL')
        fn.argtypes = [c_void_p, ctypes.c_ushort, ctypes.c_ushort, ctypes.c_double, c_void_p]
        fn.restype = c_int
        return fn

    def _ensure_active(self):
        """Ensure controller is ON and data transmission enabled."""
        if not self.loaded() or self.handle is None:
            return False
        try:
            fn_on = getattr(self.dll, 'DoPEOn', None)
            if fn_on:
                fn_on.argtypes = [c_void_p, POINTER(ctypes.c_ushort)]
                fn_on.restype = c_int
                fn_on(self.handle, None)
        except Exception:
            pass
        try:
            fn_test = getattr(self.dll, 'DoPECtrlTestValues', None)
            if fn_test:
                fn_test.argtypes = [c_void_p, ctypes.c_ushort]
                fn_test.restype = c_int
                fn_test(self.handle, ctypes.c_ushort(0))
        except Exception:
            pass
        try:
            fn_tx = getattr(self.dll, 'DoPETransmitData', None)
            if fn_tx:
                fn_tx.argtypes = [c_void_p, ctypes.c_ushort, POINTER(ctypes.c_ushort)]
                fn_tx.restype = c_int
                fn_tx(self.handle, ctypes.c_ushort(1), None)
        except Exception:
            pass
        return True

    def jog_up(self, speed=0.5):
        if not self._ensure_active():
            return False
        fn = self._bind_fmove()
        # 直接使用 jog_console.py 的方式：第一个参数 1（方向），第二个参数用 c_ushort(0)（控制模式），第三个参数用 c_double(速度)
        res = fn(self.handle, 1, ctypes.c_ushort(0), ctypes.c_double(float(speed)), None)
        return res == 0

    def jog_down(self, speed=0.5):
        if not self._ensure_active():
            return False
        fn = self._bind_fmove()
        res = fn(self.handle, 2, ctypes.c_ushort(0), ctypes.c_double(float(speed)), None)
        return res == 0

    def jog_stop(self):
        if not self._ensure_active():
            return False
        fn = self._bind_fmove()
        res = fn(self.handle, 0, ctypes.c_ushort(0), ctypes.c_double(0.0), None)
        return res == 0
    
    def close_link(self):
        """Close the DoPE connection."""
        if not self.loaded() or self.handle is None:
            return
        
        try:
            fn = self.dll.DoPECloseLink
            fn.argtypes = [c_void_p]
            fn.restype = c_int
            res = fn(self.handle)
            self.handle = None
            return res
        except Exception as e:
            print(f"Error closing link: {e}")
            return None

    def get_data(self, handle=None):
        """Example wrapper to call DoPEGetData or similar (signature must be verified).

        Args:
            handle: DoPE handle，如果为 None 则使用保存的 self.handle
        
        Returns:
            Tuple (res, data) where res is error code and data is DoPEData instance.
        """
        if not self.loaded():
            return None, None
        
        # 使用传入的 handle 或保存的 handle
        if handle is None:
            handle = self.handle
        
        if handle is None:
            raise RuntimeError("No handle available. Call open_link first.")
        
        # Try several possible function names conservatively. We will attempt
        # to bind a function that fills a DoPEData structure. If no suitable
        # function is found, return None.
        possible_names = [
            "DoPEGetData",
            "DoPEGetMeasData",
            "DoPEGetMeasuringData",
            "DoPEGetMsg",
        ]

        for name in possible_names:
            fn = getattr(self.dll, name, None)
            if fn is None:
                continue
            try:
                # conservative argtypes: (DoPE_HANDLE, POINTER(DoPEData))
                fn.argtypes = [c_void_p, ctypes.POINTER(DoPEData)]
                fn.restype = c_int
                data = DoPEData()
                res = fn(handle, ctypes.byref(data))
                return res, data
            except Exception:
                # binding failed for this name; try next
                continue

        # If we reach here, no binding succeeded
        raise NotImplementedError("No suitable DoPEGetData binding found in DLL. Verify function name and signature in the manual.")

    def _dopedata_to_dict(self, data: DoPEData) -> dict:
        """Convert a ctypes DoPEData instance into a plain Python dict."""
        out = {}
        try:
            for fname, _ in getattr(data, '_fields_', []):
                try:
                    val = getattr(data, fname)
                    # convert ctypes arrays to lists
                    if hasattr(val, '__len__') and not isinstance(val, (str, bytes)):
                        try:
                            out[fname] = [x for x in val]
                        except Exception:
                            out[fname] = val
                    else:
                        out[fname] = val
                except Exception:
                    out[fname] = None
        except Exception:
            # Fallback: represent whole object
            out['__repr__'] = repr(data)
        return out

    def get_latest_data(self, handle):
        """Return (res, dict) where dict is a plain representation of DoPEData.

        If DLL not loaded, returns (None, None). If the underlying `get_data`
        returns a ctypes DoPEData instance, it is converted to a dict for
        easier consumption by the UI.
        """
        if not self.loaded():
            return None, None

        try:
            res, data = self.get_data(handle)
        except NotImplementedError:
            return None, None
        except Exception:
            return None, None

        if data is None:
            return res, None

        try:
            d = self._dopedata_to_dict(data)
            return res, d
        except Exception:
            return res, None


if __name__ == '__main__':
    drv = DopeDriver()
    print('DOPE driver loaded:', drv.loaded())
