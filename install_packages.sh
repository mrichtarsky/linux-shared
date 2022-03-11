#!/usr/bin/env bash
set -euo pipefail

PACKAGES="mc tmux htop iostat ncdu git ripgrep python3"
DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
echo $DISTRO
if [ "$DISTRO" == '"sles"' ];
then
    sudo zypper install $PACKAGES
else
    sudo apt install $PACKAGES
fi
