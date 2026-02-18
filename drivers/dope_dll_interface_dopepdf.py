"""DoPE DLL ctypes interface aligned to DoPE.pdf (V2.88, 156 pages).

This module is intentionally NEW (does not modify existing drivers) so you can
switch scripts over gradually.

Authoritative text source used during alignment:
- temp/DoPE_pdf_EXTRACTED.txt (PyPDF2 extraction)
- temp/DoPE_pdf_EXTRACTED_FITZ_p1_100.txt (PyMuPDF extraction; better for
    multi-column / table layouts)

Design goal:
- Bind common DoPE functions with correct argtypes/restype based on DoPE.pdf.
- Provide tolerant Python wrappers for a few signatures used throughout this
    workspace (older code often passes optional TAN pointers).

Notes:
- DoPE.pdf V2.88 primarily documents the newer open/scan APIs
    (DoPEOpenDeviceID/DoPEOpenFunctionID/DoPEOpenAll). The bundled DoPE.dll also
    exports legacy helpers (DoPEOpenLink/DoPEGetData/DoPEGetMsg/DoPESendMsg).
    Those legacy prototypes are not present in the extracted DoPE.pdf text, so
    we keep best-known signatures for backward compatibility.
- Many functions accept pointers to complex structures; this file uses c_void_p
    for those buffers unless the project already has a verified ctypes.Structure.
"""

from __future__ import annotations

import ctypes
from pathlib import Path
from ctypes import (
    WinDLL,
    c_void_p,
    c_uint8,
    c_uint16,
    c_uint32,
    c_double,
    POINTER,
    WINFUNCTYPE,
)
from typing import Callable, Optional


# ===== Common constants (documented in DoPE.pdf but values sometimes inferred) =====
MOVE_HALT = 0
MOVE_UP = 1
MOVE_DOWN = 2

CTRL_POS = 0
CTRL_LOAD = 1
CTRL_EXTENSION = 2


# Callback prototype described under DoPESetNotification:
# HWND NotifyWnd, UINT NotifyMsg, WPARAM DoPEHdl, LPARAM Event -> returns event mask
DoPECallBackFunc = WINFUNCTYPE(c_uint32, c_void_p, c_uint32, c_uint32, c_uint32)


