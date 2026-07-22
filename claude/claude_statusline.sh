#!/usr/bin/env bash
# Pretty Claude Code status line: model · effort · context-usage · cwd

input=$(cat)

model_name=$(jq -r '.model.display_name // "Claude"' <<<"$input")
cwd=$(jq -r '.workspace.current_dir // .cwd // ""' <<<"$input")

# Effort: live from the payload (reflects mid-session /effort changes); the payload
# omits it when the model has no effort parameter, so fall back to the saved default.
effort=$(jq -r '.effort.level // empty' <<<"$input")
[[ -z "$effort" ]] && effort=$(jq -r '.effortLevel // "default"' ~/.claude/settings.json 2>/dev/null)

# Git status — one porcelain pass drives branch, ahead/behind, file states, and
# stash; one rev-parse handles worktree detection; one log detects wip. Mirrors the
# Powerlevel10k my_git_formatter symbols/colors. (Omits p10k's push-remote ⇠⇢ and
# :remote-name markers — both niche and fiddly without gitstatusd.)
branch=""
in_worktree=0
wt_name=""
git_status=""
porc=$(git -C "$cwd" status --porcelain=v2 --branch --show-stash 2>/dev/null)
if [[ -n "$porc" ]]; then
  # Branch name, or short SHA when detached. Kept out of eval (ref names are untrusted).
  branch=$(awk '/^# branch.head/ { print $3; exit }' <<<"$porc")
  [[ "$branch" == "(detached)" ]] && \
    branch=$(awk '/^# branch.oid/ { print substr($3, 1, 8); exit }' <<<"$porc")

  # Counts from the same output (integers only → safe to eval)
  eval "$(awk '
    /^# branch\.ab / { ahead = $3 + 0; behind = -($4 + 0) }
    /^# stash /      { stash = $3 + 0 }
    /^[12] /         { if (substr($2,1,1) != ".") s++; if (substr($2,2,1) != ".") u++ }
    /^u /            { c++ }
    /^\? /           { q++ }
    END { printf "gs_staged=%d gs_unstaged=%d gs_untracked=%d gs_conflict=%d gs_ahead=%d gs_behind=%d gs_stash=%d",
                  s+0, u+0, q+0, c+0, ahead+0, behind+0, stash+0 }
  ' <<<"$porc")"

  # One rev-parse: worktree detection + absolute git-dir for the in-progress-op check.
  # In a linked worktree the git-dir differs from the shared common-dir.
  { read -r gdir; read -r gcommon; } \
    < <(git -C "$cwd" rev-parse --path-format=absolute --git-dir --git-common-dir 2>/dev/null)
  if [[ -n "$gcommon" && "$gdir" != "$gcommon" ]]; then
    in_worktree=1
    # Prefer the name CC hands us; fall back to the worktree dir basename
    wt_name=$(jq -r '.workspace.git_worktree // ""' <<<"$input")
    [[ -z "$wt_name" ]] && wt_name=$(basename "$cwd")
  fi

  # In-progress operation (filesystem checks — no subprocess)
  gs_action=""
  if   [[ -d "$gdir/rebase-merge" || -d "$gdir/rebase-apply" ]]; then gs_action="rebase"
  elif [[ -f "$gdir/MERGE_HEAD" ]];       then gs_action="merge"
  elif [[ -f "$gdir/CHERRY_PICK_HEAD" ]]; then gs_action="cherry-pick"
  elif [[ -f "$gdir/REVERT_HEAD" ]];      then gs_action="revert"
  elif [[ -f "$gdir/BISECT_LOG" ]];       then gs_action="bisect"
  fi

  # p10k palette
  M_CLEAN=$'\033[38;5;76m'   # green:  ahead/behind/stash
  M_MOD=$'\033[38;5;178m'    # yellow: staged/unstaged/wip
  M_UNTR=$'\033[38;5;39m'    # blue:   untracked
  M_CONF=$'\033[38;5;196m'   # red:    conflicts / in-progress op
  M_RST=$'\033[0m'

  # "wip" if the latest commit summary contains the word wip/WIP
  gs_summary=$(git -C "$cwd" log -1 --format=%s 2>/dev/null)
  [[ "$gs_summary" =~ (^|[^[:alnum:]])(wip|WIP)([^[:alnum:]]|$) ]] && git_status+=" ${M_MOD}wip${M_RST}"

  # Order mirrors p10k: ⇣behind⇡ahead  *stash  <op>  ~conflicts  +staged  !unstaged  ?untracked
  (( gs_behind )) && git_status+=" ${M_CLEAN}⇣${gs_behind}${M_RST}"
  if (( gs_ahead )); then
    (( gs_behind )) && git_status+="${M_CLEAN}⇡${gs_ahead}${M_RST}" \
                    || git_status+=" ${M_CLEAN}⇡${gs_ahead}${M_RST}"
  fi
  (( gs_stash ))       && git_status+=" ${M_CLEAN}*${gs_stash}${M_RST}"
  [[ -n "$gs_action" ]] && git_status+=" ${M_CONF}${gs_action}${M_RST}"
  (( gs_conflict ))    && git_status+=" ${M_CONF}~${gs_conflict}${M_RST}"
  (( gs_staged ))      && git_status+=" ${M_MOD}+${gs_staged}${M_RST}"
  (( gs_unstaged ))    && git_status+=" ${M_MOD}!${gs_unstaged}${M_RST}"
  (( gs_untracked ))   && git_status+=" ${M_UNTR}?${gs_untracked}${M_RST}"
