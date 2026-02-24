import unittest
from drivers.programm_dope_translated import read_setup, get_io_signals, get_out_channel_defs, DoPESetup


class ApiWrapperTests(unittest.TestCase):
    def test_read_setup_fallback(self):
        s = read_setup(driver=None)
        self.assertIsInstance(s, DoPESetup)

    def test_get_io_signals_fallback(self):
        ios = get_io_signals(driver=None)
        self.assertTrue(hasattr(ios, 'inputs') and hasattr(ios, 'outputs'))

    def test_get_out_channel_defs_fallback(self):
        defs = get_out_channel_defs(driver=None)
        self.assertIsInstance(defs, list)


if __name__ == '__main__':
    unittest.main()
