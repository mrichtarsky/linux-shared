#!/usr/bin/env bash
set -euo pipefail

PACKAGES="mc tmux htop iostat ncdu git ripgrep python3"
DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
echo $DISTRO
if [ "$DISTRO" == '"sles"' ];
then
    sudo zypper install $PACKAGES git-delta
else
    sudo apt install $PACKAGES
    pushd /tmp
    wget https://github.com/dandavison/delta/releases/download/0.12.1/git-delta_0.12.1_amd64.deb
    dpkg -i git-delta_0.12.1_amd64.deb
    rm git-delta_0.12.1_amd64.deb
    popd
fi
