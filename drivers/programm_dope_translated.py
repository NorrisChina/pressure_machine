"""
First-pass translation of key symbols and routines found in `Programm_DOPE .xlsx`.

This file is an automated, conservative translation from the extracted
spreadsheet (Delphi/Pascal identifiers and notes). It provides:
- constants inferred from the sheet (e.g. API version)
- Python function stubs for prominent DoPE APIs mentioned
- simple Python class skeletons mirroring Delphi classes named in the sheet

The implementations are intentionally conservative: stubs raise
`NotImplementedError` or delegate to the existing `DopeDriver` wrapper
if available. Use this as a starting point for manually filling in
behavior and types once you review the mapping.
"""
from typing import Any, Optional

# Inferred constants
DOPE_API_VERSION = 0x0289


# --- Helpful utilities discovered in the XLSX (bitmask helpers, etc.) ---
def decode_ctrl_status_word(word: int) -> dict:
    """Return a dict of likely flag names found in the spreadsheet based on bit positions.

    This is conservative and intended as a human-readable helper for the UI/logging.
    """
    flags = {}
    try:
        # Common bits mentioned: CTRL_READY (0x40), CTRL_MOVE (0x80), CTRL_FREE (0x8000)
        flags['CTRL_READY'] = bool(word & 0x40)
        flags['CTRL_MOVE'] = bool(word & 0x80)
        flags['CTRL_FREE'] = bool(word & 0x8000)
    except Exception:
        pass
    return flags


# --- Function stubs (translate Delphi API names to Python callables) ---
def DoPEOpenDeviceID(device_id: int) -> Any:
    """Open device by numeric ID. Translate to DopeDriver if available."""
    try:
        from drivers.dope_driver import DopeDriver
        d = DopeDriver()
        if hasattr(d, 'open_device_id'):
            return d.open_device_id(device_id)
    except Exception:
        pass
    raise NotImplementedError("DoPEOpenDeviceID not implemented for your setup")


def DoPEOpenFunctionID(func_id: int) -> Any:
    try:
        from drivers.dope_driver import DopeDriver
        d = DopeDriver()
        if hasattr(d, 'open_function_id'):
            return d.open_function_id(func_id)
    except Exception:
        pass
    raise NotImplementedError("DoPEOpenFunctionID not implemented")


def DoPESetNotification(dhandle: int, evmask: int, callback: Any, wnd_handle: Optional[int] = None):
    """Set notification mode. Wrapper should map to DopeDriver.set_notification.

    The original Delphi signature is: DoPESetNotification(DHandle EvMask DoPECallBack WndHandle CM_CbMessage)
    """
    try:
        from drivers.dope_driver import DopeDriver
        d = DopeDriver()
        if hasattr(d, 'set_notification'):
            return d.set_notification(dhandle, evmask, callback, wnd_handle)
    except Exception:
        pass
    raise NotImplementedError("DoPESetNotification not implemented in wrapper")


def DoPEGetData(*args, **kwargs):
    """Retrieve next DoPE data record. Returns a DoPEData-like object or dict.

    The sheet mentions `DoPEGetData` / `DoPEGetData nach DoPE.DData` and using
    circular buffers. The real binding should return the `DoPEData` structure.
    """
    try:
        from drivers.dope_driver import DopeDriver
        d = DopeDriver()
        if hasattr(d, 'get_data'):
            return d.get_data()
    except Exception:
        pass
    raise NotImplementedError("DoPEGetData wrapper not implemented")


