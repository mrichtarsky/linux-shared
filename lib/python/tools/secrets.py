import json
import pathlib
import sys

from prodict import Prodict  # pylint: disable=syntax-error

from tools.lib.keyring_setup import keyring

SECRETS_PATH = pathlib.Path('/repos/secrets')
TOKEN_CACHE_PATH = SECRETS_PATH / 'token_cache'

sys.path.insert(0, str(SECRETS_PATH))

import add_credentials  # pylint: disable=wrong-import-position

def getSecretsPath(suffix):
    return SECRETS_PATH / suffix

def getTokenPath(suffix):
    return TOKEN_CACHE_PATH / suffix

def getJsonCredentials(file_):
    with open(getSecretsPath(file_), 'rt') as f:
        data = json.load(f)
    return data

credentials = {}

class Callable:
    def __init__(self, function, system, attribute):
        self.function = function
        self.system = system
        self.attribute = attribute

    def __call__(self):
        return self.function(self.system, self.attribute)

class LazyInfos:
    def __init__(self):
        object.__setattr__(self, 'items', {})  # Normal assignment would call self.__setattr__()

    def add(self, name, value):
        setattr(self, name, value)

    def __setattr__(self, name, value):
        self.items[name] = value

    def __getattr__(self, name):
        value = self.items[name]
        if callable(value):
            value = value()
            if value is None:
                raise Exception('Returned None')
        return value

    def __str__(self):
        return "\n".join(f"{key} = {self.__getattr__(key)}" for key in sorted(self.items))

def addCredential(system, user, secretAttributes=(), extraAttributes=None):
    if system in credentials:
        raise Exception('Duplicate system')
    info = credentials[system] = LazyInfos()
    info.add('user', user)
    info.add('password', lambda: keyring.get_password(system, user))
    for secretAttribute in secretAttributes:
        info.add(secretAttribute,
                 Callable(keyring.get_password, system, secretAttribute))
    if extraAttributes:
        for name, value in extraAttributes.items():
            info.add(name, value)

add_credentials.setup(addCredential)

credentials = Prodict.from_dict(credentials)
