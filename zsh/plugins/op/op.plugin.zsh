(( ${+commands[op]} )) || return

source ~/.config/op/plugins.sh

eval "$(op completion zsh)"; compdef _op op
