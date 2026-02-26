"""A simple in-process stub driver used when the real DOPE DLL is not available.

The stub exposes the minimal interface used by the UI:
- loaded()
- open_link()
- close()
- get_data()

It returns simple dictionary-shaped sample data for easy logging/testing.
"""
import time
import random


class StubDopeDriver:
    def __init__(self):
        self._open = False
        self._counter = 0
        self._callback = None

    def loaded(self) -> bool:
        # Stub is always "available" for UI testing
        return True

    def open_link(self) -> bool:
        self._open = True
        self._counter = 0
        return True

    def register_callback(self, callback):
        """Register a callback to be called when events occur.

        Callback signature: callback(event:int, data:dict)
        """
        self._callback = callback
        # Also register with the higher-level DopeDriver callback slot if present
        try:
            # If this stub was attached to a TDoPE._driver or similar, attempt
            # to populate _py_event_callback attribute to mimic DopeDriver
            if hasattr(self, '_owner') and getattr(self, '_owner', None) is not None:
                try:
                    setattr(self._owner, '_py_event_callback', callback)
                except Exception:
                    pass
        except Exception:
            pass
        return True

    def close(self) -> None:
        self._open = False

    def get_data(self):
        """Return a small sample of data similar to what a real driver might provide.

        Returns a dict with timestamp, a simulated controller status word, and
        a small sensors array.
        """
        if not self._open:
            return None

        self._counter += 1
        ts = time.time()
        # Simulate some status bits and sensor values
        ctrl_status = 0x40 if (self._counter % 5 != 0) else 0xC0
        sensors = [round(10.0 * random.random(), 3) for _ in range(4)]

        out = {
            "tick": self._counter,
            "timestamp": ts,
            "ctrl_status": ctrl_status,
            "sensors": sensors,
        }

        # Simulate an event callback occasionally
        try:
            if self._callback and (self._counter % 5 == 0):
                # Event code 1 -> DATA_AVAILABLE
                try:
                    self._callback(1, out)
                except Exception:
                    pass
        except Exception:
            pass

        return out
