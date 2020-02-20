#!/bin/bash

# +-------------------------------------------------
# | Files Helper
# +-------------------------------------------------

function md5hash()
{
    shopt -s dotglob
    local PWD=$(pwd)

    if [ -d "${1}" ]; then
        cd "${1}"
    fi

    for FILE in *; do
        if [ -f "${FILE}" ]; then
            if [ -z "`echo "${FILE}" | egrep '\.md5$'`" ]; then
                printf "Hashing file ${txtylw}%s${txtrst}\n" "${FILE}"
                md5sum "${FILE}" > "${FILE}.md5"
            fi
        fi
    done

    cd "${PWD}"
}

function md5check()
{
    shopt -s dotglob
    local PWD=$(pwd)

    if [ -d "${1}" ]; then
        cd "${1}"
    fi

    for FILE in *; do
        if [ -f "${FILE}" ]; then
            if [ -n "`echo "${FILE}" | egrep '\.md5$'`" ]; then
                printf "Checking file ${txtylw}%-30s${txtrst} .. " "${FILE}"
                md5sum --status --quiet -c "${FILE}" 2>1 >/dev/null
                if [ "$?" -eq 0 ]; then
                    echo -e "${bldwht}[  ${bldgrn}OK  ${bldwht}]${txtrst}"
                else
                    echo -e "${bldwht}[ ${bldred}FAIL ${bldwht}]${txtrst}"
                fi
            fi
        fi
    done

    cd "${PWD}"
}