# --- Class skeletons inferred from the sheet ---
class TDoPE:
    """Skeleton for the TDoPE controller class.

    Methods and fields here are placeholders discovered in the spreadsheet
    (e.g. `OpenDll`, `CloseDll`, `OpenLink`, `CloseLink`, `ReadSensorInfo`,
    `AnzeigenSetup`, and callback/channel fields).
    """

    def __init__(self):
        self._driver = None

    def OpenDll(self):
        """Load/initialize DLL (map to DopeDriver.open_dll/open).
        """
        try:
            from drivers.dope_driver import DopeDriver
            self._driver = DopeDriver()
            return self._driver.loaded()
        except Exception:
            return False

    def CloseDll(self):
        if self._driver and hasattr(self._driver, 'close_dll'):
            return self._driver.close_dll()
        self._driver = None

    def OpenLink(self):
        if self._driver and hasattr(self._driver, 'open_link'):
            return self._driver.open_link()
        raise NotImplementedError

    def CloseLink(self):
        if self._driver and hasattr(self._driver, 'close'):
            return self._driver.close()
        raise NotImplementedError

    def ReadSensorInfo(self):
        if self._driver and hasattr(self._driver, 'read_sensor_info'):
            return self._driver.read_sensor_info()
        raise NotImplementedError

    def AnzeigenSetup(self):
        # Show/return setup info
        raise NotImplementedError

    # Convenience: write data into the circular buffer if available
    def SchreibeZirkularPuffer(self, item: Any):
        """Append an item to an internal circular buffer if present."""
        try:
            if not getattr(self, 'zirkular', None):
                self.zirkular = TZirkularPuffer(1024)
            self.zirkular.write(item)
            return True
        except Exception:
            return False


class TMyDoPEData:
    """Placeholder for the translated DoPE data holder (TMyDoPEData).

    The sheet contained notes about methods like `Eintragen(var Data : DoPEData)`
    and `Lese(var Data : TMyRecData) : Boolean`.
    """

    def __init__(self):
        self.raw = None

    def Eintragen(self, data):
        """Populate internal fields from a DoPEData record/object."""
        # Accept dict-like, ctypes.Structure (DoPEData), or other objects
        if data is None:
            self.raw = None
            return

        # If it's a ctypes Structure, convert to dict
        try:
            from ctypes import Structure as _CStruct
        except Exception:
            _CStruct = None

        if _CStruct is not None and isinstance(data, _CStruct):
            d = {}
            for fname, _ in getattr(data, '_fields_', []):
                try:
                    d[fname] = getattr(data, fname)
                except Exception:
                    d[fname] = None
            self.raw = d
            return

        # If it's a dict-like
        if isinstance(data, dict):
            self.raw = dict(data)
            return

        # Otherwise store repr
        self.raw = {'value': data}

    def Lese(self):
        """Return the stored record or False if none."""
        return bool(self.raw)

    def scale_and_map(self, setup=None):
        """Apply setup scaling and return a mapped dict of important fields.

        - Uses `UserScale` from `DoPESetup` to scale sensor values (if present).
        - Returns a dict with keys: Cycles, Time, Position, Load, Sensors (list), CtrlStatus
        """
        if not self.raw:
            return None

        d = dict(self.raw) if isinstance(self.raw, dict) else {'value': self.raw}

        # apply user scale if provided
        scale = 1.0
        try:
            if setup is not None:
                # support both attribute name user_scale and UserScale
                scale = float(getattr(setup, 'user_scale', getattr(setup, 'UserScale', 1.0)))
        except Exception:
            scale = 1.0

        out = {}
        out['Cycles'] = int(d.get('Cycles')) if d.get('Cycles') is not None else None
        out['Time'] = float(d.get('Time')) if d.get('Time') is not None else None
        try:
            out['Position'] = float(d.get('Position')) * scale if d.get('Position') is not None else None
        except Exception:
            out['Position'] = d.get('Position')
        try:
            out['Load'] = float(d.get('Load')) * scale if d.get('Load') is not None else None
        except Exception:
            out['Load'] = d.get('Load')

        # sensors can be a list or array
        sensors = d.get('sensors') or d.get('Sensor') or []
        try:
            if sensors is None:
                sensors = []
            sensors_mapped = [float(x) * scale for x in sensors]
        except Exception:
            sensors_mapped = sensors if isinstance(sensors, list) else [sensors]

        out['Sensors'] = sensors_mapped

        # ctrl status
        out['CtrlStatus'] = d.get('ctrl_status') or (d.get('CtrlStatus') and d.get('CtrlStatus')[0])
        return out


class TZirkularPuffer:
    """A small Python circular buffer to mirror the Delphi `ZirkularPuffer`.

    Usage:
        buf = TZirkularPuffer(size)
        buf.write(item)
        lst = buf.read_all()
    """

    def __init__(self, capacity: int = 256):
        self.capacity = int(max(1, capacity))
        self._buf = [None] * self.capacity
        self._head = 0
        self._size = 0

    def write(self, item: Any) -> None:
        self._buf[self._head] = item
        self._head = (self._head + 1) % self.capacity
        if self._size < self.capacity:
            self._size += 1

    def read_all(self) -> list:
        out = []
        start = (self._head - self._size) % self.capacity
        for i in range(self._size):
            out.append(self._buf[(start + i) % self.capacity])
        return out

    def clear(self) -> None:
        self._buf = [None] * self.capacity
        self._head = 0
        self._size = 0



