#!/bin/bash

# +-------------------------------------------------
# | Testing Helper
# +-------------------------------------------------

export __TESTING_NAME_WIDTH=55

function checkProcess()
{
    local SEARCH=""
    if [ -n "${2}" ]; then
        SEARCH="${2}"
    else
        SEARCH="${1}"
    fi

    printf "Looking for \E[0;33m%-${__TESTING_NAME_WIDTH}b\E[0m" "${SEARCH}\E[0m .. "

    pid=$(ps ax | egrep -i "${1}" | egrep -vi "egrep(.)+${1}" | sed 's/^\s//g' | sed 's/^ //g' | cut -d ' ' -f1)
    pid=$(echo "${pid}" | tr "\n" " " | sed 's/ $//g')

    if [ -z "${pid}" ]; then
        echo -e "[ \E[31mNot Running\E[0m ]"
    else
        echo -e "[ \E[1;32mRunning\E[0m :: ${pid} ]"
    fi
}

function checkProcessUnder()
{
    width=$(($__TESTING_NAME_WIDTH + 11))
    printf "Looking for \E[1;34m%-${width}b\E[0m" "${2} \E[0munder\E[1;34m ${1}\E[0m .. "
    local ppid=$(psgrep "${1}" | awk '{print $1}')
    local pid=$(pstree -ap "${ppid}" 2>/dev/null | egrep -i "${2}" | egrep -vi "egrep(.)+${2}" | grep -v '{' | awk 'BEGIN { FS = "," } ; {print $2}' | awk '{print $1}')
    local pid=$(echo "${pid}" | tr "\n" " " | sed 's/ *$//g')
    if [ -z "${pid}" ]; then
        echo -e "[ \E[31mNot Running\E[0m ]"
    else
        echo -e "[ \E[1;32mRunning\E[0m :: ${pid} ]"
    fi
}

function checkTCPPort()
{
    width=$(($__TESTING_NAME_WIDTH - 2))
    printf "Probing Port \E[1;34m%-${width}b\E[0m " "${2}\E[0m on ${1} .. "
    stat=$(nmap -sT --data-length 10 -n -q -r -P0 --open -T Aggressive -p "${2}" "${1}" | grep "${2}/tcp")
    running=$(echo "${stat}" | grep "open")
    stat=$(echo "${stat}" | rev | cut -d ' ' -f1 | rev)
    if [ -z "${running}" ]; then
        echo -e "[ \E[31mNot Open\E[0m ]"
    else
        echo -e "[ \E[1;32mOpen\E[0m :: ${stat} ]"
    fi
}

function checkWebsite()
{
    printf "Requesting \E[1;34m%-${__TESTING_NAME_WIDTH}b\E[0m " "${1}\E[0m .. "
    stat=$(curl --insecure -s -S -I "${1}" | egrep "HTTP|Content-Length|X-Cache" | tr -c '[:print:]' ' ')
    stat=$(echo "$stat" | sed 's/  / | /g' | sed 's/ |\s*$//g')
    running=$(echo "${stat}" | grep 200)
    if [ -z "${running}" ]; then
        echo -e "[ \E[31mFail\E[0m :: ${stat} ]"
    else
        echo -e "[ \E[1;32mGood\E[0m :: ${stat} ]"
    fi
}

function checkSMART()
{
    width=$(($__TESTING_NAME_WIDTH - 3))
    echo -e "Check SMART for device: \E[33m${1} ..\E[0m\n"
    smartctl -i "$@" | egrep "^Model Family|^Device Model|^Firmware"
    echo
    while read line; do
        hex=$(echo "$line" | awk '{print $1}')
        field=$(echo "$line" | awk '{print $2}')
        thresh=$(echo "$line" | awk '{print $6}' )
        res=$(echo "$line" | rev | cut -d ' ' -f1)
        stat="Value: ${res} | Threshold: ${thresh}"
        printf "Check attibute \E[1;34m%-${width}b\E[0m" "${field} (${hex})\E[0m .. "
        if [ ${res} -gt 0 ]; then
            echo -e "[ \E[31mFail\E[0m :: ${stat} ]"
        else
            echo -e "[ \E[1;32mGood\E[0m :: ${stat} ]"
        fi
    done < <(smartctl -a "$@" | egrep "^  5|^ 10|^184|^188|^196|^197|^198|^201|^230" | egrep " [0-9]{2,}$|$")
}
