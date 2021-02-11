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

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Aliases

alias st='subl'
alias stt='subl .'
