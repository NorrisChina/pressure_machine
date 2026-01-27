import unittest
from drivers.programm_dope_translated import TZirkularPuffer


class BufferTests(unittest.TestCase):
    def test_write_and_read(self):
        buf = TZirkularPuffer(4)
        buf.write(1)
        buf.write(2)
        buf.write(3)
        self.assertEqual(buf.read_all(), [1, 2, 3])
        buf.write(4)
        buf.write(5)
        self.assertEqual(buf.read_all(), [2, 3, 4, 5])

    def test_clear(self):
        buf = TZirkularPuffer(3)
        buf.write('a')
        buf.clear()
        self.assertEqual(buf.read_all(), [])


if __name__ == '__main__':
    unittest.main()
