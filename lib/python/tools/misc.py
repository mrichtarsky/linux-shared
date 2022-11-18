import socket
import sys

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

QUIET = '--quiet' in sys.argv

def eprint(*args, **kwargs):
    if not QUIET:
        print(*args, **kwargs, file=sys.stderr)

def confirmOrExit(prompt):
    confirm = input(f"{prompt}, type 'YES' to confirm: ")
    if confirm.rstrip() != 'YES':
        print('ABORTING')
        sys.exit(1)
