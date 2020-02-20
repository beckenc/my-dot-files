#!/bin/bash

# +-------------------------------------------------
# | Colors
# +-------------------------------------------------

txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
badgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

# Color programs output
export COLOR_OPTIONS='--color=auto'

# Color 'man' output
export LESS_TERMCAP_mb=$'\e[0;33m'     # Start blink mode
export LESS_TERMCAP_md=$'\e[0;33m'     # Start bold mode
export LESS_TERMCAP_me=$'\e[0m'        # End bold/blink mode
export LESS_TERMCAP_so=$'\e[01;44;33m' # Start standout mode
export LESS_TERMCAP_se=$'\e[0m'        # End standout mode
export LESS_TERMCAP_us=$'\e[0;34m'     # Start underlining
export LESS_TERMCAP_ue=$'\e[0m'        # End underlining

function print256Colors()
{
  for i in {0..255}; do
      echo -e "\e[38;05;${i}m38;05;${i}m";
  done | column -c 50 -s ' '

  echo -en "\e[m"
}

function print8Colors()
{
  for i in {0..7}; do
    echo -e "\e[0;3${i}m 0;3${i} - \e[1;3${i}m 1;3${i}";
  done | column -c 4 -s ' '

  echo -en "\e[m"
}

