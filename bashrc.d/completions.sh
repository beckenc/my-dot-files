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

_ti2-ssh-service-tool()
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="--host --port -s --pass --ssh-key --ssh-port --ssh-status"

  case "${prev}" in
    --host)
      COMPREPLY=( $(compgen -A hostname ${cur}) )
      return 0
      ;;
    --port)
      COMPREPLY=( 59595 59596 )
      return 0
      ;;
    --pass)
      COMPREPLY=( S38.vice )
      return 0
      ;;
    --ssh-key)
      COMPREPLY=( $(compgen -f ${cur}) )
      return 0
      ;;
    --ssh-status)
      COMPREPLY=( 0 1 )
      return 0
      ;;
    --ssh-port)
      COMPREPLY=( 22 )
      return 0
      ;;
    *)
      ;;
  esac

  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

#complete -o bashdefault -F _bar bar
complete -o bashdefault -F _ti2-ssh-service-tool ti2-ssh-service-tool

#complete -A hostname hpr_login.exp