__all__ = [
    'DOPE_API_VERSION', 'DoPEOpenDeviceID', 'DoPEOpenFunctionID', 'DoPESetNotification',
    'DoPEGetData', 'TDoPE', 'TMyDoPEData'
]

# Additional conservative stubs discovered in the spreadsheet
def DoPEOutChaDef(*args, **kwargs):
    """Stub for DoPEOutChaDef - output channel definition."""
    raise NotImplementedError


def DoPEMachineDef(*args, **kwargs):
    """Stub for DoPEMachineDef - machine definition."""
    raise NotImplementedError


def DoPEIOSignals(*args, **kwargs):
    """Stub for DoPEIOSignals - IO signals mapping."""
    raise NotImplementedError


def DoPESetup(*args, **kwargs):
    """Stub for DoPESetup - read/write setup structure."""
    raise NotImplementedError


class TSteuerungAblauf:
    """Simplified control/state machine skeleton.

    This class represents a high-level process controller (Ablauf = sequence).
    Methods are placeholders to be expanded when translating the Pascal logic.
    """

    STATE_IDLE = 'idle'
    STATE_RUNNING = 'running'
    STATE_PAUSED = 'paused'
    STATE_ERROR = 'error'
    # Additional states inferred from measurement/control sequences
    STATE_PREPARE = 'prepare'
    STATE_MEASURING = 'measuring'
    STATE_FINISH = 'finish'

    def __init__(self, driver=None):
        self.state = self.STATE_IDLE
        self.driver = driver
        self._event_handlers = []
        # run-loop related
        self._running = False
        self._thread = None
        self._interval = 0.5
        self._internal_registered = False
        # register internal handler so state updates follow incoming events
        try:
            self.on_event(self._internal_event_handler)
        except Exception:
            pass
        # sequence control
        self._seq_target = 0
        self._seq_count = 0
        self._seq_interval = 0.1
        self._seq_active = False
        self._last_event_time = None
        self._seq_timeout = 2.0
        self.meas = None

    def on_event(self, handler):
        """Register a handler(event:int, data:dict) for events from driver."""
        self._event_handlers.append(handler)
        # If driver is a stub, register it there too
        try:
            if getattr(self.driver, '__class__', None) is not None and hasattr(self.driver, 'register_callback'):
                # owner link so stub_driver can set driver._owner
                try:
                    setattr(self.driver, '_owner', self.driver)
                except Exception:
                    pass
        except Exception:
            pass

    def _emit_event(self, event, data):
        for h in self._event_handlers:
            try:
                h(event, data)
            except Exception:
                pass

    def _internal_event_handler(self, event, data):
        """Default internal mapping from events to state transitions.

        - event 1: raw data available (no state change)
        - event 2: CTRL_READY -> set idle
        - event 3: CTRL_MOVE  -> set running
        - event 4: CTRL_FREE  -> set idle
        """
        import time
        try:
            # record last event time
            try:
                self._last_event_time = time.time()
            except Exception:
                pass

            # Basic mapping
            if event == 2:
                # ready
                if not self._seq_active:
                    self.state = self.STATE_IDLE
            elif event == 3:
                # move
                self.state = self.STATE_RUNNING
                if self._seq_active:
                    try:
                        self._seq_count += 1
                        # when target reached, mark finished
                        if self._seq_target > 0 and self._seq_count >= self._seq_target:
                            # stop measurement if running
                            try:
                                if self.meas is not None:
                                    try:
                                        self.meas.stop()
                                    except Exception:
                                        pass
                            except Exception:
                                pass
                            self._seq_active = False
                            self.state = self.STATE_FINISH
                            try:
                                # emit a sequence-finished event (code 5)
                                self._emit_event(5, {'seq_count': self._seq_count, 'target': self._seq_target})
                            except Exception:
                                pass
                    except Exception:
                        pass
            elif event == 4:
                # free
                if not self._seq_active:
                    self.state = self.STATE_IDLE
        except Exception:
            pass

    def start(self):
        if self.state == self.STATE_RUNNING:
            return False
        self.state = self.STATE_RUNNING
        # register a forwarding callback if driver supports it
        try:
            if self.driver and hasattr(self.driver, 'register_callback'):
                try:
                    self.driver.register_callback(lambda ev, d: self._emit_event(ev, d))
                except Exception:
                    pass
        except Exception:
            pass
        return True

    # --- Sequence helpers ---
    def start_sequence(self, cycles: int = 5, interval: float = 0.1):
        """Begin a measurement sequence: wait for CTRL_MOVE events and count them.

        This is a conservative implementation: it does not drive hardware, it
        only uses incoming events to count 'moves' and mark completion.
        """
        try:
            import threading, time

            self._seq_target = int(max(0, cycles))
            self._seq_count = 0
            self._seq_interval = float(interval)
            self._seq_active = True
            self.state = self.STATE_PREPARE

            # create a measurement controller if available
            try:
                self.meas = TSteuerungMessung(driver=self.driver)
                try:
                    self.meas.start(self._seq_interval)
                except Exception:
                    pass
            except Exception:
                self.meas = None

            # initialize last event time and start a watcher thread to detect timeouts
            try:
                self._last_event_time = time.time()
            except Exception:
                pass
            def _watcher():
                while self._seq_active:
                    try:
                        now = time.time()
                        last = self._last_event_time or now
                        if (now - last) > float(self._seq_timeout):
                            # abort sequence with error
                            try:
                                self._seq_active = False
                                self.state = self.STATE_ERROR
                                try:
                                    # emit a sequence-error event (code 6)
                                    self._emit_event(6, {'reason': 'timeout'})
                                except Exception:
                                    pass
                                # stop measurement if running
                                if self.meas is not None:
                                    try:
                                        self.meas.stop()
                                    except Exception:
                                        pass
                                break
                            except Exception:
                                pass
                    except Exception:
                        pass
                    time.sleep(min(0.1, self._seq_interval))

            t = threading.Thread(target=_watcher, daemon=True)
            t.start()
            return True
        except Exception:
            return False

    def stop_sequence(self):
        self._seq_active = False
        self._seq_count = 0
        self._seq_target = 0
        self.state = self.STATE_IDLE
        return True

    def start_loop(self, interval: float = 0.5):
        """Start a background thread that polls the driver at `interval` seconds
        and emits events for each sample.
        """
        if self._running:
            return False
        self._interval = float(interval)
        self._running = True

        import threading
        # register a forwarding callback with the driver so external driver
        # events are forwarded into this controller's handlers
        try:
            if self.driver and hasattr(self.driver, 'register_callback'):
                try:
                    self.driver.register_callback(lambda ev, d: self._emit_event(ev, d))
                except Exception:
                    pass
        except Exception:
            pass

        def _worker():
            while self._running:
                try:
                    # Prefer get_latest_data if available
                    if self.driver is not None:
                        if hasattr(self.driver, 'get_latest_data'):
                            try:
                                res, d = self.driver.get_latest_data(getattr(self.driver, 'handle', None))
                            except Exception:
                                res, d = None, None
                        elif hasattr(self.driver, 'get_data'):
                            try:
                                # some drivers return dict directly
                                val = self.driver.get_data()
                                res, d = None, val
                            except Exception:
                                res, d = None, None
                        else:
                            res, d = None, None

                        if d is not None:
                            # emit a generic data-available event (code 1)
                            try:
                                self._emit_event(1, d)
                            except Exception:
                                pass

                            # If we have a ctrl_status word, decode flags and emit
                            # separate semantic events so higher layers can react.
                            try:
                                cs = None
                                if isinstance(d, dict):
                                    cs = d.get('ctrl_status') or d.get('CtrlStatus') or d.get('Ctrl_Status')
                                else:
                                    # try attribute access
                                    cs = getattr(d, 'ctrl_status', None)
                                if cs is not None:
                                    flags = decode_ctrl_status_word(int(cs))
                                    # Emit events for each true flag with codes >1
                                    if flags.get('CTRL_READY'):
                                        try:
                                            self._emit_event(2, {'flag': 'CTRL_READY', 'data': d})
                                        except Exception:
                                            pass
                                    if flags.get('CTRL_MOVE'):
                                        try:
                                            self._emit_event(3, {'flag': 'CTRL_MOVE', 'data': d})
                                        except Exception:
                                            pass
                                    if flags.get('CTRL_FREE'):
                                        try:
                                            self._emit_event(4, {'flag': 'CTRL_FREE', 'data': d})
                                        except Exception:
                                            pass
                            except Exception:
                                pass
                except Exception:
                    pass
                try:
                    threading.Event().wait(self._interval)
                except Exception:
                    import time

                    time.sleep(self._interval)

        self._thread = threading.Thread(target=_worker, daemon=True)
        self._thread.start()
        return True

    def stop_loop(self):
        """Stop the background polling loop."""
        self._running = False
        if self._thread is not None:
            try:
                self._thread.join(timeout=1.0)
            except Exception:
                pass
            self._thread = None
        return True

    def stop(self):
        self.state = self.STATE_IDLE

    def pause(self):
        if self.state == self.STATE_RUNNING:
            self.state = self.STATE_PAUSED

    def resume(self):
        if self.state == self.STATE_PAUSED:
            self.state = self.STATE_RUNNING


