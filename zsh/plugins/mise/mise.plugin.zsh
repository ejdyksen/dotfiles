(( ${+commands[mise]} )) || return

# Full activation for interactive shells: real binary paths on PATH instead of
# the shims from .zprofile. This is a cache of `eval "$(mise activate zsh)"` --
# run that by hand to compare if tool resolution ever looks wrong.
#
# Caching is safe because the output depends only on the mise version, not on
# cwd, environment, or session, so the binary's mtime is a sufficient cache key.
# Only *activation* is cached, not the resolved tool environment -- `_mise_hook`
# still runs on precmd/chpwd, so per-directory versions resolve as usual.
() {
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise-activate.zsh"

  if [[ ! -s $cache || $commands[mise] -nt $cache ]]; then
    [[ -d $cache:h ]] || mkdir -p $cache:h
    mise activate zsh >| $cache || { rm -f -- $cache; return }
    zcompile -R -- $cache 2>/dev/null
  fi

  source $cache
}
