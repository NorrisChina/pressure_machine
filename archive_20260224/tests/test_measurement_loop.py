import time
import unittest
from drivers.programm_dope_translated import TSteuerungMessung
from drivers.stub_driver import StubDopeDriver


class MeasurementLoopTests(unittest.TestCase):
    def test_measurement_loop_writes_buffer(self):
        stub = StubDopeDriver()
        stub.open_link()
        meas = TSteuerungMessung(driver=stub)
        started = meas.start(interval=0.02)
        self.assertTrue(started)
        time.sleep(0.2)
        meas.stop()
        buf = meas.read_buffer()
        self.assertTrue(len(buf) > 0)


if __name__ == '__main__':
    unittest.main()
