#!/usr/bin/env bash
set -euo pipefail

PACKAGES="mc tmux htop ncdu git ripgrep python3 sysstat"
DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
echo $DISTRO
if [ "$DISTRO" == '"sles"' ];
then
    sudo zypper install $PACKAGES
    pushd /tmp
    wget https://github.com/dandavison/delta/releases/download/0.12.1/delta-0.12.1-x86_64-unknown-linux-gnu.tar.gz
    tar xf delta-0.12.1-x86_64-unknown-linux-gnu.tar.gz
    rm delta-0.12.1-x86_64-unknown-linux-gnu.tar.gz
    popd
else
    sudo apt install $PACKAGES
    pushd /tmp
    wget https://github.com/dandavison/delta/releases/download/0.12.1/git-delta_0.12.1_amd64.deb
    sudo dpkg -i git-delta_0.12.1_amd64.deb
    rm git-delta_0.12.1_amd64.deb
    popd
fi


wget https://dystroy.org/broot/download/x86_64-linux/broot
chmod a+x broot
sudo mv broot /usr/local/bin/broot

pip3 install pypyp
