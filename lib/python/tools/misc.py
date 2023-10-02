import socket
import sys
import time


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
    except Exception: # pylint: disable=broad-except
        ip = '127.0.0.1'
    finally:
        s.close()
    return ip

DEBUG = '--debug' in sys.argv
QUIET = '--quiet' in sys.argv

def debug(*args, **kwargs):
    if DEBUG:
        print(*args, **kwargs, file=sys.stderr)

def eprint(*args, **kwargs):
    if not QUIET:
        print(*args, **kwargs, file=sys.stderr)

def confirm(prompt):
    return input(f"{prompt} [y/N] ").strip().lower() == 'y'

def confirm(prompt, defaultIfNotTty=False):
    if not sys.stdout.isatty():
        return defaultIfNotTty
    return input(f"{prompt} [y/N] ").strip().lower() == 'y'

def confirmOrExit(prompt):
    confirm = input(f"{prompt}, type 'YES' to confirm: ")
    if confirm.rstrip() != 'YES':
        print('ABORTING')
        sys.exit(1)

def chunked(it, size):
    from itertools import islice
    it = iter(it)
    return iter(lambda: tuple(islice(it, size)), ())

def retry(action, numTries, retryExceptions, sleepTimeSec=0):
    assert numTries > 0
    for i in range(numTries):
        try:
            result = action()
            return result
        except Exception as e:
            if type(e) not in retryExceptions.keys() or i == (numTries-1):
                raise
            handler = retryExceptions[type(e)]
            if handler is not None and handler(e):
                raise
            time.sleep(sleepTimeSec)
    raise Exception(f"Failed after {numTries} tries")

def repl():
    # Need to paste this into your code, else locals aren't available
    # TODO hack: use introspection of call stack to detemine context, use globals/locals from there
    import code
    code.interact(local=locals())