class TSteuerungMessung:
    """Simplified measurement controller.

    Stores configuration and executes measurement steps. This is a thin
    skeleton mirroring the Delphi class names so we can flesh them out later.
    """

    def __init__(self, driver=None):
        self.driver = driver
        self.active = False
        self.zirkular = TZirkularPuffer(512)
        self._running = False
        self._thread = None
        self._interval = 0.1

    def start(self, interval: float = 0.1):
        """Start continuous measurement loop polling the driver every `interval` seconds."""
        if self._running:
            return False
        self._interval = float(interval)
        self._running = True
        self.active = True

        import threading, time

        def _worker():
            while self._running:
                try:
                    # prefer get_latest_data
                    if hasattr(self.driver, 'get_latest_data'):
                        try:
                            res, d = self.driver.get_latest_data(getattr(self.driver, 'handle', None))
                        except Exception:
                            res, d = None, None
                    elif hasattr(self.driver, 'get_data'):
                        try:
                            d = self.driver.get_data()
                        except Exception:
                            d = None
                    else:
                        d = None

                    if d is not None:
                        # normalize dict-like
                        if not isinstance(d, dict):
                            # attempt conversion if object with _fields_
                            try:
                                from ctypes import Structure as _CStruct
                                if isinstance(d, _CStruct):
                                    dd = {}
                                    for fname, _ in getattr(d, '_fields_', []):
                                        try:
                                            dd[fname] = getattr(d, fname)
                                        except Exception:
                                            dd[fname] = None
                                    d = dd
                                else:
                                    d = {'value': d}
                            except Exception:
                                d = {'value': d}

                        # write into our circular buffer
                        try:
                            self.zirkular.write(d)
                        except Exception:
                            pass
                except Exception:
                    pass
                time.sleep(self._interval)

        self._thread = threading.Thread(target=_worker, daemon=True)
        self._thread.start()
        return True

    def stop(self):
        self._running = False
        self.active = False
        if self._thread is not None:
            try:
                self._thread.join(timeout=1.0)
            except Exception:
                pass
            self._thread = None
        return True

    def read_buffer(self):
        return self.zirkular.read_all()

    def start_measurement_sequence(self, cycles: int = 5, interval: float = 0.1):
        """Run a simple measurement sequence: collect `cycles` samples at `interval` seconds.

        This is a high-level helper to emulate the measurement flow from the Pascal
        code: it triggers driver polling and writes results into the internal
        `zirkular` buffer. Returns number of samples collected.
        """
        import time

        collected = 0
        if self.driver is None:
            return collected

        for i in range(cycles):
            try:
                if hasattr(self.driver, 'get_latest_data'):
                    res, d = self.driver.get_latest_data(getattr(self.driver, 'handle', None))
                    data = d
                else:
                    data = self.driver.get_data()
                if data is not None:
                    # normalize to dict
                    if not isinstance(data, dict):
                        try:
                            from ctypes import Structure as _CStruct
                            if isinstance(data, _CStruct):
                                dd = {}
                                for fname, _ in getattr(data, '_fields_', []):
                                    try:
                                        dd[fname] = getattr(data, fname)
                                    except Exception:
                                        dd[fname] = None
                                data = dd
                            else:
                                data = {'value': data}
                        except Exception:
                            data = {'value': data}
                    self.zirkular.write(data)
                    collected += 1
            except Exception:
                pass
            time.sleep(interval)

        return collected

    def initialize(self):
        # translate any required setup calls
        self.active = True

    def run_step(self):
        # perform a single step / acquisition cycle
        if not self.active:
            return None
        if self.driver is None:
            return None
        # delegate to driver.get_latest_data if present
        try:
            if hasattr(self.driver, 'get_latest_data'):
                return self.driver.get_latest_data(getattr(self.driver, 'handle', None))
        except Exception:
            return None


