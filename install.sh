#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if SCRIPT_PATH is not under HOME, create .dotfiles symlink if needed
if [[ "$SCRIPT_PATH" != "$HOME"* ]]; then
  echo "Dotfiles not in HOME directory, creating .dotfiles symlink"
  if [[ -L "$HOME/.dotfiles" ]]; then
    rm "$HOME/.dotfiles"
  fi
  ln -s "$SCRIPT_PATH" "$HOME/.dotfiles"
fi

if [[ $1 == "-f" ]]; then
  FORCE=1
else
  FORCE=0
fi

function linkdotfile {
  # Support both direct paths and paths with source/dest format
  if [[ $# -eq 2 ]]; then
    SRC="$SCRIPT_PATH/$1"
    DEST="$HOME/$2"
  else
    SRC="$SCRIPT_PATH/$1"
    DEST="$HOME/$1"
  fi

  # Create parent directory if it doesn't exist
  DEST_DIR=$(dirname "$DEST")
  if [[ ! -d "$DEST_DIR" ]]; then
    mkdir -p "$DEST_DIR"
  fi

  # Only delete dirs if -f
  if [[ $FORCE -eq 1 && -d $DEST ]]; then
    echo "Linking: $DEST (forced)"
    rm -rf "$DEST"
    ln -s "$SRC" "$DEST"
    return
  fi

  if [[ -d $DEST && ! -L $DEST ]]; then
    echo "Skipping: $DEST (dir exists)"
    return
  fi

  # Just always delete files/links
  if [[ -f $DEST || -L $DEST ]]; then
    rm -f "$DEST"
  fi

  echo "Linking: $DEST"
  ln -s "$SRC" "$DEST"
}

linkdotfile "zsh/.zshenv" ".zshenv"
linkdotfile "bash/.bashrc" ".bashrc"
linkdotfile "bash/.bash_profile" ".bash_profile"
linkdotfile "git/gitconfig" .gitconfig
linkdotfile "other/tmux.conf" .tmux.conf
linkdotfile ssh .ssh

# Platform specific config
if [[ -d "/workspaces/.codespaces/.persistedshare/dotfiles" ]]; then
  echo "Setting up git and ssh for Codespaces"
  ln -s $SCRIPT_PATH/git/gitconfig.codespaces $SCRIPT_PATH/git/gitconfig.platform
  ln -s $SCRIPT_PATH/ssh/config.linux $SCRIPT_PATH/ssh/config
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Setting up git and ssh for macOS"
  ln -s $SCRIPT_PATH/git/gitconfig.macos $SCRIPT_PATH/git/gitconfig.platform
  ln -s $SCRIPT_PATH/ssh/config.macos $SCRIPT_PATH/ssh/config
elif [[ "$OSTYPE" == "linux"* ]]; then
  echo "Setting up git and ssh for Linux"
  ln -s $SCRIPT_PATH/git/gitconfig.linux $SCRIPT_PATH/git/gitconfig.platform
  ln -s $SCRIPT_PATH/ssh/config.linux $SCRIPT_PATH/ssh/config
fi

touch $SCRIPT_PATH/git/gitconfig.local
touch $SCRIPT_PATH/ssh/config.local
