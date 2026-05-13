(( ${+commands[op]} )) || return

# Do this by hand instead of using the plugin system that 1Passowrd has
# because it uses aliases which break completion. Static completion is loaded
# from $ZDOTDIR/completions/_op via fpath.

export OP_PLUGIN_ALIASES_SOURCED=1

# Disable op aws plugin in favor of AWS SSO
# aws() { op plugin run -- aws "$@" }
