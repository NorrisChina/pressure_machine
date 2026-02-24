"""Console demo: poll the `StubDopeDriver` and print sample outputs."""
import time

from drivers.stub_driver import StubDopeDriver


def main():
    d = StubDopeDriver()
    print("StubDopeDriver loaded:", d.loaded())
    ok = d.open_link()
    print("open_link ->", ok)

    try:
        for i in range(10):
            data = d.get_data()
            print(f"sample {i}:", data)
            time.sleep(0.3)
    finally:
        d.close()
        print("closed")


if __name__ == "__main__":
    main()
