# Wanna split fzf in a tmux pane
declare -r KEY_BINDINGS='/usr/share/fzf/key-bindings.bash'
declare -r COMPLETION='/usr/share/bash-completion/completions/fzf'

test -f $KEY_BINDINGS && source $KEY_BINDINGS
test -f $COMPLETION && source $COMPLETION

export FZF_TMUX=1
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

#EOF
