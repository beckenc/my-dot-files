#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo 'Installing bash environment from '$DIR

BASHRC="# .bashrc
source ${DIR}/bashrc.d/bashrc
[ -f "${DIR}"/my_bashrc.sh ] && source "${DIR}"/my_bashrc.sh"

if [ $# -eq 0 ]; then
    IFS=''
    echo $BASHRC > ~/.bashrc
    unset IFS
elif [ $1 == "--all" ]; then
    USERS=($(ls -l /home | awk '{if(NR>1)print $9}'))
    for user in ${USERS[*]}; do
        homepath=$(eval echo "~$user")
        IFS=''
        echo $BASHRC > ${homepath}/.bashrc
        unset IFS
        echo "Installed bash environment for user $user successfully! Enjoy :-)"
    done
    echo "Installed bash environment successfully! Enjoy :-)"
    exit 0
else
    SELECTED_USERS=(${@:1})
    echo "Selected users: ${SELECTED_USERS[@]}"
    for user in ${SELECTED_USERS[@]}; do
        homepath=$(eval echo "~$user")
        IFS=''
        echo $BASHRC > ${homepath}/.bashrc
        unset IFS
        echo "Installed bash environment for user $user successfully! Enjoy :-)"
    done
    exit 0
fi
