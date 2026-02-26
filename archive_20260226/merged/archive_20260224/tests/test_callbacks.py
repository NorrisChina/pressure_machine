import unittest
from drivers.stub_driver import StubDopeDriver


class CallbackTests(unittest.TestCase):
    def test_stub_callback_invoked(self):
        called = []

        def cb(ev, data):
            called.append((ev, data))

        s = StubDopeDriver()
        s.open_link()
        s.register_callback(cb)
        # call get_data 5 times to trigger the callback on the 5th
        for i in range(5):
            s.get_data()
        self.assertTrue(len(called) >= 1)


if __name__ == '__main__':
    unittest.main()
