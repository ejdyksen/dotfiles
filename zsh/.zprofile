#!/bin/zsh
#
# .zprofile - Zsh file loaded on login.
#

#
# Editors
#

export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"
export PAGER="${PAGER:-less}"

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath

# Add a few items to the path that we need for mise
path=(
  $HOME/.dotfiles/bin(N)
  $HOME/.local/bin(N)
  /opt/homebrew/bin(N)
  /user/local/bin(N)
  $path
)

# Activate mise for non-interactive shells
if which mise >/dev/null 2>&1; then
  eval "$(mise activate zsh --shims)"
fi
