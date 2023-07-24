#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $1 == "-f" ]]; then
  FORCE=1
else
  FORCE=0
fi

function linkdotfile {
  SRC="$SCRIPT_PATH/$1"
  DEST="$HOME/$1"

  # Only delete dirs if -f
  if [[ $FORCE -eq 1 && -d $DEST ]]; then
    echo "Linking: $DEST (forced)"
    rm -rf $DEST
    ln -s $SRC $DEST
    return
  fi

  if [[ -d $DEST ]]; then
    echo "Skipping: $DEST (dir exists)"
    return
  fi

  # Just always delete files/links
  if [[ -f $DEST || -L $DEST  ]]; then
    rm -f $DEST
  fi

  echo "Linking: $DEST"
  ln -s $SRC $DEST
}

linkdotfile .zshrc
linkdotfile .zshenv

linkdotfile .asdfrc
linkdotfile .gitconfig
linkdotfile .gitignore_global
linkdotfile .tmux.conf
linkdotfile .ssh
