import os

import keyring
from keyrings.cryptfile.cryptfile import CryptFileKeyring

KEYRING_DIR = '/repos/secrets/keyring'

os.makedirs(KEYRING_DIR, exist_ok=True)

keyring.util.platform_.data_root = lambda: KEYRING_DIR

keyring = CryptFileKeyring()
keyring.keyring_key = os.environ['KEY']
del os.environ['KEY']
