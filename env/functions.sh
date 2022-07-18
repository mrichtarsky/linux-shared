#!/usr/bin/env bash
#set -euo pipefail

op() {
  SEARCHPATH="${2-.}"
  e `f -E *pyc -p "$1" "$SEARCHPATH" | fzf`
}

mkcd() {
  mkdir "$1"
  cd "$1"
}

repl() {
  SEARCHPATH="${3-.}"
  grep -r -l "$1" "$SEARCHPATH" | grep -v '.git/' | xargs sed -i "s|$1|$2|g"
}

getpid() {
  ps u | grep "$1" | grep -v grep | sed 's/\s\s*/ /g' | cut -d ' ' -f 2
}

lesslast() {
  less `ls -1t "${1-}" | head -1`
}

taillast() {
  tail `ls -1t "${1-}" | head -1`
}

kar() {
  if [ -n "${3-}" ]
  then
    killall -r ".*$1.*"
  fi
}

gop() {
    SEARCHPATH="${2-.}"
	RG_PREFIX="rg --files-with-matches -i"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1' '$SEARCHPATH'" \
			fzf --sort --preview="[[ ! -z {} ]] && rg -i --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q} $SEARCHPATH" \
				--preview-window="70%:wrap"
	)" &&
	e "$file"
}

# Extract File Archives Of Various Types
ex () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1     ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1     ;;
             *.rar)       rar x $1       ;;
             *.gz)        gunzip $1      ;;
             *.tar)       tar xf $1      ;;
             *.tbz2)      tar xjf $1     ;;
             *.tgz)       tar xzf $1     ;;
             *.zip)       unzip $1       ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

function _tmux_change_socket_group {
    SOCKET=$(python -c 'import os;print(os.environ["TMUX"]).split(",")[0]')
    chgrp linux-shared "$SOCKET"
}

function su {
    _tmux_change_socket_group
    /bin/su --whitelist-environment=TMUX "$@"
}

function sudo {
    _tmux_change_socket_group
    /usr/bin/sudo --preserve-env=TMUX "$@"
}
