import unittest
from drivers.programm_dope_translated import TMyDoPEData, DoPESetup


class TMyDoPEScalingTests(unittest.TestCase):
    def test_scaling_applied(self):
        t = TMyDoPEData()
        raw = {'Cycles': 1, 'Time': 0.1, 'Position': 2.0, 'Load': 5.0, 'sensors': [1.0, 2.0]}
        t.Eintragen(raw)
        setup = DoPESetup(user_scale=2.0)
        mapped = t.scale_and_map(setup)
        self.assertEqual(mapped['Position'], 4.0)
        self.assertEqual(mapped['Load'], 10.0)
        self.assertEqual(mapped['Sensors'][0], 2.0)


if __name__ == '__main__':
    unittest.main()
