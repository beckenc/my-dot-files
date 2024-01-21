#!/bin/bash

# +-------------------------------------------------
# | Usefull Aliases
# +-------------------------------------------------

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ls='ls $COLOR_OPTIONS --time-style="+%F %H:%M "'
alias ll='ls -lahF'
alias l='ls -lhF'
alias grep='grep -P $COLOR_OPTIONS'
alias egrep='egrep $COLOR_OPTIONS'
alias fgrep='fgrep $COLOR_OPTIONS'
alias mkdir='mkdir -pv'
alias openports='netstat -anp --tcp --udp --inet --inet6 | tail -n +1 | sort'
alias tree='tree -R'
alias df='df -h'
alias du='du -h'
if [[ -x /usr/bin/colordiff ]]; then
  alias diff='colordiff'
fi
if [[ -x /usr/bin/vimpager ]]; then
  alias less='vimpager'
  alias zless='vimpager'
fi
#alias swd="swd"
#alias rwd="rwd"
#alias cwd="source ~/bin/cwd"

