import pathlib
import sys

SECRETS_PATH = pathlib.Path('/repos/secrets')

sys.path.insert(0, str(SECRETS_PATH))

from infra import infra  # pylint: disable=unused-import,wrong-import-position
