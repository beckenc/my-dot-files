# Wanna split fzf in a tmux pane
declare FKEY_BINDINGS='/usr/share/fzf/key-bindings.bash'
declare FCOMPLETION='/usr/share/bash-completion/completions/fzf'

test -f $FKEY_BINDINGS && source $FKEY_BINDINGS
test -f $FCOMPLETION && source $FCOMPLETION

export FZF_TMUX=1
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

unset FKEY_BINDINGS
unset FCOMPLETION

#EOF
