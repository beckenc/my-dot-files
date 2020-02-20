#!/bin/bash

# +-------------------------------------------------
# | Development/Common Helper
# +-------------------------------------------------

function debughtml()
{
    cat - | xmllint --format --html --recover - | highlight --out-format=xterm256 -S xml -- | less -R
}

function debugxml()
{
    cat - | xmllint --format --recover - | highlight --out-format=xterm256 -S xml -- | less -R
}

function generateMAC()
{
    echo $(dd bs=1 count=6 if=/dev/random 2>/dev/null |hexdump -v -e '/1 "-%02X"' | sed 's/^-//g')
}
