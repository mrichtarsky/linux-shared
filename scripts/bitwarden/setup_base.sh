#!/usr/bin/env bash
set -euxo pipefail

sudo adduser bitwarden || true
sudo usermod -aG docker bitwarden
mkdir /p/bitwarden
chmod -R 700 /p/bitwarden
chown -R bitwarden:bitwarden /p/bitwarden
