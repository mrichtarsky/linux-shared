source "/r/setup/settings.sh"

EDITOR="/r/env/vscode_tmux_wrapper_blocking"

HISTCONTROL=ignoredups:erasedups  # no duplicate entries
HISTSIZE=100000                   # big big history
HISTFILESIZE=10000000             # big big history
HISTTIMEFORMAT="%Y-%m-%d %T "
shopt -s histappend               # append to history, don't overwrite it

# Save and reload the history after each command finishes
PROMPT_COMMAND="history -a; history -c; history -r"
# VS Code shell integration breaks this; ${PROMPT_COMMAND-}"

# Default debian color prompt
#export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# ...with git status

# Disable git prompt for large repos
__git_ps1_no_large() {
    prev_exit_code=$?
    if [[ -z $(git config prompt.ignore) ]];
    then
        __git_ps1 "$@"
    fi
    return $prev_exit_code
}

__update_tmux_title() {
    [ -z "$TMUX" ] && echo "[NOT IN TMUX] "
    tmux rename-window "$(whoami) @ $(pwd) | $(date "+%T")" 2>/dev/null || true
}

source /r/scripts/git-sh-prompt
PS1='\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;36m\]\h\[\033[00m\]\[\033[01;33m\] \w$(__git_ps1_no_large)\[\033[00m\] \[\e[0;$(($?==0?0:91))m\]${?#0}\[\e[0m\] $(__update_tmux_title)$(stty sane)'

GIT_PS1_DESCRIBE_STYLE='contains'
GIT_PS1_SHOWCOLORHINTS='y'
GIT_PS1_SHOWDIRTYSTATE='y'
GIT_PS1_SHOWSTASHSTATE='n'
GIT_PS1_SHOWUNTRACKEDFILES='y'
GIT_PS1_SHOWUPSTREAM='auto'

ulimit -n 128000 2>/dev/null

GREP_COLORS="mt=38;5;118:sl=:cx=:fn=78;5;68:ln=1;30:bn=37:se=30"

TMP=/tmp
TEMP=/tmp
TMPDIR=/tmp

PATH=$TOOLS_PATH/bin:$PATH
LD_LIBRARY_PATH=/p/tools/lib:$LD_LIBRARY_PATH

if [[ ${SHELLOPTS} =~ (vi|emacs) ]] # line editing enabled?
then
    bind -x '"\t": fzf_bash_completion'
    bind '"\ew": backward-kill-word'
fi

# shellcheck disable=SC2034
forgit_log=gl
source /r/env/forgit/forgit.plugin.sh

LESS="-i" # Case insensitive search

# bat
BAT_THEME="ansi"
# shellcheck disable=SC2089
MANPAGER='sh -c "col -bx | bat -l man -p"'
MANROFFOPT="-c"

# shellcheck disable=SC2089
FZF_DEFAULT_OPTS="--select-1 --height 50% --layout reverse --multi --preview '/r/env/fzf_preview {}' --preview-window down,~1 --bind=tab:accept --bind=right:toggle+down --cycle"

FORGIT_LOG_FZF_OPTS="--reverse"
FORGIT_LOG_GRAPH_ENABLE=false
MC_SKIN=$HOME/.config/mc/mc_solarized_light.ini

eval "$(zoxide init --cmd zox bash)"

source /r/env/bashmarks/bashmarks.sh

# Put GNU tools first in PATH on macOS
if [[ "$OSTYPE" =~ ^darwin ]]
then
    eval "$(/opt/homebrew/bin/brew shellenv)"

    if type brew &>/dev/null; then
        HOMEBREW_PREFIX=$(brew --prefix)
        NEWPATH=${PATH}
        # gnubin; gnuman
        for d in "${HOMEBREW_PREFIX}"/opt/*/libexec/gnubin; do
            NEWPATH=$d:$NEWPATH;
        done
        for d in "${HOMEBREW_PREFIX}"/opt/*/libexec/gnuman; do
            MANPATH=$d:$MANPATH;
        done
        export MANPATH
        PATH=$(echo "${NEWPATH}" | tr ':' '\n' | cat -n | sort -uk2 | sort -n | cut -f2- | xargs | tr ' ' ':')
        export PATH
    fi
fi

PYTHONPATH+=:/r/lib/python:/p/pylibs

source "$TOOLS_PATH/share/cht_sh.bash_completion"

source /r/env/fzf-tab-completion/bash/fzf-bash-completion.sh

PATH+=:/sbin:/usr/sbin

export BAT_THEME
export EDITOR
export FORGIT_LOG_FZF_OPTS
export FORGIT_LOG_GRAPH_ENABLE
# shellcheck disable=SC2090
export FZF_DEFAULT_OPTS
export GIT_PS1_DESCRIBE_STYLE
export GIT_PS1_SHOWCOLORHINTS
export GIT_PS1_SHOWDIRTYSTATE
export GIT_PS1_SHOWSTASHSTATE
export GIT_PS1_SHOWUNTRACKEDFILES
export GIT_PS1_SHOWUPSTREAM
export GREP_COLORS
export HISTCONTROL
export HISTFILESIZE
export HISTSIZE
export HISTTIMEFORMAT
export LD_LIBRARY_PATH
export LESS
# shellcheck disable=SC2090
export MANPAGER
export MANROFFOPT
export MC_SKIN
export PATH
export PROMPT_COMMAND
export PS1
export PYTHONPATH
export TEMP
export TEMPDIR
export TMP
export TMPDIR

umask 027
