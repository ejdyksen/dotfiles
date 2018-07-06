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
if [ -d "/usr/local/Cellar/rbenv" ]; then
  eval "$(rbenv init -)"
fi

# Initialize dnvm

# [ -s "/Users/ejd/.dnx/dnvm/dnvm.sh" ] && . "/Users/ejd/.dnx/dnvm/dnvm.sh" # Load dnvm

# Initialize nvm

# if [ -d "/usr/local/Cellar/nvm" ]; then
#   export NVM_DIR=~/.nvm
#   source $(brew --prefix nvm)/nvm.sh
# fi

# Zsh completion for awscli
if [ -d "/usr/local/Cellar/awscli" ]; then
  source /usr/local/share/zsh/site-functions/_aws
fi

# Zsh completion for gcloud
if [ -d "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/" ]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

# Aliases

alias st='subl'
alias stt='subl .'
