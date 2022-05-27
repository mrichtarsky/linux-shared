#!/usr/bin/env bash
set -euox pipefail

PROJECT_DIR=$1

temp=$( realpath "$0"  )
SCRIPT_DIR=$(dirname "$temp")
rm /r
ln -s $SCRIPT_DIR /r

pushd /r

git submodule init
git submodule update

mkdir -p $PROJECT_DIR
chmod a+rwx $PROJECT_DIR
rm /p || true
ln -s $PROJECT_DIR /p

mkdir -p /p/tools

PACKAGES="expect mc tmux htop ncdu git ripgrep python3 sysstat"
DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')

echo $DISTRO
if [ "$DISTRO" == '"sles"' ];
then
    zypper install $PACKAGES python3-pip
else
    apt install $PACKAGES
fi

wget https://dystroy.org/broot/download/x86_64-linux/broot
chmod a+x broot
mv broot /usr/local/bin/broot

python3 -m pip install pypyp

/r/setup_rust.sh

export RUSTUP_HOME=/p/tools/rust
export CARGO_HOME=/p/tools/rust/.cargo
source /p/tools/rust/.cargo/env

cargo install git-delta
chmod a+rx -R /p/tools/rust/.cargo

# VSCode watches
WATCHES=fs.inotify.max_user_watches=524288
grep -qF $WATCHES /etc/sysctl.conf || echo "$WATCHES" >>/etc/sysctl.conf
sysctl -p

python3 -m pip install telegram-send

popd

echo "OK"
