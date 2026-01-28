#!/bin/bash
#
# bashrc - Bash file loaded on interactive shell sessions.
#

# Reset history to bash defaults (don't inherit from zsh)
export HISTFILE="$HOME/.dotfiles/bash/.bash_history"
export HISTSIZE=500
export HISTCONTROL=ignoredups

# Basic prompt
PS1='\u@\h:\w\$ '
