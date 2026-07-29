#!/bin/zsh
#
# .zshenv - Zsh environment file, loaded always.
#
# NOTE: .zshenv needs to live at ~/.zshenv, not in $ZDOTDIR!

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

# Codespaces handles $ZDOTDIR, so explicitly set it if we're on a codespaces machine
if [[ -d "/workspaces/.codespaces/.persistedshare/dotfiles" ]]; then
  export DOTFILES="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  export DOTFILES=${DOTFILES:-$HOME/.dotfiles}
fi

# Set DOTFILES environment variable to the parent directory of this file
export ZDOTDIR="${DOTFILES}/zsh"

# Make sure the HISTFILE is in ZDOTDIR, since the omz lib/history.zsh helpfully sets it if not
export HISTFILE="$ZDOTDIR/.zsh_history"

# Silence homebrew autoupdate message
export HOMEBREW_NO_ENV_HINTS=1

# Turn off the shell-side half of Terminal's Resume (/etc/zshrc_Apple_Terminal).
# Window/tab/cwd restore is Terminal's own state and is unaffected, as is
# update_terminal_cwd -- that sits outside the block this disables.
#
# The block runs from /etc/zshrc, ahead of p10k's instant prompt where zle isn't
# up and keystrokes echo raw. It forked mkdir/rm there and date/find/shlock/wc
# on exit, all writing under $ZDOTDIR where a file monitor is watching. All it
# saved was a "Restored session: <date>" one-liner per shell; the per-session
# history it also offers self-disables because .zshrc sets SHARE_HISTORY.
export SHELL_SESSIONS_DISABLE=1

# Ensure key paths are available for non-interactive, non-login shells (e.g. mosh)
# Login shells will get the full PATH setup from .zprofile after path_helper runs
path=(
  $HOME/.dotfiles/bin(N)
  $HOME/.local/bin(N)
  /opt/homebrew/sbin(N)
  /opt/homebrew/bin(N)
  /usr/local/sbin(N)
  /usr/local/bin(N)
  $path
)
typeset -gU path
