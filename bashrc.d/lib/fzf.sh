# Wanna split fzf in a tmux pane
declare -r FKEY_BINDINGS='/usr/share/fzf/key-bindings.bash'
declare -r FCOMPLETION='/usr/share/bash-completion/completions/fzf'

test -f $FKEY_BINDINGS && source $FKEY_BINDINGS
test -f $FCOMPLETION && source $FCOMPLETION

export FZF_TMUX=1
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

#EOF
