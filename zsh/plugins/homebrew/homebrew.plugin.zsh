if (( ! $+commands[brew] )); then
  if [[ -n "$BREW_LOCATION" ]]; then
    if [[ ! -x "$BREW_LOCATION" ]]; then
      echo "[oh-my-zsh] $BREW_LOCATION is not executable"
      return
    fi
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    BREW_LOCATION="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    BREW_LOCATION="/usr/local/bin/brew"
  elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    BREW_LOCATION="/home/linuxbrew/.linuxbrew/bin/brew"
  elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
    BREW_LOCATION="$HOME/.linuxbrew/bin/brew"
  else
    return
  fi

  # Only add Homebrew installation to PATH, MANPATH, and INFOPATH if brew is
  # not already on the path, to prevent duplicate entries. This aligns with
  # the behavior of the brew installer.sh post-install steps.
  eval "$("$BREW_LOCATION" shellenv)"
  unset BREW_LOCATION
fi
