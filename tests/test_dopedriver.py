import unittest
from drivers.dope_driver import DopeDriver


class DopeDriverTests(unittest.TestCase):
    def test_get_latest_data_when_no_dll(self):
        d = DopeDriver()
        self.assertFalse(d.loaded())
        res, data = d.get_latest_data(None)
        self.assertIsNone(res)
        self.assertIsNone(data)


if __name__ == '__main__':
    unittest.main()
