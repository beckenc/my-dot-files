#!/bin/bash
if ! [ -x "$(command -v git)" ]; then
  echo 'Warning: git is enabled, but not installed.' >&2
fi

# +-------------------------------------------------
# | Development/Git Helper
# +-------------------------------------------------

function git-current-commit()
{
    local commit=$(git log --pretty="%h" -n1 HEAD)
    echo -e "Current git commit: ${bldylw}${commit}${txtrst}"
}

function git-user-stats()
{
    local awkCommand='{ add += $1 ; subs += $2 ; loc += $1 - $2 } END \
            { printf "added lines: \033[1;32m%s\033[0m removed lines: \033[0;31m%s\033[0m total lines: \033[1;33m%s\033[0m",add,subs,loc }'

    if [ 'not-pretty' = "${2}" ]; then
        awkCommand='{ add += $1 ; subs += $2 ; loc += $1 - $2 } END \
            { printf "%s %s %s\n",add,subs,loc }'
    fi

    git log --author="${1}" --pretty=tformat: --numstat | \
        gawk "${awkCommand}"
}

function git-stat()
{
    (
        echo "Commits Additions Deletions Total Email Name"

        git log --format="%aE %aN" | awk '{arr[$0]++} END{for (i in arr){print arr[i], i;}}' | sort -rn | while read line; do

            commits=$(echo $line | cut -d ' ' -f1)
            name=$(echo $line | cut -d ' ' -f2-)
            email=$(echo $line | cut -d ' ' -f2 | sed 's/>//g' | sed 's/<//g')
            stats=$(git-user-stats "${email}" "not-pretty")

            echo -e "${commits} ${stats} ${name}"

        done
    ) | column -t
}

function gitrs()
{
    mpx git --no-pager ${@}
}

function gitrs-last-stats()
{
    gitrs diff HEAD^ HEAD --stat | grep -P "\/\e\[0m$|\("
}

function gitrs-stats()
{
    mpx git-stat
}

function git-time-between()
{
    local FIRST=$(git log --pretty="format:%at" -1 "${1}")
    local SECOND=$(git log --pretty="format:%at" -1 "${2}")
    local DELTA=$((FIRST - SECOND))

    if [ $DELTA -lt 0 ]; then
        DELTA=$((SECOND - FIRST))
    fi

    bc << EOM
scale=0;
days=(((10^0)*($DELTA/86400))+0.5)/(10^0)
hours=(((10^0)*($DELTA/3600))+0.5)/(10^0) % 24
minutes=(((10^0)*($DELTA/60))+0.5)/(10^0) % 60
seconds=$DELTA % 60
print days, " days, ", hours, " hours, ", minutes, " minutes, ", seconds, " seconds"
EOM
}

function git-changelog()
{
    git log --pretty=format:"* %h %B" ${1}..HEAD | sort -k 3
}

function git-log-full()
{
    git log --decorate --stat --graph --pretty=format:"%d %Cgreen%h%Creset (%ar - %Cred%an%Creset), %s%n"
}

function git-branch-last-commitdate()
{
    git for-each-ref --sort=-committerdate refs/remotes/origin/ \
        --format='%(committerdate:short) %(committeremail) %(refname:short) %(upstream:short)'
}

# Based on https://gist.github.com/jehiah/1288596
function git-branch-status()
{
    TMP_FILE=$(mktemp)
    (
        git-branch-last-commitdate | while read committerdate authoremail local remote; do
            [ -z "$remote" ] && remote="origin/master"
            git rev-list --left-right ${local}...${remote} -- 2>/dev/null \
                >${TMP_FILE} || continue
            LEFT_AHEAD=$(grep -c '^<' ${TMP_FILE})
            RIGHT_AHEAD=$(grep -c '^>' ${TMP_FILE})
            echo "$local | (ahead $LEFT_AHEAD) | (behind $RIGHT_AHEAD) \
                | $remote | $committerdate | $authoremail"
        done
    ) | column -t -s '|'
    rm ${TMP_FILE}
}
