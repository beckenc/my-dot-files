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

function open()
{
  for i in $@; do
    xdg-open $i
  done
}


