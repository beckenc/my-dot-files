#!/bin/bash

# +-------------------------------------------------
# | Find Helper
# +-------------------------------------------------

# ff:  to find a file under the current directory
function ff()
{
  if [ $# -ge 1 ] ; then
    /usr/bin/find . -iname '*'"$@"'*' | grep -i "$@"
  fi
}

# ffs: to find a file whose name starts with a given string
function ffs()
{
  if [ $# -ge 1 ] ; then
    /usr/bin/find . -iname "$@"'*'
  fi
}

# ffe: to find a file whose name ends with a given string
function ffe()
{
  if [ $# -ge 1 ] ; then
    /usr/bin/find . -iname '*'"$@"
  fi
}

 # find and delete files
function ffdel ()
{
  if [ $# -ge 1 ] ; then
    /uss/bin/find . -name "$@" -delete
  fi
}

function findPid()
{
  lsof -t -c "$@"
}

function findTopLevelParentPid()
{
  pid=${1:-$$}
  stat=($(</proc/${pid}/stat))
  ppid=${stat[3]}
  if [[ ${ppid} -eq 1 ]] ; then
    echo "${pid}"
  else
    findTopLevelParentPid "${ppid}"
  fi
}

# search source files recursive in the current tree
function sgrep ()
{
  if [ $# -ge 1 ] ; then
    # set -x
    grep -Harn --include={*.[ch],*.[ch]pp,*.[ch]xx} --exclude-dir={.svn,.git} "$@" ./
    # set +x
  fi
}

# search recursive in the current tree
function hgrep ()
{
  if [ $# -ge 1 ] ; then
    # set -x
    grep -Harn --exclude-dir={.svn,.git,html} "$@" ./
    # set +x
  fi
}