from dataclasses import dataclass


@dataclass
class DoPESetup:
    """Conservative Python representation for setup structure."""
    setup_no: int = 0
    user_scale: float = 1.0
    description: str = ""

    @classmethod
    def from_dict(cls, d: dict):
        if not isinstance(d, dict):
            return cls()
        return cls(setup_no=int(d.get('SetupNo', 0)), user_scale=float(d.get('UserScale', 1.0)), description=str(d.get('Description', '')))


@dataclass
class DoPEOutChaDef:
    name: str = ""
    channel: int = 0

    @classmethod
    def from_dict(cls, d: dict):
        return cls(name=d.get('name', ''), channel=int(d.get('channel', 0)))


@dataclass
class DoPEMachineDef:
    model: str = ""
    serial: str = ""

    @classmethod
    def from_dict(cls, d: dict):
        return cls(model=d.get('model', ''), serial=d.get('serial', ''))


@dataclass
class DoPEIOSignals:
    inputs: dict = None
    outputs: dict = None

    @classmethod
    def from_dict(cls, d: dict):
        return cls(inputs=d.get('inputs', {}) if isinstance(d, dict) else {}, outputs=d.get('outputs', {}) if isinstance(d, dict) else {})


# --- Conservative wrapper helpers that try to use DopeDriver when available ---
def read_setup(driver=None) -> DoPESetup:
    """Read current setup from driver if available, otherwise return default DoPESetup."""
    if driver is None:
        # try to create a driver
        try:
            from drivers.dope_driver import DopeDriver
            driver = DopeDriver()
        except Exception:
            driver = None

    # If the driver exposes a read_setup method, call it
    if driver is not None and hasattr(driver, 'read_setup'):
        try:
            raw = driver.read_setup()
            if isinstance(raw, dict):
                return DoPESetup.from_dict(raw)
        except Exception:
            pass

    # Fallback: return default
    return DoPESetup()


