# Wanna split fzf in a tmux pane
if ! [ -x "$(command -v fzf)" ]; then
  echo 'Warning: fzf is enabled, but not installed.' >&2
fi

declare FKEY_BINDINGS_GENTOO='/usr/share/fzf/key-bindings.bash'
declare FKEY_BINDINGS_UBUNTU='/usr/share/doc/fzf/examples/key-bindings.bash'
declare FCOMPLETION='/usr/share/bash-completion/completions/fzf'

test -f $FKEY_BINDINGS_GENTOO && source $FKEY_BINDINGS_GENTOO
test -f $FKEY_BINDINGS_UBUNTU && source $FKEY_BINDINGS_UBUNTU
test -f $FCOMPLETION && source $FCOMPLETION


export FZF_TMUX=1
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

unset FKEY_BINDINGS_GENTOO
unset FKEY_BINDINGS_UBUNTU
unset FCOMPLETION

#EOF
