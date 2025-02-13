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

# Platform specific config
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  ln -s $SCRIPT_PATH/.gitconfig_macos $SCRIPT_PATH/.gitconfig_local
  ln -s $SCRIPT_PATH/.ssh/config_macos $SCRIPT_PATH/.ssh/config
elif [[ "$OSTYPE" == "linux"* ]]; then
  # Linux
  ln -s $SCRIPT_PATH/.gitconfig_linux $SCRIPT_PATH/.gitconfig_local
  ln -s $SCRIPT_PATH/.ssh/config_linux $SCRIPT_PATH/.ssh/config
fi

touch $SCRIPT_PATH/.ssh/config_local
