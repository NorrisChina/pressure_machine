import unittest
from drivers.programm_dope_translated import TSteuerungAblauf


class SequenceEventsTests(unittest.TestCase):
    def test_start_sequence_counts_ctrl_move_events(self):
        ctrl = TSteuerungAblauf(driver=None)
        # start a sequence of 3 cycles
        ok = ctrl.start_sequence(cycles=3, interval=0.01)
        self.assertTrue(ok)
        # simulate three CTRL_MOVE events (code 3)
        ctrl._emit_event(3, {'sim': 1})
        ctrl._emit_event(3, {'sim': 2})
        ctrl._emit_event(3, {'sim': 3})
        # after events, the sequence should be finished
        self.assertFalse(ctrl._seq_active)
        self.assertEqual(ctrl._seq_count, 3)
        self.assertEqual(ctrl.state, ctrl.STATE_FINISH)


if __name__ == '__main__':
    unittest.main()
