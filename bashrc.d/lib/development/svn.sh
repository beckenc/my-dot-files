#!/bin/bash

# +-------------------------------------------------
# | Development/SVN Helper
# +-------------------------------------------------

function echoColorizedSVNLine()
{
    line=$1
    skipX=$2
    done="false"

    if [[ "$done" == false && "$line" =~ ^M.* ]]; then
        echo -e "$bldylw$line\E[0m"
        done="true"
    fi
    if [[ "$done" == false && "$line" =~ ^D.* ]]; then
        echo -e "$txtred$line\E[0m"
        done="true"
    fi
    if [[ "$done" == false &&  "$line" =~ ^A.* ]]; then
        echo -e "$bldgrn$line\E[0m"
        done="true"
    fi
    if [[ "$done" == false &&  "$line" =~ ^C.* ]]; then
        echo -e "$bldred$line\E[0m"
        done="true"
    fi
    if [[ "$done" == false &&  "$line" =~ ^\?.* ]]; then
        echo -e "$bldpur$line\E[0m"
        done="true"
    fi
    if [[ "$done" == false &&  "$line" =~ ^\!.* ]]; then
        echo -e "\E[01;31m$line\E[0m"
        done="true"
    fi
    if [[ "$done" == false &&  "$line" =~ ^X.* ]]; then
        if [[ "$skipX" == false ]]; then
            echo -e "\E[01;30m$line\E[0m"
        fi
        done="true"
    fi
    if [[ "$done" == false &&  "$line" =~ ^L.* ]]; then
        if [[ "$skipX" == false ]]; then
            echo -e "\E[01;30m$line\E[0m"
        fi
        done="true"
    fi
    if [[ "$done" == false &&  "$line" =~ ^S.* ]]; then
        echo -e "\E[01;30m$line\E[0m"
        done="true"
    fi
    if [[ "$done" == false ]]; then
        echo -e "$line"
    fi
}

function svn()
{
    svnPath=`which svn`

    local operation=$1
    shift

    if [ 'status' == "${operation}" ]; then

        $svnPath status "$@" | while read line; do echoColorizedSVNLine "${line}" "false"; done

    elif [ 'statusx' == "${operation}" ]; then

        $svnPath status "$@" | while read line; do echoColorizedSVNLine "${line}" "true"; done

    elif [ 'log' == "${operation}" ]; then

        $svnPath log "$@" | sed -e 's/^-\+$/[0;34m\0[m/' -e 's/^r[0-9]\+.\+$/[0;33m\0[m/' | less -R

    else

        $svnPath "${operation}" "$@"
    fi
}

function svn-current-revision()
{
    local rev=$(svn info | grep ' Rev' | cut -d ':' -f2)
    echo -e "Current svn revision: ${bldylw}${rev}${txtrst}"
}
