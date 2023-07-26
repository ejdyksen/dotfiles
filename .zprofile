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

if [[ -d /opt/homebrew ]]; then
  path=(
    $HOME/{,s}bin(N)
    /opt/homebrew/{,s}bin(N)
    $path
  )

  fpath=(
    /opt/homebrew/share/zsh/site-functions
    $fpath
  )
else
  path=(
    $HOME/{,s}bin(N)
    /usr/local/{,s}bin(N)
    $path
  )

  fpath=(
    /usr/local/share/zsh/site-functions
    $fpath
  )
fi
