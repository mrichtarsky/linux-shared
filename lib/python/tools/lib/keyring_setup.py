import getpass
import os

import keyring
from keyrings.cryptfile.cryptfile import CryptFileKeyring

KEYRING_DIR = '/repos/secrets/keyring'

os.makedirs(KEYRING_DIR, exist_ok=True)

keyring.util.platform_.data_root = lambda: KEYRING_DIR

keyring = CryptFileKeyring()
try:
    passphrase = os.environ['KEY']
except KeyError:
    if 'PS1' in os.environ:  # interactive shell, prompt for key
        passphrase = getpass.getpass('Passphrase not found in KEY environment, please enter: ')
    else:
        raise

keyring.keyring_key = passphrase
