#!/bin/bash

# +-------------------------------------------------
# | Bash Options
# +-------------------------------------------------

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting when exiting.  #139609
shopt -s histappend

# Enable extended globbing
shopt -s extglob

# Enable globbing for dotfiles
shopt -s dotglob

# Enable globstars for recursive globbing
shopt -s globstar

# Auto "cd" when entering just a path
shopt -s autocd

# Automatically correct mistyped directory names on cd
shopt -s cdspell

# Keep multi line commands together
shopt -s cmdhist

