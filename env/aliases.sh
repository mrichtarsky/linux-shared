#!/usr/bin/env bash

alias e=/r/env/vscode_tmux_wrapper
alias m=mcedit

alias l='less'
([[ $(type -t ll) == "alias" ]] && unalias ll) || true
alias lc="lsd -a"

alias cdr="cd /r"
alias cdp="cd /p"

alias f='fd --no-ignore --hidden'
alias t=cd
alias z=zoxi
alias v='cd ..'
alias b='bat'
alias tf='tail -f -n 200'
alias ka='killall'
alias k9='kill -9'

alias s='git status'
alias d='git diff'
alias dc='git diff --cached'
alias gc='git commit'
alias gus='git restore --staged'
alias ca='git commit --amend'
alias n='git commit -a'
alias gsh='git show'
alias gm='git merge --no-ff --no-commit'
alias g='git grep -i'
alias gs='git grep'
alias r='git rebase'
alias rc='git rebase --continue'
alias a='git add'
alias ap='git add -p'
alias gb='git blame'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'
alias co='git checkout'
alias gp='git push'
alias gpl='git pull'

alias ta='tmux attach || tmux'

alias p2=python2
alias p3=python3
alias p=python3

alias rgh='rg --hidden'
alias ri='rg -i'
alias rif='rg -i --fixed-strings'
alias rs='rg'
alias rsf='rg --fixed-strings'

alias trw='tmux rename-window'

alias norg='gron --ungron'
alias wa='viddy'

alias c='cht.sh'

alias rm='trash'

alias mv='mv --interactive' # Prompt before overwrite

alias zmv=/r/env/zmv_wrapper

alias y=yank-cli
