#!/bin/bash

# +-------------------------------------------------
# | Usefull Addons
# +-------------------------------------------------

function bashrc-update()
{
  if [[ -f ~/.bashrc ]] ; then
    . ~/.bashrc
  fi
}

function screen-session()
{
    /usr/bin/screen -S ${USER}_screen -d -R -c ${BASHRC_CONFIG}/screenrc
}

function open()
{
  for i in $@; do
    xdg-open $i
  done
}


