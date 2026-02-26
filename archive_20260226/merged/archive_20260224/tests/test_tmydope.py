import unittest
from drivers.programm_dope_translated import TMyDoPEData


class TMyDoPETests(unittest.TestCase):
    def test_eintragen_dict(self):
        t = TMyDoPEData()
        data = {'Cycles': 123, 'Sensor': [1.0, 2.0]}
        t.Eintragen(data)
        self.assertTrue(t.Lese())
        self.assertEqual(t.raw['Cycles'], 123)

    def test_eintragen_none(self):
        t = TMyDoPEData()
        t.Eintragen(None)
        self.assertFalse(t.Lese())


if __name__ == '__main__':
    unittest.main()
