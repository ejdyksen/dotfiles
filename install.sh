#!/usr/bin/env bash
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if script flag opts -f or --force is set
if [[ $1 == "-f" ]]; then
  FORCE=1
else
  FORCE=0
fi

function linkdotfile {
  SRC="$SCRIPT_PATH/$1"
  DEST="$HOME/$1"

  if [[ $FORCE -eq 1 ]]; then
    echo "Linking: $DEST (forced)"
    rm -f $DEST
    ln -s $SRC $DEST
    return
  fi

  if [[ -d $DEST || -f $DEST || -L $DEST  ]]; then
    echo "Exists:  $DEST"
  else
    echo "Linking: $DEST"
    ln -s $SRC $DEST
  fi
}

linkdotfile .asdfrc
linkdotfile .gitconfig
linkdotfile .gitignore_global
linkdotfile .tmux.conf
linkdotfile .zshenv
linkdotfile .ssh
