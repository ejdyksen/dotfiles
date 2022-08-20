#!/usr/bin/env bash

git clone --recursive https://github.com/ejdyksen/prezto.git ~/.zprezto

real_path () {
    _=`pwd`
    [ -d $DIR ] && DIR=$1
    [ -f $DIR ] && DIR=`dirname $1`
    cd $DIR && echo `pwd` && cd $_
}

SCRIPT_DIR=$(real_path $0)
SCRIPT_PATH=${SCRIPT_DIR}/`basename $0`
FORCE=1
PREFIX=$HOME

while getopts "fp:" flag; do
  case "$flag" in
    f) FORCE=1 ;;
    p) PREFIX=$OPTARG ;;
  esac
done

PREFIX=${PREFIX%/}

for FILE_PATH in ${SCRIPT_DIR}/*; do
  FILE=$(basename $FILE_PATH)
  HOME_PATH=$PREFIX/.${FILE}

  if [[ $FILE_PATH = $SCRIPT_PATH ]]; then
    continue
  fi

  if [[ $FILE_PATH = $SCRIPT_PATH || ${FILE:0:1} = '.' ]]; then
    continue
  fi

  if [[ $FORCE -eq 0 && -e $HOME_PATH ]]; then
    echo Skipping $FILE_PATH
    continue
  fi

  if [[ $FORCE -eq 1 && -e $HOME_PATH ]]; then
    echo Forcably linking $FILE_PATH to $HOME_PATH
    rm -f $HOME_PATH
  else
    echo Linking $FILE_PATH to $HOME_PATH
  fi

  ln -s $FILE_PATH $HOME_PATH
done
