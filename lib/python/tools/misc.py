import platform
import socket
import subprocess
import sys
import time
from itertools import islice


def contains(file_, key):
    with open(file_, 'rt') as f:
        for line in f.readlines():
            if line.rstrip() == key.rstrip():
                return True
    return False


def addIfNotPresent(file_, key):
    for line in key.splitlines():
        if not contains(file_, line):
            with open(file_, 'at') as f:
                print(key, file=f)


def getMyIp():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(('8.8.8.8', 1))
        ip = s.getsockname()[0]
    except Exception:  # pylint: disable=broad-except
        ip = '127.0.0.1'
    finally:
        s.close()
    return ip


def isInternetReachable():
    param = '-n' if platform.system().lower() == 'windows' else '-c'
    command = ['ping', param, '1', 'google.com']
    for _ in range(3):
        ret = subprocess.run(command, check=False, capture_output=True)
        if ret.returncode == 0:
            return True
        time.sleep(2)
    return False


DEBUG = '--debug' in sys.argv
QUIET = '--quiet' in sys.argv


def debug(*args, **kwargs):
    if DEBUG:
        print(*args, **kwargs, file=sys.stderr)


def eprint(*args, **kwargs):
    if not QUIET:
        print(*args, **kwargs, file=sys.stderr)


def confirm(prompt, defaultIfNotTty=False):
    if not sys.stdout.isatty():
        return defaultIfNotTty
    return input(f'{prompt} [y/N] ').strip().lower() == 'y'


def confirmOrExit(prompt):
    confirm = input(f"{prompt}, type 'YES' to confirm: ")
    if confirm.rstrip() != 'YES':
        print('ABORTING')
        sys.exit(1)


def chunked(it, size):
    it = iter(it)
    return iter(lambda: tuple(islice(it, size)), ())


class RetryException(Exception):
    pass


def retry(action, numTries, retryExceptions, sleepTimeSec=0):
    assert numTries > 0
    for i in range(numTries):
        try:
            result = action()
            return result
        except Exception as e:  # pylint: disable=broad-except
            if type(e) not in retryExceptions.keys() or i == (numTries - 1):
                raise
            handler = retryExceptions[type(e)]
            if handler is not None and handler(e):
                raise
            time.sleep(sleepTimeSec)
    raise RetryException(f'Failed after {numTries} tries')


def repl():
    import inspect  # pylint: disable=import-outside-toplevel

    caller = inspect.stack()[1]
    import code  # pylint: disable=import-outside-toplevel

    code.interact(local=caller.frame.f_locals)
