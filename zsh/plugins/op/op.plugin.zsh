(( ${+commands[op]} )) || return

# Do this by hand instead of using the plugin system that 1Passowrd has
# because it uses aliases which break completion.

export OP_PLUGIN_ALIASES_SOURCED=1
aws() { op plugin run -- aws "$@" }

eval "$(op completion zsh)"; compdef _op op