class DoPEDLLDoPEPdf:
    """WinDLL-based binding with DoPE.pdf-aligned prototypes."""

    def __init__(self, dll_path: Optional[str] = None):
        self.dll_path = dll_path
        self.dll: Optional[ctypes.WinDLL] = None
        self.loaded: bool = False
        self._callback_ref = None
        self._load()
        if self.loaded:
            self._bind_core_functions()

    def _load(self) -> None:
        try:
            if self.dll_path:
                self.dll = WinDLL(self.dll_path)
            else:
                try:
                    local_dll = Path(__file__).with_name("DoPE.dll")
                    if local_dll.exists():
                        self.dll = WinDLL(str(local_dll))
                    else:
                        self.dll = WinDLL("DoPE.dll")
                except OSError:
                    self.dll = WinDLL("DoDpx.dll")
            self.loaded = True
        except OSError as e:
            print(f"Warning: Cannot load DoPE DLL: {e}")
            self.dll = None
            self.loaded = False

    def _bind(self, name: str, argtypes: list, restype=c_uint32) -> Optional[ctypes._CFuncPtr]:
        if not self.dll:
            return None
        fn = getattr(self.dll, name, None)
        if fn is None:
            return None
        fn.argtypes = argtypes
        fn.restype = restype
        return fn

    def _bind_core_functions(self) -> None:
        """Bind the functions that are used by this workspace."""
        # 3.1 (DoPE.pdf V2.88) DoPEOpenDeviceID / DoPEOpenFunctionID
        # unsigned DeviceID/FunctionID, unsigned RcvBuffers, unsigned XmitBuffers,
        # unsigned DataBuffers, unsigned APIVersion, void* Reserved, DoPE_HANDLE* DoPEHdl
        self._DoPEOpenDeviceID = self._bind(
            "DoPEOpenDeviceID",
            [c_uint32, c_uint32, c_uint32, c_uint32, c_uint32, c_void_p, POINTER(c_void_p)],
        )
        self._DoPEOpenFunctionID = self._bind(
            "DoPEOpenFunctionID",
            [c_uint32, c_uint32, c_uint32, c_uint32, c_uint32, c_void_p, POINTER(c_void_p)],
        )

        # 3.2/3.3 (DoPE.pdf V2.88) DoPEOpenAll / DoPECloseAll
        # Prototypes involve DoPEOpenLinkInfo structs; bind as void* tables.
        self._DoPEOpenAll = self._bind(
            "DoPEOpenAll",
            [
                c_uint32,
                c_uint32,
                c_uint32,
                c_uint32,
                c_void_p,
                c_uint32,
                POINTER(c_uint32),
                c_void_p,
            ],
        )
        self._DoPECloseAll = self._bind(
            "DoPECloseAll",
            [c_uint32, c_void_p],
        )

        # 3.4 (DoPE.pdf V2.88) DoPEPortInfo / DoPECurrentPortInfo
        # PortInfo structs are not modeled here; bind as void*.
        self._DoPEPortInfo = self._bind(
            "DoPEPortInfo",
            [c_uint32, c_uint32, c_void_p],
        )
        self._DoPECurrentPortInfo = self._bind(
            "DoPECurrentPortInfo",
            [c_void_p, c_void_p],
        )

        # Legacy export: DoPEOpenLink
        # Exported by the bundled DoPE.dll; not present in DoPE.pdf V2.88 extract.
        # unsigned Port, unsigned BaudRate, unsigned RcvBuffers, unsigned XmitBuffers,
        # unsigned DataBuffers, unsigned APIVersion, void* Reserved, DoPE_HANDLE* DoPEHdl
        self._DoPEOpenLink = self._bind(
            "DoPEOpenLink",
            [
                c_uint32,
                c_uint32,
                c_uint32,
                c_uint32,
                c_uint32,
                c_uint32,
                c_void_p,
                POINTER(c_void_p),
            ],
        )

        # 3.11 DoPECloseLink
        self._DoPECloseLink = self._bind("DoPECloseLink", [c_void_p])

        # 3.12 DoPESetNotification
        self._DoPESetNotification = self._bind(
            "DoPESetNotification",
            [c_void_p, c_uint32, DoPECallBackFunc, c_void_p, c_uint32],
        )

        # 3.13 DoPEInitialize
        self._DoPEInitialize = self._bind(
            "DoPEInitialize", [c_void_p, POINTER(c_uint16), POINTER(c_uint16)]
        )

        # 4.23 DoPESelSetup
        # UserScale FAR US (treat as void* for flexibility)
        self._DoPESelSetup = self._bind(
            "DoPESelSetup",
            [c_void_p, c_uint16, c_void_p, POINTER(c_uint16), POINTER(c_uint16)],
        )

        # 4.1 / 4.2 setup open/close (doc annotates TAN as not for Sync version)
        self._DoPEOpenSetup = self._bind("DoPEOpenSetup", [c_void_p, c_uint16])
        self._DoPECloseSetup = self._bind("DoPECloseSetup", [c_void_p])

        # 4.4 / 4.5 read/write whole setup (doc annotates TAN as not for Sync)
        # Setup pointer is a complex struct; use void*.
        self._DoPERdSetupAll = self._bind(
            "DoPERdSetupAll", [c_void_p, c_uint16, c_void_p]
        )
        self._DoPEWrSetupAll = self._bind(
            "DoPEWrSetupAll", [c_void_p, c_uint16, c_void_p]
        )

        # Legacy exports: message + data handling (exported by bundled DoPE.dll)
        # Not present in DoPE.pdf V2.88 extract.
        self._DoPESendMsg = self._bind(
            "DoPESendMsg", [c_void_p, c_void_p, c_uint32, POINTER(c_uint16)]
        )
        self._DoPEGetMsg = self._bind(
            "DoPEGetMsg", [c_void_p, c_void_p, c_uint32, POINTER(c_uint32)]
        )
        self._DoPEGetData = self._bind("DoPEGetData", [c_void_p, c_void_p])

        # 5.4 DoPECurrentData
        self._DoPECurrentData = self._bind("DoPECurrentData", [c_void_p, c_void_p])

        # 5.5/5.6 receiver/transmitter clear
        self._DoPEClearReceiver = self._bind("DoPEClearReceiver", [c_void_p])
        self._DoPEClearTransmitter = self._bind("DoPEClearTransmitter", [c_void_p])

        # 5.7 DoPEGetState (pointer to DoPEState struct; use void*)
        self._DoPEGetState = self._bind("DoPEGetState", [c_void_p, c_void_p])

        # 5.8 DoPEGetErrors (pointer to DoPEError struct; use void*)
        self._DoPEGetErrors = self._bind("DoPEGetErrors", [c_void_p, c_void_p])

        # 6.2.2 DoPESetTime(Sync)
        # Doc shows TAN marked "not for Sync version"; keep 2-arg sync signature.
        self._DoPESetTime = self._bind("DoPESetTime", [c_void_p, c_double])

        # 6.2.3 DoPETransmitData(Sync)
        self._DoPETransmitData = self._bind("DoPETransmitData", [c_void_p, c_uint16])

        # 6.2.5 DoPECtrlTestValues
        self._DoPECtrlTestValues = self._bind("DoPECtrlTestValues", [c_void_p, c_uint16])

        # 6.1 DoPERdVersion (pointer to DoPEVersion struct; use void*)
        self._DoPERdVersion = self._bind("DoPERdVersion", [c_void_p, c_void_p])

        # 8.2.1 DoPEPos(Sync): DoPE_HANDLE, unsigned short MoveCtrl, double Speed, double Destination, WORD* lpusTAN
        self._DoPEPos = self._bind(
            "DoPEPos", [c_void_p, c_uint16, c_double, c_double, POINTER(c_uint16)]
        )

        # 8.5.3 DoPEFMove(Sync): DoPE_HANDLE, unsigned short Direction, unsigned short MoveCtrl, double Speed, WORD* lpusTAN
        self._DoPEFMove = self._bind(
            "DoPEFMove", [c_void_p, c_uint16, c_uint16, c_double, POINTER(c_uint16)]
        )

        # 8.1.5 DoPESHalt(Sync): DoPE_HANDLE, WORD* lpusTAN
        self._DoPESHalt = self._bind("DoPESHalt", [c_void_p, POINTER(c_uint16)])

        # 8.1.1 DoPEHalt(Sync): DoPE_HANDLE, unsigned short MoveCtrl, WORD* lpusTAN
        self._DoPEHalt = self._bind(
            "DoPEHalt", [c_void_p, c_uint16, POINTER(c_uint16)]
        )

        # 11.1 DoPEOn(Sync) (TAN is marked "not for Sync" in doc; use 1 arg)
        self._DoPEOn = self._bind("DoPEOn", [c_void_p])

        # 11.4 DoPEStop(Sync): DoPE_HANDLE, unsigned short State, WORD* lpusTAN
        self._DoPEStop = self._bind(
            "DoPEStop", [c_void_p, c_uint16, POINTER(c_uint16)]
        )

        # 11.6 DoPEEmergencyOff(Sync) (TAN marked "not for Sync" in doc; use 2 args)
        self._DoPEEmergencyOff = self._bind("DoPEEmergencyOff", [c_void_p, c_uint16])

        # Optional / may exist depending on DLL build
        self._DoPEPosG2 = self._bind(
            "DoPEPosG2",
            [c_void_p, c_uint16, c_double, c_double, c_uint16, c_double, POINTER(c_uint16)],
        )
        self._DoPEFDPoti = self._bind("DoPEFDPoti", [c_void_p] * 8)  # unknown here; bind lazily if needed

    # ===== Public wrappers (tolerant call signatures) =====

    def DoPEOpenLink(
        self,
        port: int,
        baudrate: int,
        rcv_buffers: int = 10,
        xmit_buffers: int = 10,
        data_buffers: int = 10,
        api_version: int = 0x0288,
        reserved: int | None = None,
    ) -> tuple[int, Optional[c_void_p]]:
        """Open link (legacy export); returns (err, handle)."""
        if not self._DoPEOpenLink:
            raise AttributeError("DoPEOpenLink not found in DLL")
        handle = c_void_p()
        err = int(
            self._DoPEOpenLink(
                c_uint32(port),
                c_uint32(baudrate),
                c_uint32(rcv_buffers),
                c_uint32(xmit_buffers),
                c_uint32(data_buffers),
                c_uint32(api_version),
                c_void_p(reserved) if reserved is not None else None,
                ctypes.byref(handle),
            )
        )
        return err, handle if err == 0 else None

    def DoPEOpenDeviceID(
        self,
        device_id: int = 0,
        rcv_buffers: int = 10,
        xmit_buffers: int = 10,
        data_buffers: int = 10,
        api_version: int = 0x0288,
        reserved: int | None = None,
    ) -> tuple[int, Optional[c_void_p]]:
        """Open link by DeviceID (DoPE.pdf V2.88); returns (err, handle)."""
        if not self._DoPEOpenDeviceID:
            raise AttributeError("DoPEOpenDeviceID not found in DLL")
        handle = c_void_p()
        err = int(
            self._DoPEOpenDeviceID(
                c_uint32(device_id),
                c_uint32(rcv_buffers),
                c_uint32(xmit_buffers),
                c_uint32(data_buffers),
                c_uint32(api_version),
                c_void_p(reserved) if reserved is not None else None,
                ctypes.byref(handle),
            )
        )
        return err, handle if err == 0 else None

    def DoPEOpenFunctionID(
        self,
        function_id: int,
        rcv_buffers: int = 10,
        xmit_buffers: int = 10,
        data_buffers: int = 10,
        api_version: int = 0x0288,
        reserved: int | None = None,
    ) -> tuple[int, Optional[c_void_p]]:
        """Open link by FunctionID (DoPE.pdf V2.88); returns (err, handle)."""
        if not self._DoPEOpenFunctionID:
            raise AttributeError("DoPEOpenFunctionID not found in DLL")
        handle = c_void_p()
        err = int(
            self._DoPEOpenFunctionID(
                c_uint32(function_id),
                c_uint32(rcv_buffers),
                c_uint32(xmit_buffers),
                c_uint32(data_buffers),
                c_uint32(api_version),
                c_void_p(reserved) if reserved is not None else None,
                ctypes.byref(handle),
            )
        )
        return err, handle if err == 0 else None

    def DoPECloseLink(self, hdl) -> int:
        if not self._DoPECloseLink:
            raise AttributeError("DoPECloseLink not found in DLL")
        return int(self._DoPECloseLink(hdl))

    def DoPESetNotification(
        self,
        hdl,
        event_mask: int,
        callback: Optional[Callable[..., int]] = None,
        wnd_handle=None,
        message: int = 0,
    ) -> int:
        if not self._DoPESetNotification:
            raise AttributeError("DoPESetNotification not found in DLL")
        # Keep callback alive to prevent GC
        if callback is None:
            self._callback_ref = None
            cb = None
        else:
            cb = DoPECallBackFunc(callback)
            self._callback_ref = cb
        return int(
            self._DoPESetNotification(
                hdl, c_uint32(event_mask), cb, wnd_handle, c_uint32(message)
            )
        )

    def DoPESelSetup(self, hdl, setup_no: int, user_scale=None, tan_first=None, tan_last=None) -> int:
        if not self._DoPESelSetup:
            raise AttributeError("DoPESelSetup not found in DLL")
        return int(self._DoPESelSetup(hdl, c_uint16(setup_no), user_scale, tan_first, tan_last))

    def DoPEInitialize(self, hdl, tan_first=None, tan_last=None) -> int:
        if not self._DoPEInitialize:
            raise AttributeError("DoPEInitialize not found in DLL")
        return int(self._DoPEInitialize(hdl, tan_first, tan_last))

    def DoPEOpenSetup(self, *args) -> int:
        """Sync signature is (hdl, setup_no). Older code may pass TAN; it will be ignored."""
        if not self._DoPEOpenSetup:
            raise AttributeError("DoPEOpenSetup not found in DLL")
        if len(args) not in (2, 3):
            raise TypeError("DoPEOpenSetup expects 2 args (hdl, setup_no) (+ optional ignored tan)")
        hdl, setup_no = args[0], args[1]
        return int(self._DoPEOpenSetup(hdl, c_uint16(setup_no)))

    def DoPECloseSetup(self, *args) -> int:
        """Sync signature is (hdl). Older code may pass TAN; it will be ignored."""
        if not self._DoPECloseSetup:
            raise AttributeError("DoPECloseSetup not found in DLL")
        if len(args) not in (1, 2):
            raise TypeError("DoPECloseSetup expects 1 arg (hdl) (+ optional ignored tan)")
        return int(self._DoPECloseSetup(args[0]))

    def DoPERdSetupAll(self, *args) -> int:
        """Sync signature is (hdl, setup_no, setup_ptr). Older code may pass TANs; ignored."""
        if not self._DoPERdSetupAll:
            raise AttributeError("DoPERdSetupAll not found in DLL")
        if len(args) < 3:
            raise TypeError("DoPERdSetupAll expects at least 3 args (hdl, setup_no, setup_ptr)")
        hdl, setup_no, setup_ptr = args[0], args[1], args[2]
        return int(self._DoPERdSetupAll(hdl, c_uint16(setup_no), setup_ptr))

    def DoPEWrSetupAll(self, *args) -> int:
        """Sync signature is (hdl, setup_no, setup_ptr). Older code may pass TANs; ignored."""
        if not self._DoPEWrSetupAll:
            raise AttributeError("DoPEWrSetupAll not found in DLL")
        if len(args) < 3:
            raise TypeError("DoPEWrSetupAll expects at least 3 args (hdl, setup_no, setup_ptr)")
        hdl, setup_no, setup_ptr = args[0], args[1], args[2]
        return int(self._DoPEWrSetupAll(hdl, c_uint16(setup_no), setup_ptr))

    def DoPERdVersion(self, hdl, version_ptr) -> int:
        if not self._DoPERdVersion:
            raise AttributeError("DoPERdVersion not found in DLL")
        return int(self._DoPERdVersion(hdl, version_ptr))

    def DoPEGetData(self, hdl, buffer_ptr) -> int:
        if not self._DoPEGetData:
            raise AttributeError("DoPEGetData not found in DLL")
        return int(self._DoPEGetData(hdl, buffer_ptr))

    def DoPEPos(self, *args) -> int:
        """Tolerant DoPEPos wrapper.

        Supported call forms:
        - DoPEPos(hdl, move_ctrl, speed, destination)
        - DoPEPos(hdl, move_ctrl, speed, destination, tan_ptr)
        """
        if not self._DoPEPos:
            raise AttributeError("DoPEPos not found in DLL")
        if len(args) == 4:
            hdl, move_ctrl, speed, destination = args
            tan = None
        elif len(args) == 5:
            hdl, move_ctrl, speed, destination, tan = args
        else:
            raise TypeError("DoPEPos expects 4 or 5 args")
        return int(self._DoPEPos(hdl, c_uint16(move_ctrl), c_double(speed), c_double(destination), tan))

    def DoPEFMove(self, *args) -> int:
        """Tolerant DoPEFMove wrapper.

        Supported call forms:
        - DoPEFMove(hdl, direction, speed)  -> defaults move_ctrl=CTRL_POS
        - DoPEFMove(hdl, direction, move_ctrl, speed)
        - DoPEFMove(hdl, direction, move_ctrl, speed, tan_ptr)
        """
        if not self._DoPEFMove:
            raise AttributeError("DoPEFMove not found in DLL")
        if len(args) == 3:
            hdl, direction, speed = args
            move_ctrl = CTRL_POS
            tan = None
        elif len(args) == 4:
            hdl, direction, move_ctrl, speed = args
            tan = None
        elif len(args) == 5:
            hdl, direction, move_ctrl, speed, tan = args
        else:
            raise TypeError("DoPEFMove expects 3, 4, or 5 args")
        return int(self._DoPEFMove(hdl, c_uint16(direction), c_uint16(move_ctrl), c_double(speed), tan))

    def DoPEHalt(self, *args) -> int:
        """Tolerant DoPEHalt wrapper.

        Supported call forms:
        - DoPEHalt(hdl, move_ctrl)
        - DoPEHalt(hdl, move_ctrl, tan_ptr)
        """
        if not self._DoPEHalt:
            raise AttributeError("DoPEHalt not found in DLL")
        if len(args) == 2:
            hdl, move_ctrl = args
            tan = None
        elif len(args) == 3:
            hdl, move_ctrl, tan = args
        else:
            raise TypeError("DoPEHalt expects 2 or 3 args")
        return int(self._DoPEHalt(hdl, c_uint16(move_ctrl), tan))

    def DoPESetTime(self, *args) -> int:
        """Sync signature is (hdl, time). Older code may pass a third TAN arg; it will be ignored."""
        if not self._DoPESetTime:
            raise AttributeError("DoPESetTime not found in DLL")
        if len(args) not in (2, 3):
            raise TypeError("DoPESetTime expects 2 args (hdl, time) (+ optional ignored tan)")
        hdl, t = args[0], args[1]
        return int(self._DoPESetTime(hdl, c_double(t)))

    def DoPETransmitData(self, *args) -> int:
        """Sync signature is (hdl, enable). Older code may pass TAN; it will be ignored."""
        if not self._DoPETransmitData:
            raise AttributeError("DoPETransmitData not found in DLL")
        if len(args) not in (2, 3):
            raise TypeError("DoPETransmitData expects 2 args (hdl, enable) (+ optional ignored tan)")
        hdl, enable = args[0], args[1]
        return int(self._DoPETransmitData(hdl, c_uint16(enable)))

    def DoPEOn(self, *args) -> int:
        """Sync signature is (hdl). Older code may pass TAN; it will be ignored."""
        if not self._DoPEOn:
            raise AttributeError("DoPEOn not found in DLL")
        if len(args) not in (1, 2):
            raise TypeError("DoPEOn expects 1 arg (hdl) (+ optional ignored tan)")
        return int(self._DoPEOn(args[0]))

    def __repr__(self) -> str:
        return f"DoPEDLLDoPEPdf(loaded={self.loaded}, dll_path={self.dll_path!r})"


__all__ = [
    "DoPEDLLDoPEPdf",
    "DoPECallBackFunc",
    "MOVE_HALT",
    "MOVE_UP",
    "MOVE_DOWN",
    "CTRL_POS",
    "CTRL_LOAD",
    "CTRL_EXTENSION",
]
