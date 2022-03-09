export EDITOR=mcedit

alias ll="ls -al"

alias m=$EDITOR

alias gs='git status'
alias gl='git log'
alias gd='git diff'
alias gdc='git diff --cached'
alias gc='git commit'
alias gca='git commit --amend'
alias gn='git commit -a'
alias gg='git grep -i'
alias ggs='git grep'
alias gr='git rebase'
alias grc='git rebase --continue'
alias ga='git add'
alias gb='git blame'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'
alias gco='git checkout'
alias rgh='rg --hidden'
alias ta='tmux attach'

alias p2=python2
alias p3=python3
alias p=python3

alias cdr="cd /r"

f() {
  SEARCHPATH='.'
  if [ -n "$2" ]
  then
    SEARCHPATH=$2
  fi
  find -L "$SEARCHPATH" | grep -i "$1"
}

op() {
  $EDITOR `f $1 $2 |grep -v pyc`
}

repl() {
  SEARCHPATH='.'
  if [ -n "$3" ]
  then
    SEARCHPATH=$3
  fi
  grep -r -l "$1" "$SEARCHPATH" | grep -v '.git/' | xargs sed -i "s|$1|$2|g"
}

getpid() {
  ps u | grep "$1" | grep -v grep | sed 's/\s\s*/ /g' | cut -d ' ' -f 2
}

lesslast() {
  less `ls -1t "$1" | head -1`
}

taillast() {
  tail `ls -1t "$1" | head -1`
}

man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}

# unset LANG
# unset LC_LANG
# unset LOCALE

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

umask 002

export GREP_COLORS="mt=38;5;118:sl=:cx=:fn=78;5;68:ln=1;30:bn=37:se=30"
export TMP=/tmp
export TEMP=/tmp
export TMPDIR=/tmp

export GIT_PS1_DESCRIBE_STYLE='contains'
export GIT_PS1_SHOWCOLORHINTS='y'
export GIT_PS1_SHOWDIRTYSTATE='y'
export GIT_PS1_SHOWSTASHSTATE='n'
export GIT_PS1_SHOWUNTRACKEDFILES='y'
export GIT_PS1_SHOWUPSTREAM='auto'

source /usr/lib/git-core/git-sh-prompt
#export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w$(__git_ps1)\[\033[00m\] $(e=$?; (( e )) && echo "$e|") \$ '
#export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\w$(__git_ps1)\[\033[00m\] $(e=$?; (( e )) && echo "$e|")\$ '
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;36m\]\h\[\033[00m\]\[\033[01;33m\] \w$(__git_ps1)\[\033[00m\] '


export PATH+=:/projects/tools/bin

# smiley()
# {
#   if [ "$?" == "0" ]; then
#     echo -e '\e[0;32m:) '
#   else
#     echo -e '\e[0;31m:( '
#   fi
# }
# export PS1="$PS1"'`smiley`'

# CTRL+Cursor Left/Right for cmd line word navigation
bind '"\eOC": forward-word'
bind '"\eOD": backward-word'

# CTRL+Backspace for word delete
stty werase ^?
