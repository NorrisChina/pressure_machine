"""Launch the Qt UI with the StubDopeDriver for quick manual testing."""

from drivers.stub_driver import StubDopeDriver
from ui.app import run_app


def main():
    run_app(driver=StubDopeDriver())


if __name__ == "__main__":
    main()
