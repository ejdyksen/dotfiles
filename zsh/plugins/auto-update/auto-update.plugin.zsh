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
local now last_update=0
now=$(date +%s)
[[ -f "$state_dir/last_update" ]] && last_update=$(<"$state_dir/last_update")
(( now - last_update < ${DOTFILES_UPDATE_INTERVAL:-2592000} )) && return

# Launch background worker (disowned, no job control output)
{
  "$ZDOTDIR/plugins/auto-update/_dotfiles_update_worker" \
    "${DOTFILES:-$HOME/.dotfiles}" "$state_dir"
} &!
