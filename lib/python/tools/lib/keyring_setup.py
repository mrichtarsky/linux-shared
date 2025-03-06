import getpass
import os
import sys

import keyring
from keyrings.cryptfile.cryptfile import CryptFileKeyring

KEYRING_DIR = '/repos/secrets/keyring'

os.makedirs(KEYRING_DIR, exist_ok=True)

keyring.util.platform_.data_root = lambda: KEYRING_DIR

cryptfile_keyring = CryptFileKeyring()
try:
    passphrase = os.environ['KEY']
except KeyError:
    if os.isatty(sys.stdout.fileno()):  # interactive shell, prompt for key
        passphrase = getpass.getpass('Passphrase not found in KEY environment'
                                     ', please enter: ')
        passphrase = passphrase.rstrip()
    else:
        raise

cryptfile_keyring.keyring_key = passphrase
