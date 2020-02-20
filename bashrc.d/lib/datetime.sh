#!/bin/bash

# +-------------------------------------------------
# | Date/Time Helper
# +-------------------------------------------------

function unixtimetodate()
{
    date -u -d "@${1}"
}

function datediff()
{
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo $(( (d1 - d2) / 86400 )) days
}

function secondsFormat()
{
    printf ""%dh:%dm:%ds"\n" $(($1/3600)) $(($1%3600/60)) $(($1%60))
}
