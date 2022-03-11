#!/usr/bin/env bash
#set -euo pipefail

export EDITOR=mcedit

alias ll="ls -al"

alias cdr="cd /r"
alias cdp="cd /p"

alias m=$EDITOR

alias s='git status'
alias l='git log'
alias d='git diff'
alias dc='git diff --cached'
alias c='git commit'
alias ca='git commit --amend'
alias n='git commit -a'
alias mg='git merge --no-ff --no-commit'
alias g='git grep -i'
alias gs='git grep'
alias r='git rebase'
alias rc='git rebase --continue'
alias a='git add'
alias b='git blame'
alias cp='git cherry-pick'
alias cpc='git cherry-pick --continue'
alias cpa='git cherry-pick --abort'
alias co='git checkout'

alias ta='tmux attach'

alias p2=python2
alias p3=python3
alias p=python3

alias rgh='rg --hidden'

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

bind '"\ew": backward-kill-word'

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND-}"

# Default debian color prompt
#export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# ...with git status
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;36m\]\h\[\033[00m\]\[\033[01;33m\] \w$(__git_ps1)\[\033[00m\] '

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

export PATH+=:/p/tools/bin

source /r/env/fzf-tab-completion/bash/fzf-bash-completion.sh
bind -x '"\t": fzf_bash_completion'

#eval $(thefuck --alias fu)
