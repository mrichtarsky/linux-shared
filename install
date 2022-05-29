#!/usr/bin/env bash
set -euo pipefail

pushd /r

rm -rf ~/.fzf
cp -r /r/env/fzf ~/.fzf
~/.fzf/install --all

echo "Linking configuration"
cd ~
mkdir -p configbackup
for f in .config .gitconfig .inputrc .tmux.conf
do
    rm -rf "configbackup/$f"
    mv "$f" configbackup || true
    ln -s "/r/homedir/$f" .
done

# Does not work on HANA users
#python3 -m pip install thefuck --user || true

chmod u+w ~/.bashrc
grep /r/_init.sh ~/.bashrc || echo ". /r/_init.sh" >>~/.bashrc

popd

echo "OK"
