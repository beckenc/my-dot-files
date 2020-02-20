#!/bin/bash

# +-------------------------------------------------
# | Style Commandline Prompt
# +-------------------------------------------------

# If set, the value is executed as a command prior to issuing each primary prompt.
PROMPT_COMMAND=

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
  PROMPT_COMMAND+='RET=$?;'
  RET_OUT='$(printf "\[$txtwht\][ret: %-3s]" $RET)'

  if [[ ${EUID} == 0 ]] ; then
    PSL1=$'\n'"${RET_OUT} [\[${bldblu}\]\w\[${txtrst}\]]"
    PSL2=$'\n'"\[${bldred}\]\u@\h \[${bldblu}\]\$\[${txtrst}\] "
  else
    PSL1=$'\n'"${RET_OUT} [\[${bldblu}\]\w\[${txtrst}\]]"
    PSL2=$'\n'"\[${bldylw}\]\u@\h \[${bldblu}\]\$\[${txtrst}\] "
  fi
  PS1+=${PSL1}${PSL2}
else
  # show root@ when we don't have colors
  PS1+='\u@\h \w \$ '
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color

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

  # Do stuff.
  echo "Running post_command"
}
#PROMPT_COMMAND+='post_command;'

