"""Small self-test for the DoPE driver/constants."""
from drivers.dope_driver import DopeDriver
import drivers.dope_constants as consts


def run():
    print("DoPE selftest:\n")
    drv = DopeDriver()
    print("DLL loaded:", drv.loaded())
    print("Sample masks:")
    print(" CTRL_READY:", hex(consts.CTRL_READY))
    print(" CTRL_FREE:", hex(consts.CTRL_FREE))
    print(" SYNCH_STATE_MASK:", hex(consts.SYNCH_STATE_MASK))
    print("Decode example for word 0xC0:", consts.decode_ctrl_status(0xC0))


if __name__ == '__main__':
    run()
