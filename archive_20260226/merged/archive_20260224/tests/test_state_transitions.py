import time
import unittest
from drivers.programm_dope_translated import TSteuerungAblauf
from drivers.stub_driver import StubDopeDriver


class StateTransitionTests(unittest.TestCase):
    def test_state_changes_on_ctrl_move(self):
        stub = StubDopeDriver()
        stub.open_link()
        ctrl = TSteuerungAblauf(driver=stub)
        # ensure controller starts idle
        ctrl.state = ctrl.STATE_IDLE
        started = ctrl.start_loop(interval=0.02)
        self.assertTrue(started)
        # wait for state to change to RUNNING due to CTRL_MOVE event
        timeout = time.time() + 1.5
        while time.time() < timeout:
            if ctrl.state == ctrl.STATE_RUNNING:
                break
            time.sleep(0.02)

        ctrl.stop_loop()
        self.assertEqual(ctrl.state, ctrl.STATE_RUNNING)


if __name__ == '__main__':
    unittest.main()
