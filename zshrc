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

# Add new homebrew to path
if [ -d "/opt/homebrew" ]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  HOMEBREW_HOME="/opt/homebrew"
else
  HOMEBREW_HOME="/usr/local"
fi

# Initialize rbenv
if [ -d "${HOMEBREW_HOME}/Cellar/rbenv" ]; then
  eval "$(rbenv init -)"
fi

# Initialize pyenv
if [ -d "${HOMEBREW_HOME}/Cellar/pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi

# Initialize nodenv
if [ -d "${HOMEBREW_HOME}/Cellar/nodenv" ]; then
  eval "$(nodenv init -)"
fi

# Zsh completion for gcloud
if [ -d "${HOMEBREW_HOME}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/" ]; then
  source "${HOMEBREW_HOME}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "${HOMEBREW_HOME}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

# Zsh completion for Homebrew packages (aws, az, kubectl, etc)
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

autoload -U +X bashcompinit && bashcompinit
if [ -d "${HOMEBREW_HOME}/Cellar/azure-cli" ]; then
  source "${HOMEBREW_HOME}/etc/bash_completion.d/az"
fi


# Aliases

alias stt='code .'
alias kc='kubectl'
