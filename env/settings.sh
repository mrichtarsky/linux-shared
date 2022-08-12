#!/usr/bin/env bash
#set -euo pipefail

export EDITOR="/r/env/vscode_tmux_wrapper_blocking"


export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r"
# VS Code shell integration breaks this; ${PROMPT_COMMAND-}"

# Default debian color prompt
#export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# ...with git status

# Disable git prompt for large repos
function __git_ps1_no_large {
    prev_exit_code=$?
    if [[ -z $(git config prompt.ignore) ]];
    then
        __git_ps1
    fi
    return $prev_exit_code
}

function __update_tmux_title {
    tmux rename-window "$(whoami) @ $(pwd) | $(date "+%T")" 2>/dev/null || true
}

source /r/scripts/git-sh-prompt
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;36m\]\h\[\033[00m\]\[\033[01;33m\] \w$(__git_ps1_no_large)\[\033[00m\] \[\e[0;$(($?==0?0:91))m\]${?#0}\[\e[0m\] $(__update_tmux_title)$(stty sane)'

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

export PATH=/p/tools/bin:$PATH
export LD_LIBRARY_PATH=/p/tools/lib:$LD_LIBRARY_PATH

#source /r/env/fzf-tab-completion/bash/fzf-bash-completion.sh

if [[ ${SHELLOPTS} =~ (vi|emacs) ]] # line editing enabled?
then
    bind '"\ew": backward-kill-word'
fi

forgit_log=gl
source /r/env/forgit/forgit.plugin.sh

# bat
export BAT_THEME="ansi"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

alias bathelp='bat --plain --language=help'

if [[ "$OSTYPE" =~ ^darwin ]];
then
    h() {
        "$@" -h 2>&1 | bathelp
    }
else
    h() {
        "$@" --help 2>&1 | bathelp
    }
fi

export FZF_OBC_STD_FZF_OPTS="--select-1 --height 50% --layout reverse --preview '([ -d {} ] && exa -al --classify --group-directories-first --group --time-style long-iso -d {} && echo && exa -al --classify --group-directories-first --group --time-style long-iso {}) || ( exa -al --classify --group-directories-first --group --time-style long-iso {} && bat --color=always --style=numbers --line-range=:500 {})' --preview-window down,~1"

export FORGIT_LOG_FZF_OPTS="--reverse"
export FORGIT_LOG_GRAPH_ENABLE=false

. /r/env/fzf-obc/bin/fzf-obc.bash

export MC_SKIN=$HOME/.config/mc/mc_solarized_light.ini
