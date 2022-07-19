#!/usr/bin/env bash
#set -euo pipefail

export EDITOR="/r/env/vscode_tmux_wrapper -w"


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

export PATH+=:/p/tools/bin

source /r/env/fzf-tab-completion/bash/fzf-bash-completion.sh
bind -x '"\t": fzf_bash_completion'

unset _FZF_COMPLETION_SEP # For some unknown reason preview does not work otherwise

forgit_log=gl
source /r/env/forgit/forgit.plugin.sh

# bat
export BAT_THEME="ansi"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

alias bathelp='bat --plain --language=help'
h() {
    "$@" --help 2>&1 | bathelp
}

export FZF_DEFAULT_OPTS="--height 50% --layout reverse --preview 'ls -1 {} && bat --color=always --style=numbers --line-range=:500 {}'"

export FORGIT_LOG_FZF_OPTS="--reverse"
export FORGIT_LOG_GRAPH_ENABLE=false

export MC_SKIN=$HOME/.config/mc/mc_solarized_light.ini
