(( ${+commands[try]} )) || return

# Shell wrapper for try (github.com/tobi/try). This is a cache of
# `eval "$(try init)"` -- generating it boots Ruby, which would cost ~0.1-0.2s
# on every shell. Must load after plugins/mise, which puts `try` on PATH.
#
# The output hardcodes the absolute path of the gem's try.rb, which embeds both
# the Ruby and gem versions, so it goes stale whenever either is upgraded. The
# key is the binstub's mtime (rewritten by `gem install`/`gem update`) plus a
# check that the try.rb the cache names still exists -- a Ruby upgrade can leave
# an older-mtime binstub in front of a cache pointing at a removed install.
# This file's mtime is included too, so edits here rebuild it.
() {
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/try-init.zsh"

  if [[ ! -s $cache || $commands[try] -nt $cache || ${(%):-%x} -nt $cache ]] ||
     ! [[ "$(<$cache)" =~ "'([^']+/try\.rb)'" && -f $match[1] ]]; then
    [[ -d $cache:h ]] || mkdir -p $cache:h
    local out
    out=$(try init) || { rm -f -- $cache; return }
    print -r -- $out >| $cache
    zcompile -R -- $cache 2>/dev/null
  fi

  source $cache
}
