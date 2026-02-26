import time
import unittest
from drivers.programm_dope_translated import TSteuerungAblauf
from drivers.stub_driver import StubDopeDriver


class ControlEventsTests(unittest.TestCase):
    def test_ctrl_move_event_emitted(self):
        stub = StubDopeDriver()
        stub.open_link()
        ctrl = TSteuerungAblauf(driver=stub)
        events = []

        def on_event(ev, data):
            events.append((ev, data))

        ctrl.on_event(on_event)
        started = ctrl.start_loop(interval=0.02)
        self.assertTrue(started)
        # wait until we see at least one CTRL_MOVE event or timeout
        timeout = time.time() + 1.5
        seen_move = False
        while time.time() < timeout:
            for ev, d in list(events):
                if ev == 3:
                    # event code 3 maps to CTRL_MOVE
                    seen_move = True
                    break
            if seen_move:
                break
            time.sleep(0.02)

        ctrl.stop_loop()
        self.assertTrue(seen_move, msg=f"No CTRL_MOVE event seen, events={events}")


if __name__ == '__main__':
    unittest.main()
