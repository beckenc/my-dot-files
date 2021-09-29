#!/bin/bash

# +-------------------------------------------------
# | Bash Completions
# +-------------------------------------------------

_foo()
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="--help --verbose --version"

  if [[ ${cur} == -* ]] ; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
  fi
}
complete -o bashdefault -F _foo foo

_bar()
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="file hostname"

  case "${prev}" in
    file)
      COMPREPLY=( $(compgen -f ${cur}) )
      return 0
      ;;
    hostname)
      COMPREPLY=( $(compgen -A hostname ${cur}) )
      return 0
      ;;
    *)
      ;;
  esac

  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

#complete -o bashdefault -F _bar bar
