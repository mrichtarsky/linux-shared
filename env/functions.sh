#!/usr/bin/env bash
#set -euo pipefail

f() {
  SEARCHPATH='.'
  if [ -n "${2-}" ]
  then
    SEARCHPATH=$2
  fi
  find -L "$SEARCHPATH" | grep -i "${1-}"
}

op() {
  $EDITOR `f $1 ${2-} |grep -v pyc`
}

repl() {
  SEARCHPATH='.'
  if [ -n "${3-}" ]
  then
    SEARCHPATH=$3
  fi
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
  killall -r ".*$1.*"
}
