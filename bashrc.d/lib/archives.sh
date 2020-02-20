#!/bin/bash

# +-------------------------------------------------
# | Archives Helper
# +-------------------------------------------------

# Extglob is a dependency for the extract method
shopt -s extglob

function extract()
{
    local c e i

    (($#)) || return

    local tarBin=`which bsdtar`
    if [ -z "`which bsdtar`" ]; then
        tarBin=`which tar`
    fi

    for i; do
        c=''
        t=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
        *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
               c="${tarBin} xvf";;
        *.7z)  c='7z x';;
        *.Z)   c='uncompress';;
        *.bz2) c='bunzip2';;
        *.exe) c='cabextract';;
        *.gz)  c='gunzip';;
        *.rar) c='unrar x';;
        *.xz)  c='unxz';;
        *.zip) c='unzip';;
        *.deb) c='ar p'; t='data.tar.lzma | tar xJ';;
        *)     echo "$0: unrecognized file extension: \`$i'" >&2
               continue;;
        esac

        eval "$c \"$i\" $t"
        e=$?
    done

    return $e
}

function extractRar()
{

    ls *.part01.rar *.part001.rar *.part0001.rar 2>/dev/null | while read FILE; do
        unrar e "$FILE";
    done;
}
