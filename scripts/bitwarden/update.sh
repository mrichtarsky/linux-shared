#!/usr/bin/env bash
set -euxo pipefail

source /r/lib/bash/tools.sh

pushdt /p/bitwarden
./bitwarden.sh updateself
./bitwarden.sh update
