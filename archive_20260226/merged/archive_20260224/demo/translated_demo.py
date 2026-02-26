"""Run a small demo that uses the translated module with the StubDopeDriver.

This populates TDoPE, writes sample DoPEData into TMyDoPEData and the circular
buffer, and prints a small summary.
"""
from drivers.programm_dope_translated import TDoPE, TMyDoPEData
from drivers.stub_driver import StubDopeDriver


def main():
    do = TDoPE()
    # attach a stub driver
    do._driver = StubDopeDriver()

    # open link and collect some data
    ok = do.OpenLink() if hasattr(do, 'OpenLink') else do.OpenDll()
    print('open link ->', ok)

    # create buffer
    do.zirkular = None

    for i in range(6):
        d = do._driver.get_data()
        m = TMyDoPEData()
        m.Eintragen(d)
        # write into circular buffer on the TDoPE
        do.SchreibeZirkularPuffer(m.raw)

    lst = do.zirkular.read_all() if do.zirkular else []
    print('buffer len:', len(lst))
    for i, item in enumerate(lst[:6]):
        print(i, item)


if __name__ == '__main__':
    main()
