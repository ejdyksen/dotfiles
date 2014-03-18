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

# Zsh completion for awscli
if which aws > /dev/null; then source ~/Library/Python/2.7/bin/aws_zsh_completer.sh; fi

# Initialize RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Customize to your needs...

alias st='subl'
alias stt='subl .'
