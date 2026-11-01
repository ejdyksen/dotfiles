# Auto-update dotfiles periodically in the background
[[ "${DOTFILES_AUTO_UPDATE:-1}" == "1" ]] || return
(( ${+commands[git]} )) || return

local state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"

# --- Phase 1: Notify user of previous update result ---
if [[ -f "$state_dir/result" ]]; then
  local result=$(<"$state_dir/result")
  case "$result" in
    pulled) print -P "%F{green}[dotfiles]%f Updated. Restart your shell for changes." ;;
    failed) print -P "%F{yellow}[dotfiles]%f Auto-update failed. See: $state_dir/update.log" ;;
  esac
  command rm -f "$state_dir/result"
fi

# --- Phase 2: Check if update is due ---
# $EPOCHSECONDS is $(date +%s) without the fork.
zmodload -F zsh/datetime p:EPOCHSECONDS
local now=$EPOCHSECONDS last_update=0
[[ -f "$state_dir/last_update" ]] && last_update=$(<"$state_dir/last_update")
(( now - last_update < ${DOTFILES_UPDATE_INTERVAL:-2592000} )) && return

# Launch background worker in its own session, with no controlling terminal.
#
# `&!` alone leaves it attached to this tty in a background process group, and
# zsh's `read -d` touches the tty's settings even when reading a heredoc -- which
# antidote.zsh does at startup. The kernel stops any background job doing that
# (SIGTTOU), so the worker would hang forever, never record last_update, and make
# Terminal warn about running processes when the window closes.
#
# macOS has no setsid(1). The perl version forks first because setsid() fails for
# a process group leader. If neither exists, skip: no update beats a hung worker.
local -a detach
if (( ${+commands[setsid]} )); then
  detach=(setsid)
elif (( ${+commands[perl]} )); then
  detach=(perl -MPOSIX -e 'fork && POSIX::_exit(0); POSIX::setsid(); exec @ARGV')
else
  return
fi

{
  $detach "$ZDOTDIR/plugins/auto-update/_dotfiles_update_worker" \
    "${DOTFILES:-$HOME/.dotfiles}" "$state_dir" </dev/null &>/dev/null
} &!