function md2html()
{
    local TOC="01_aaatoc.md"
    local TMP="__index.tmp"
    local OUT="index.html"
    local TITLE=$(basename `pwd`)

    echo > "${TMP}"
    echo > "${OUT}"

    cat << 'EOF' > "${TOC}"
# Gliederung
EOF

    grep -P '^#' *.md | cut -d ':' -f2 | \
        sed 's/#/* /g' | \
        sed 's/\* \* \* \*/        */g' | \
        sed 's/\* \* \*/     */g' | \
        sed 's/\* \*/   */g' | \
        sed 's/\*  /\* [/g' | \
        sed 's/$/]/g' | \
        node -e "

    var fs = require('fs');
    var chunks = '';

    process.stdin.resume();
    process.stdin.setEncoding('utf8');

    process.stdin.on('data', function(chunk) {
        chunks += chunk;
    });

    process.stdin.on('end', function() {

        var tmp = '# Gliederung\n\n';

        chunks.split('\n').forEach(function(line) {

            if ('' == line) {
                return;
            }

            var slug = line.split('*');
            slug.shift();
            slug = slug.join('').trim().split(' ').join('-');
            slug = slug.replace(/\(/g, '')
                       .replace(/\./g, '-')
                       .replace(/\,/g, '-')
                       .replace(/\)/g, '')
                       .replace(/^\[/g, '(#')
                       .replace(/\]$/g, ')');

            tmp += line + slug + '\n';
        });

        fs.writeFileSync('./01_aaatoc.md', tmp);
    });
    "

    cat << 'EOF' > "${OUT}"
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
EOF
    echo "<title>${TITLE}</title>" >> "${OUT}"

    cat << 'EOF' >> "${OUT}"
<link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,300,600" rel="stylesheet" type="text/css">
<link href="https://fonts.googleapis.com/css?family=Source+Code+Pro:400" rel="stylesheet" type="text/css">
<link href="http://cdn.hermann-mayer.net/styles/markdown.css" rel="stylesheet"></link>
<link rel="stylesheet" href="http://yandex.st/highlightjs/7.3/styles/github.min.css">
<script src="http://yandex.st/highlightjs/7.3/highlight.min.js"></script>
<script src="http://codeorigin.jquery.com/jquery-2.0.3.min.js"></script>
<script>
    hljs.tabReplace = ' ';
    hljs.initHighlightingOnLoad();

    $( function () {

        // Add horizontal lines before h1 headings
        $('h1:not(:nth-child(2))').prepend('<hr>');

        // Break \n to <br> on highlightes examples (the result is faulty code
        // but it is readable for a human)
        setTimeout(function() {
            $('.string').each(function(idx, itm) {
                itm = $(itm);
                itm.html(itm.html().replace(/\\n/gi, '<br>'));
            })
        }, 500);
    } );
</script>
</head>
<body>
<div class="hidden-on-print" style="position: fixed; right: 20px; bottom: 20px;">
  <a class="btn btn-primary" href="#Gliederung">Gliederung</a>
</div>
EOF

    for file in $(find *.md); do
        echo -e "\n" >> "${TMP}"
        cat "${file}" >> "${TMP}"
        echo -e "\n" >> "${TMP}"
    done

    # Build anchors for all headlines
    cat "${TMP}" | grep '^#' | node -e "

    var fs = require('fs');
    var chunks = '';

    process.stdin.resume();
    process.stdin.setEncoding('utf8');

    process.stdin.on('data', function(chunk) {
        chunks += chunk;
    });

    process.stdin.on('end', function() {

        var tmp = fs.readFileSync('./__index.tmp', 'utf8');

        chunks.split('\n').forEach(function(line) {

            if ('' == line) {
                return;
            }

            var slug = line.split(' ');
            slug.shift();
            slug = slug.join('-');
            slug = slug.replace(/\(/g, '')
                       .replace(/\./g, '-')
                       .replace(/\,/g, '-')
                       .replace(/\)/g, '');

            var heading = line.replace(/\(/g, '\\\(')
                              .replace(/\)/g, '\\\)')
                              .replace(/\[/g, '\\\[')
                              .replace(/\]/g, '\\\]')
                              .replace(/\"/g, '\\\"')
                              .replace(/\./g, '\\\.');

            tmp = tmp.replace(
                new RegExp('^' + heading + '\$', 'mgi'),
                line + '<a name=\"' + slug + '\"></a>'
            );
        });

        fs.writeFileSync('./__index.tmp', tmp);
    });
    "

    marked --gfm --tables --lang-prefix "" "${TMP}" >> "${OUT}";

    cat << 'EOF' >> "${OUT}"
</body>
</html>
EOF

    rm "${TMP}" "${TOC}" 2>/dev/null
}

function dirs-size()
{
    find */ -type d -maxdepth 1 | xargs du -hsxc 2>/dev/null | sort -h
}

function gline()
{
    gvim -f ${1%%:*} +$(echo "${1}" | cut -d ':' -f2)
}

function vline()
{
    vim -f ${1%%:*} +$(echo "${1}" | cut -d ':' -f2)
}

function greview()
{
    while read line; do
        gline "${line}"
    done
}

function mpx()
{
    CWD="$(pwd)"
    txtylw='\e[0;33m' # Yellow
    txtcyn='\e[0;36m' # Cyan
    txtrst='\e[0m'    # Text Reset

    paths="*/"
    cmd="${@}"

    if [ $# -gt 1 ]; then
        paths=''
        cmd="${@: -1}"
        for path in "${@:1:$(($#-1))}"; do
            paths=$(echo "${paths} ${path}")
        done
    fi

    if [ '' = "${cmd}" ]; then
        cmd='ls -lisa'
    fi

    find ${paths} -maxdepth 0 | while read file; do

        echo
        echo
        echo -e "${txtylw}##########################${txtrst}"
        echo -e "${txtylw}## ${txtcyn}${file}${txtrst}"
        echo -e "${txtylw}##########################${txtrst}"
        echo -e "${txtrst}"

        cd "${file}"
        eval "${cmd}"
        cd "${CWD}"
    done

    cd "${CWD}"
}

function mergepdfs()
{
    local OUTPUT="merged.pdf"

    if [ -n ${1} ]; then
        OUTPUT="${1}"
    fi

    pdftk *.pdf cat output "${OUTPUT}"
}

function cdtmp()
{
    names=('bier' 'wein' 'schnaps' 'whiskey' 'vodka' 'goldkrone' 'tequila'
    'rum' 'eierlikoer' 'likoer' 'obstbrand' 'korn' 'aquavit' 'gin' 'brandy'
    'weinbrand' 'met' 'sake' 'becherovka' 'becks' 'wickueler' 'sternburg'
    'retterbier' 'jackdaniels' 'johnniewalker' 'havanaclub' 'jaegermeister'
    'feigling' 'kuemmerling' 'rum' 'pils' 'cognac' 'absinth' 'calvados'
    'asbachuralt' 'spaetburgunder' 'underberg' 'portwein' 'bordeaux' 'amaretto'
    'kellergeister' 'doppelkorn' 'ramazotti' 'klosterfraumelissengeist'
    'koelnischwasser')
    name=${names[$RANDOM % ${#names[@]}]}
    mkdir "/tmp/${name}"
    cd "/tmp/${name}"
}
