import time
import unittest
from drivers.programm_dope_translated import TSteuerungAblauf
from drivers.stub_driver import StubDopeDriver


class ControlLoopTests(unittest.TestCase):
    def test_run_loop_emits_events(self):
        stub = StubDopeDriver()
        stub.open_link()
        # attach stub to the controller
        ctrl = TSteuerungAblauf(driver=stub)
        events = []

        def on_event(ev, data):
            events.append((ev, data))

        ctrl.on_event(on_event)
        started = ctrl.start_loop(interval=0.05)
        self.assertTrue(started)
        # let it run for 0.5s
        time.sleep(0.5)
        ctrl.stop_loop()
        self.assertTrue(len(events) > 0)


if __name__ == '__main__':
    unittest.main()
