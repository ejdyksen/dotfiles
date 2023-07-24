#!/bin/zsh
#
# .zshenv - Zsh environment file, loaded always.
#
# NOTE: .zshenv needs to live at ~/.zshenv, not in $ZDOTDIR!

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

# Codespaces handles $ZDOTDIR, so explicitly set it if we're on a codespaces machine
if [[ -d "/workspaces/.codespaces/.persistedshare/dotfiles" ]]; then
  export ZDOTDIR="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  export ZDOTDIR=${ZDOTDIR:-$HOME/.dotfiles}
fi