fi

# Context window: sourced straight from the payload. `used_percentage` and
# `context_window_size` already account for the model's true window (incl. 1M),
# so no [1m] heuristic or transcript parsing is needed. Fields may be null before
# the first API response — jq fallbacks keep it at 0 then.
read -r ctx_max pct tokens < <(jq -r '
  [ (.context_window.context_window_size // 200000)
  , (.context_window.used_percentage // 0 | floor)
  , (.context_window.total_input_tokens // 0)
  ] | @tsv' <<<"$input" | tr '\t' ' ')
[[ -z "$pct" ]] && pct=0

# Pretty token string (12.3k / 1.05M)
fmt_tokens=$(awk -v t="$tokens" 'BEGIN {
  if (t < 1000) printf "%d", t
  else if (t < 1000000) printf "%.1fk", t/1000
  else printf "%.2fM", t/1000000
}')

# Progress bar with 10 cells
bar_len=10
filled=$(( pct * bar_len / 100 ))
(( filled > bar_len )) && filled=$bar_len
(( filled < 0 )) && filled=0
bar=""
for ((i=0; i<bar_len; i++)); do
  if (( i < filled )); then bar+="▰"; else bar+="▱"; fi
done

# Colors (24-bit truecolor where helpful)
RESET=$'\033[0m'
DIM=$'\033[2m'
BOLD=$'\033[1m'
CYAN=$'\033[38;5;39m'      # bright cyan-blue
MAGENTA=$'\033[38;5;177m'  # soft purple
GREY=$'\033[38;5;245m'
GREEN=$'\033[38;5;42m'      # branch
AMBER=$'\033[38;5;214m'    # worktree badge
SEP="${GREY}│${RESET}"

# Bar color by usage
if   (( pct < 50 )); then BAR_COLOR=$'\033[38;5;42m'   # green
elif (( pct < 80 )); then BAR_COLOR=$'\033[38;5;214m'  # amber
else                       BAR_COLOR=$'\033[38;5;203m'  # red
fi

# Effort color/icon
case "$effort" in
  xhigh) EFFORT_COLOR=$'\033[38;5;205m'; EFFORT_ICON="◆◆◆" ;;
  high)  EFFORT_COLOR=$'\033[38;5;177m'; EFFORT_ICON="◆◆"  ;;
  medium)EFFORT_COLOR=$'\033[38;5;111m'; EFFORT_ICON="◆"   ;;
  low)   EFFORT_COLOR=$'\033[38;5;245m'; EFFORT_ICON="◇"   ;;
  *)     EFFORT_COLOR="$GREY";            EFFORT_ICON="·"   ;;
esac

# Shorten cwd: ~ for home, basename if deep
short_cwd="${cwd/#$HOME/~}"
dir_name=$(basename "$short_cwd")

model_seg="${CYAN}⏺ ${BOLD}${model_name}${RESET}"
effort_seg="${EFFORT_COLOR}${EFFORT_ICON} ${effort}${RESET}"
ctx_seg="${BAR_COLOR}${bar}${RESET} ${BAR_COLOR}${pct}%${RESET} ${DIM}(${fmt_tokens})${RESET}"
dir_seg="${GREY}📁 ${dir_name}${RESET}"

# Optional git segments (omitted entirely outside a repo)
git_seg=""
if [[ -n "$branch" ]]; then
  git_seg="  ${SEP}  ${GREEN} ${branch}${RESET}${git_status}"
  (( in_worktree )) && git_seg+="  ${AMBER}🌳 ${wt_name}${RESET}"
fi

echo " ${model_seg}  ${SEP}  ${effort_seg}  ${SEP}  ${ctx_seg}  ${SEP}  ${dir_seg}${git_seg}"


 
