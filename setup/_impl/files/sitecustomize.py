import os

if 'DEV_ENV' in os.environ:
    from rich.traceback import install

    install(show_locals=True)
