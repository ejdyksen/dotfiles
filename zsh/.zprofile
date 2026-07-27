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

# Add a few items to the path that we need for mise.
#
# The shims entry is the entire output of `mise activate zsh --shims`, inlined
# to save a fork. If shims ever misbehave, diff this against that command.
# Interactive shells replace these with real binary paths via plugins/mise.
path=(
  ${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}/shims(N)
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

