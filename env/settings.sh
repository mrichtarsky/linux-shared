#!/usr/bin/env bash
#set -euo pipefail

source "/r/setup/settings.sh"

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
ulimit -n 32768

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

export PATH=$TOOLS_PATH/bin:$PATH
export LD_LIBRARY_PATH=/p/tools/lib:$LD_LIBRARY_PATH

if [[ ${SHELLOPTS} =~ (vi|emacs) ]] # line editing enabled?
then
    bind -x '"\t": fzf_bash_completion'
    bind '"\ew": backward-kill-word'
fi

forgit_log=gl
source /r/env/forgit/forgit.plugin.sh

export LESS="-i" # Case insensitive

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


export FZF_DEFAULT_OPTS="--select-1 --height 50% --layout reverse --preview '/r/env/fzf_preview {}' --preview-window down,~1 --bind=tab:accept"

export FORGIT_LOG_FZF_OPTS="--reverse"
export FORGIT_LOG_GRAPH_ENABLE=false

export MC_SKIN=$HOME/.config/mc/mc_solarized_light.ini

eval "$(zoxide init --cmd zox bash)"

source /r/env/bashmarks/bashmarks.sh

if [[ "$OSTYPE" =~ ^darwin ]]
then
    eval "$(/opt/homebrew/bin/brew shellenv)"

    if type brew &>/dev/null; then
        HOMEBREW_PREFIX=$(brew --prefix)
        NEWPATH=${PATH}
        # gnubin; gnuman
        for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do
            NEWPATH=$d:$NEWPATH;
        done
        for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do
            export MANPATH=$d:$MANPATH;
        done
        export PATH=$(echo ${NEWPATH} | tr ':' '\n' | cat -n | sort -uk2 | sort -n | cut -f2- | xargs | tr ' ' ':')
    fi
fi

export PYTHONPATH+=:/r/lib/python:/p/pylibs

source "$TOOLS_PATH/share/cht_sh.bash_completion"

source /r/env/fzf-tab-completion/bash/fzf-bash-completion.sh
