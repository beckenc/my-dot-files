#!/bin/bash

# +-------------------------------------------------
# | Style Commandline Prompt
# +-------------------------------------------------
# If set, the value is executed as a command prior to issuing each primary prompt.
PROMPT_COMMAND='RET=$?;'

# Add git support
GIT_PS1=""
if [[ -f "/usr/share/git/git-prompt.sh" ]]; then
  source "/usr/share/git/git-prompt.sh"
  export GIT_PS1_SHOWUNTRACKEDFILES=true
  export GIT_PS1_SHOWDIRTYSTATE=true
  export GIT_PS1_SHOWSTASHSTATE=true
  export GIT_PS1_SHOWCOLORHINTS=true #works only with PROMPT_COMMAND
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

if ${use_color} ; then
    # exit status of last function
    PS1+="\[${txtred}\]"'$(echo ${RET_OUT})\n'
    # user@hosts
    if [[ ${EUID} == 0 ]] ; then
        PS1+="\[${bldred}\]\u\[${txtcyn}\]@\[${txtred}\]\h" # root user
    else
        PS1+="\[${bldgrn}\]\u\[${txtcyn}\]@\[${txtgrn}\]\h" # normal user
    fi
    # working directory
    PS1+="  \[${txtcyn}\]"'$(pwd)'
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
  if [[ "$RET" != 0 ]]; then
    RET_OUT="[ $RET "
    if [[ "$RET" == 1 ]]; then
      RET_OUT+="General error"
    elif [ "${RET}" == 2 ]; then
      RET_OUT+="Missing keyword, command, or permission problem"
    elif [ "$RET" == 126 ]; then
      RET_OUT+="Permission problem or command is not an executable"
    elif [ "$RET" == 127 ]; then
      RET_OUT+="Command not found"
    elif [ "$RET" == 128 ]; then
      RET_OUT+="Invalid argument to exit"
    elif [ "$RET" == 129 ]; then
      RET_OUT+="Fatal error signal 1"
    elif [ "$RET" == 130 ]; then
      RET_OUT+="Script terminated by Control-C"
    elif [ "$RET" == 131 ]; then
      RET_OUT+="Fatal error signal 3"
    elif [ "$RET" == 132 ]; then
      RET_OUT+="Fatal error signal 4"
    elif [ "$RET" == 133 ]; then
      RET_OUT+="Fatal error signal 5"
    elif [ "$RET" == 134 ]; then
      RET_OUT+="Fatal error signal 6"
    elif [ "$RET" == 135 ]; then
      RET_OUT+="Fatal error signal 7"
    elif [ "$RET" == 136 ]; then
      RET_OUT+="Fatal error signal 8"
    elif [ "$RET" == 137 ]; then
      RET_OUT+="Fatal error signal 9"
    elif [ "$RET" -gt 255 ]; then
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
