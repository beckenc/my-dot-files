#!/bin/bash

# +-------------------------------------------------
# | Commons Helper
# +-------------------------------------------------

function psgrep()
{
    ps ax -o pid,ruser,command | egrep -i --color=always "$1" | grep -v "grep"
}

# create folder and change into
function mkd ()
{
  mkdir -p "$@" && eval cd "\"\$$#\"";
}


function stripColors()
{
    sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"
}
