import json
import pathlib
import sys

SECRETS_PATH = pathlib.Path('/repos/secrets')
TOKEN_CACHE_PATH = SECRETS_PATH / 'token_cache'
INFRA_PATH = SECRETS_PATH / 'infra.json'

sys.path.insert(0, str(SECRETS_PATH))
from infra import infra  # pylint: disable=unused-import,wrong-import-position
from creds import creds  # pylint: disable=unused-import,wrong-import-position

def getSecretsPath(suffix):
    return SECRETS_PATH / suffix

def getTokenPath(suffix):
    return TOKEN_CACHE_PATH / suffix

def getJsonCredentials(file_):
    with open(getSecretsPath(file_), 'rt') as f:
        data = json.load(f)
    return data
