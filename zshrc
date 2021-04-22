#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

autoload bashcompinit
bashcompinit

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Initialize rbenv
if [ -d "/usr/local/Cellar/rbenv" ]; then
  eval "$(rbenv init -)"
fi

# Initialize pyenv
if [ -d "/usr/local/Cellar/pyenv" ]; then
  eval "$(pyenv init -)"
fi

# Initialize nodenv
if [ -d "/usr/local/Cellar/nodenv" ]; then
  eval "$(nodenv init -)"
fi

# Zsh completion for gcloud
if [ -d "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/" ]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

# Zsh completion for Homebrew packages (aws, az, kubectl, etc)
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

autoload -U +X bashcompinit && bashcompinit
if [ -d "/usr/local/Cellar/azure-cli" ]; then
  source '/usr/local/etc/bash_completion.d/az'
fi


# Aliases

alias stt='code .'
alias kc='kubectl'
