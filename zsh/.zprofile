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

# Add a few items to the path that we need for mise
path=(
  $HOME/.dotfiles/bin(N)
  $HOME/.local/bin(N)
  /opt/homebrew/sbin(N)
  /opt/homebrew/bin(N)
  /usr/local/sbin(N)
  /usr/local/bin(N)
  $path
)

# Add Homebrew path to completions
fpath=(
  /opt/homebrew/share/zsh/site-functions(N)
  /usr/local/share/zsh/site-functions(N)
  $fpath
)

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath

# Activate mise for non-interactive shells
if (( ${+commands[mise]} )); then
  eval "$(mise activate zsh --shims)"
fi
