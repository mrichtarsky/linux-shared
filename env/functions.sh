#!/usr/bin/env bash
#set -euo pipefail

op() {
  SEARCHPATH="${2-.}"
  $EDITOR `f $1 ${SEARCHPATH} | grep -v pyc`
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
