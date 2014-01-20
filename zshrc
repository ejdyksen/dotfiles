#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Initialize rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi # rbenv

# Customize to your needs...

alias st='subl'
alias stt='subl .'
