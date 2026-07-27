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

# Pin the compdump path rather than letting ez-compinit derive its own, so the
# staleness check below and run-compinit can't disagree about which file to use.
typeset -g ZSH_COMPDUMP="${ZSH_COMPDUMP:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump}"

autoload -U add-zsh-hook

# Bust the compdump when any fpath directory changes.
#
# compinit's own staleness check only compares the *count* of completion files
# against the `#files:` header in the dump, so a `brew upgrade` that repoints
# _foo at a new Cellar path -- same name, same count -- is invisible to it.
# A directory mtime catches that, and catches adds and removes too, which makes
# it strictly better than the count heuristic. That's what lets us run compinit
# with -C (see the use-cache zstyle in .zshrc): -C skips the count check
# entirely, so this becomes the only change detection in the system.
#
# Runs on precmd rather than at plugin load because fpath isn't complete until
# every plugin has loaded, and is pushed to the front of precmd_functions so it
# lands ahead of ez-compinit's run-compinit.
_dotfiles_bust_stale_compdump() {
  add-zsh-hook -d precmd _dotfiles_bust_stale_compdump

  [[ -f "$ZSH_COMPDUMP" ]] || return

  local dir
  for dir in $fpath; do
    if [[ "$dir" -nt "$ZSH_COMPDUMP" ]]; then
      rm -f -- "$ZSH_COMPDUMP" "$ZSH_COMPDUMP.zwc"
      return
    fi
  done
}

add-zsh-hook precmd _dotfiles_bust_stale_compdump
precmd_functions=(
  _dotfiles_bust_stale_compdump
  ${precmd_functions:#_dotfiles_bust_stale_compdump}
)

# oh-my-zsh's aws plugin prefers aws_completer, which overrides the static _aws
# completion shipped by package managers. Rebind aws after ez-compinit runs.
_dotfiles_restore_static_completions() {
  add-zsh-hook -d precmd _dotfiles_restore_static_completions

  (( ${+functions[compdef]} )) || return
  (( ${+functions[_aws]} )) || return

  compdef _aws aws
}

add-zsh-hook precmd _dotfiles_restore_static_completions
