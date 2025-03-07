(( ${+commands[pnpm]} )) || return

export PNPM_HOME="$HOME/.local/share/pnpm/store"

path=(
  $PNPM_HOME(N)
  $path
)
