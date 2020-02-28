#!/bin/bash

# +-------------------------------------------------
# | Style Commandline Prompt
# +-------------------------------------------------
# If set, the value is executed as a command prior to issuing each primary prompt.
PROMPT_COMMAND='RET=$?;'

# Add git support
GIT_PS1=
if [[ -f "/usr/share/git/git-prompt.sh" ]]; then
  source "/usr/share/git/git-prompt.sh"
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWCOLORHINTS=true #works only with PROMPT_COMMAND
  GIT_PS1='$(__git_ps1)'
fi

# Change the window title of X terminals
case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|interix)
		PS1='\[\033]0;\u@\h:\w\007\]'
		;;
	screen*)
		PS1='\[\033k\u@\h:\w\033\\\]'
		;;
	*)
		unset PS1
		;;
esac

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.
# We run dircolors directly due to its changes in file syntax and
# terminal name patching.
use_color=false
if type -P dircolors >/dev/null ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	LS_COLORS=
	if [[ -f ~/.dir_colors ]] ; then
		eval "$(dircolors -b ~/.dir_colors)"
	elif [[ -f /etc/DIR_COLORS ]] ; then
		eval "$(dircolors -b /etc/DIR_COLORS)"
	else
		eval "$(dircolors -b)"
	fi
	# Note: We always evaluate the LS_COLORS setting even when it's the
	# default.  If it isn't set, then `ls` will only colorize by default
	# based on file attributes and ignore extensions (even the compiled
	# in defaults of dircolors). #583814
	if [[ -n ${LS_COLORS:+set} ]] ; then
		use_color=true
	else
		# Delete it if it's empty as it's useless in that case.
		unset LS_COLORS
	fi
else
	# Some systems (e.g. BSD & embedded) don't typically come with
	# dircolors so we need to hardcode some terminals in here.
	case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|screen|cons25|*color) use_color=true;;
	esac
fi

if ${use_color} ; then
    # exit status of last function
    PS1+="\[${txtred}\]"'$(echo ${RET_OUT})\n'
    # user@hosts
    if [[ ${EUID} == 0 ]] ; then
        PS1+="\[${bldred}\]\u\[${txtblu}\]@\[${txtred}\]\h" # root user
	else
        PS1+="\[${bldgrn}\]\u\[${txtblu}\]@\[${txtgrn}\]\h" # normal user
    fi
    # working directory
    PS1+="  \[${txtblu}\]"'$(pwd)'
    # total size of files
    PS1+="  \[${txtylw}\]"'$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed "s/total //")'
    # number of files
    PS1+=' $(/bin/ls -A -1 | /usr/bin/wc -l)'
    # git ps1
    PS1+=" \[${txtpur}\]"${GIT_PS1}
    # next line propmpt
    PS1+="\[${txtrst}\]\n\$ "
else
	# show root@ when we don't have colors
    PS1+='\u@\h \w \$ '
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color sh


# +-------------------------------------------------
# | Binding Bash Events
# +-------------------------------------------------

# This will run before any command is executed.
# We want to run only for the first command, not for the whole
# command line (i.e. at the first command).
function pre_command() {
  if [ -z "$FIRST_COMMAND" ]; then
    return
  fi
  unset FIRST_COMMAND

  # Do stuff.
  echo "Running pre_command"
}
#trap 'pre_command' DEBUG

# This will run after the execution of the previous full command line.
# We don't want to run when first starting a bash session (i.e., at
# the first prompt).
FIRST_PROMPT=1
function post_command() {
  FIRST_COMMAND=1

  if [ -n "$FIRST_PROMPT" ]; then
    unset FIRST_PROMPT
    return
  fi

  # Show error exit code if there is one
  if [[ ${RET} != 0 ]]; then
    RET_OUT="[ exit status ${RET} "
    if [[ ${RET} == 1 ]]; then
      RET_OUT+="General error"
    elif [ ${RET} == 2 ]; then
      RET_OUT+="Missing keyword, command, or permission problem"
    elif [ ${RET} == 126 ]; then
      RET_OUT+="Permission problem or command is not an executable"
    elif [ ${RET} == 127 ]; then
      RET_OUT+="Command not found"
    elif [ ${RET} == 128 ]; then
      RET_OUT+="Invalid argument to exit"
    elif [ ${RET} == 129 ]; then
      RET_OUT+="Fatal error signal 1"
    elif [ ${RET} == 130 ]; then
      RET_OUT+="Script terminated by Control-C"
    elif [ ${RET} == 131 ]; then
      RET_OUT+="Fatal error signal 3"
    elif [ ${RET} == 132 ]; then
      RET_OUT+="Fatal error signal 4"
    elif [ ${RET} == 133 ]; then
      RET_OUT+="Fatal error signal 5"
    elif [ ${RET} == 134 ]; then
      RET_OUT+="Fatal error signal 6"
    elif [ ${RET} == 135 ]; then
      RET_OUT+="Fatal error signal 7"
    elif [ ${RET} == 136 ]; then
      RET_OUT+="Fatal error signal 8"
    elif [ ${RET} == 137 ]; then
      RET_OUT+="Fatal error signal 9"
    elif [ ${RET} -gt 255 ]; then
      RET_OUT+="Exit status out of range"
    else
      RET_OUT+="Unknown error code"
    fi
    RET_OUT+=" ]"
    printf "\n"
  else
    RET_OUT=""
  fi

}
# PROMPT_COMMAND+='post_command;'
PROMPT_COMMAND+='post_command;'
