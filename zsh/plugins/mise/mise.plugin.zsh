(( ${+commands[mise]} )) || return

# Full activation for interactive shells: real binary paths on PATH instead of
# the shims from .zprofile. This is a cache of `eval "$(mise activate zsh)"` --
# run that by hand to compare if tool resolution ever looks wrong.
#
# One part of the output is environment-dependent and must not be cached: when
# mise detects an already-active session (e.g. rebuilding after an upgrade via
# `exec zsh`), it prepends a deactivation preamble whose first line is a
# literal `export PATH='...'` snapshot of PATH at generation time. Sourcing
# that later hard-assigns a stale PATH, clobbering entries added by plugins
# loaded before this one (e.g. pnpm). We strip that line when building the
# cache -- `_mise_hook` re-adds the right tool dirs on precmd/chpwd, so
# nothing is lost. The rest depends only on the mise version and the absolute
# path of the binary, which the output hardcodes. The key is the binary's mtime
# plus a check that the cache still names the current binary: a fresh install
# at a new location (e.g. Homebrew -> standalone) can carry an *older* mtime
# than the cache, so mtime alone would keep serving the dead path. This file's
# mtime is included too, so edits here rebuild it.
# Only *activation* is cached, not the resolved tool environment -- `_mise_hook`
# still runs on precmd/chpwd, so per-directory versions resolve as usual.
() {
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise-activate.zsh"

  if [[ ! -s $cache || $commands[mise] -nt $cache || ${(%):-%x} -nt $cache ||
        "$(<$cache)" != *"$commands[mise]"* ]]; then
    [[ -d $cache:h ]] || mkdir -p $cache:h
    local out
    out=$(mise activate zsh) || { rm -f -- $cache; return }
    print -rl -- ${${(f)out}:#export PATH=*} >| $cache
    zcompile -R -- $cache 2>/dev/null
  fi

  source $cache
}
