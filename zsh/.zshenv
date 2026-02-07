#!/bin/zsh
#
# .zshenv - Zsh environment file, loaded always.
#
# NOTE: .zshenv needs to live at ~/.zshenv, not in $ZDOTDIR!

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

# Codespaces handles $ZDOTDIR, so explicitly set it if we're on a codespaces machine
if [[ -d "/workspaces/.codespaces/.persistedshare/dotfiles" ]]; then
  export DOTFILES="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  export DOTFILES=${DOTFILES:-$HOME/.dotfiles}
fi

# Set DOTFILES environment variable to the parent directory of this file
export ZDOTDIR="${DOTFILES}/zsh"

# Make sure the HISTFILE is in ZDOTDIR, since the omz lib/history.zsh helpfully sets it if not
export HISTFILE="$ZDOTDIR/.zsh_history"

# Ensure key paths are available for non-interactive, non-login shells (e.g. mosh)
# Login shells will get the full PATH setup from .zprofile after path_helper runs
path=(
  $HOME/.dotfiles/bin(N)
  $HOME/.local/bin(N)
  /opt/homebrew/sbin(N)
  /opt/homebrew/bin(N)
  /usr/local/sbin(N)
  /usr/local/bin(N)
  $path
)
typeset -gU path
