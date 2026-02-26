import unittest
from drivers.programm_dope_translated import TSteuerungMessung
from drivers.stub_driver import StubDopeDriver


class MeasurementSequenceTests(unittest.TestCase):
    def test_sequence_collects_samples(self):
        stub = StubDopeDriver()
        stub.open_link()
        meas = TSteuerungMessung(driver=stub)
        n = meas.start_measurement_sequence(cycles=5, interval=0.01)
        self.assertEqual(n, 5)
        buf = meas.read_buffer()
        self.assertEqual(len(buf), 5)


if __name__ == '__main__':
    unittest.main()
