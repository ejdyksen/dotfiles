if [[ -d "$HOME/.local/share/mise/installs/go" ]]; then

  export GOPATH="$HOME/.local/share/go"        # Base directory for Go packages
  export GOMODCACHE="$HOME/.cache/go/mod"      # Module cache location
  export GOCACHE="$HOME/.cache/go/build"       # Build cache location

  # Ensure GOBIN is in PATH if it's not already
  # This is needed for Go-installed binaries
  # if [[ ":$PATH:" != *":$GOPATH/bin:"* ]]; then
  #   PATH=(
  #     "$GOPATH/bin"
  #     $PATH
  #   )
  # fi

fi
