if (( ${+commands[mise]} )); then
  # This overrides the `mise activate zsh --shims` command in .zprofile for interactive shells
  # This puts actual paths to real binaries on the PATH, instead of shims
  eval "$(mise activate zsh)"
fi
