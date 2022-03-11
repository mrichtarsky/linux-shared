#!/usr/bin/env bash
set -euo pipefail

echo "Link /r needs to be set up"

#/r/env/install_packages.sh

cp -r /r/env/fzf ~/.fzf
~/.fzf/install --all

cd ~
mkdir configbackup
for f in .config .gitconfig
do
    mv $f configbackup || true
    ln -s "/r/homedir/$f" .
done

# Does not work on HANA users
#python3 -m pip install thefuck --user || true

chmod u+w ~/.bashrc
echo ". /r/_init.sh" >>~/.bashrc
