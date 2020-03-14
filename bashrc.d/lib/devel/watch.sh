#!/bin/bash

# +-------------------------------------------------
# | Development/Watch Helper
# +-------------------------------------------------

function watch-dmesg()
{
    watch -c -n1 "dmesg --color=always | tail -n `echo $(($(tput lines)-5))`"
}

function watch-make-test()
{
    while [ 1 ]; do
        inotifywait --quiet -r `pwd` -e close_write --format '%e -> %w%f'
        make test
    done
}

function watch-run()
{
    while [ 1 ]; do
        inotifywait --quiet -r `pwd` -e close_write --format '%e -> %w%f'
        $@
    done
}
