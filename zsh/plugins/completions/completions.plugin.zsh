local completions_dir="$ZDOTDIR/completions"

[[ -d "$completions_dir" ]] || return

local -a completion_fpaths=(
  "$completions_dir"
  /opt/homebrew/share/zsh/site-functions(N)
  /usr/local/share/zsh/site-functions(N)
  /usr/local/share/zsh/vendor-completions(N)
  /usr/share/zsh/vendor-completions(N)
  /usr/share/zsh/site-functions(N)
)

fpath=(
  $completion_fpaths
  $fpath
)

typeset -gU fpath

# oh-my-zsh's aws plugin prefers aws_completer, which overrides the static _aws
# completion shipped by package managers. Rebind aws after ez-compinit runs.
autoload -U add-zsh-hook

_dotfiles_restore_static_completions() {
  add-zsh-hook -d precmd _dotfiles_restore_static_completions

  (( ${+functions[compdef]} )) || return
  (( ${+functions[_aws]} )) || return

  compdef _aws aws
}

add-zsh-hook precmd _dotfiles_restore_static_completions
