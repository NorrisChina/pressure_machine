import time
import unittest
from drivers.programm_dope_translated import TSteuerungAblauf
from drivers.stub_driver import StubDopeDriver


class SequenceIntegrationTests(unittest.TestCase):
    def test_measurement_auto_started_and_stopped(self):
        stub = StubDopeDriver()
        stub.open_link()
        ctrl = TSteuerungAblauf(driver=stub)
        # start sequence which should create and start measurement controller
        ok = ctrl.start_sequence(cycles=3, interval=0.01)
        self.assertTrue(ok)
        # measurement controller should have been created and started
        self.assertIsNotNone(ctrl.meas)
        # meas should be running
        # allow brief moment for thread start
        time.sleep(0.02)
        self.assertTrue(getattr(ctrl.meas, '_running', False))
        # simulate three move events
        ctrl._emit_event(3, {'sim': 1})
        ctrl._emit_event(3, {'sim': 2})
        ctrl._emit_event(3, {'sim': 3})
        # allow processing
        time.sleep(0.02)
        # sequence should be finished and measurement stopped
        self.assertFalse(ctrl._seq_active)
        self.assertEqual(ctrl._seq_count, 3)
        self.assertEqual(ctrl.state, ctrl.STATE_FINISH)
        self.assertFalse(getattr(ctrl.meas, '_running', True))

    def test_sequence_timeout_sets_error(self):
        stub = StubDopeDriver()
        stub.open_link()
        ctrl = TSteuerungAblauf(driver=stub)
        # set a short timeout
        ctrl._seq_timeout = 0.05
        ok = ctrl.start_sequence(cycles=10, interval=0.01)
        self.assertTrue(ok)
        # do not emit any events; wait for timeout
        time.sleep(0.12)
        self.assertFalse(ctrl._seq_active)
        self.assertEqual(ctrl.state, ctrl.STATE_ERROR)


if __name__ == '__main__':
    unittest.main()
