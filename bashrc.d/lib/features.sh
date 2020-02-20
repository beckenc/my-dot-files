#!/bin/bash

# +-------------------------------------------------
# | Features Helper
# +-------------------------------------------------

function mount()
{
    mountPath=`which mount`
    $mountPath "$@" | column -t
}

declare -A __dir_stack

function cd()
{
    command cd "$@"

    # Our cleanup algorithm is like a ring-storage
    if [ "${#__dir_stack[@]}" -ge 20 ]; then
        declare -A buf;
        for i in "${!__dir_stack[@]}"; do
            if [ "$i" -ge 10 ]; then
                buf[${#buf[@]}]="${__dir_stack[$i]}"
            fi
        done

        # Remove old stack
        unset __dir_stack
        declare -gA __dir_stack

        # Copy over to new stack
        for i in "${buf[@]}"; do
            __dir_stack[${#__dir_stack[*]}]=$i
        done
        unset buf
    fi

    # Add absolute path to the stack if it is not already tracked
    for i in "${!__dir_stack[@]}"; do
        if [ "${__dir_stack[$i]}" == "$(pwd)" ]; then
            return 0;
        fi
    done;
    __dir_stack[${#__dir_stack[@]}]=$(pwd)
}

function d()
{
    {
        for i in "${!__dir_stack[@]}"; do
            printf "${bldwht}[${txtred}%3s${bldwht}]${bldylw} %s${txtrst}\n" "$i" "${__dir_stack[$i]}"
        done;
    } | sort -n -k2

    echo
    read -p " > " i

    next="${__dir_stack[$i]}"

    if [ "x${next}" = 'x' ]; then
        echo -e "\n${txtred}Your entered index was not on the stack.${txtrst}"
    else
        command cd "${next}"
    fi
}