def write_setup(setup: DoPESetup, driver=None) -> bool:
    """Write a DoPESetup to the driver if available. Returns True on success."""
    if driver is None:
        try:
            from drivers.dope_driver import DopeDriver
            driver = DopeDriver()
        except Exception:
            driver = None

    if driver is not None and hasattr(driver, 'write_setup'):
        try:
            return bool(driver.write_setup(setup.__dict__))
        except Exception:
            return False

    # Not implemented for this environment
    return False


def get_io_signals(driver=None) -> DoPEIOSignals:
    """Return IO signals mapping; try driver, otherwise empty structure."""
    if driver is None:
        try:
            from drivers.dope_driver import DopeDriver
            driver = DopeDriver()
        except Exception:
            driver = None

    if driver is not None and hasattr(driver, 'get_io_signals'):
        try:
            raw = driver.get_io_signals()
            if isinstance(raw, dict):
                return DoPEIOSignals.from_dict(raw)
        except Exception:
            pass

    return DoPEIOSignals()


def get_out_channel_defs(driver=None):
    """Return list of DoPEOutChaDef from driver or empty list."""
    if driver is None:
        try:
            from drivers.dope_driver import DopeDriver
            driver = DopeDriver()
        except Exception:
            driver = None

    if driver is not None and hasattr(driver, 'get_out_channel_defs'):
        try:
            raw = driver.get_out_channel_defs()
            if isinstance(raw, list):
                return [DoPEOutChaDef.from_dict(x) if isinstance(x, dict) else x for x in raw]
        except Exception:
            pass

    return []


