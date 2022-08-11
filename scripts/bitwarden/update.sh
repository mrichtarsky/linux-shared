#!/usr/bin/env bash
set -euxo pipefail

pushd /p/bitwarden
./bitwarden.sh updateself
./bitwarden.sh update
