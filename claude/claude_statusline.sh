#!/usr/bin/env bash
# Pretty Claude Code status line: model · effort · context-usage · cwd

input=$(cat)

model_name=$(jq -r '.model.display_name // "Claude"' <<<"$input")
model_id=$(jq -r '.model.id // ""' <<<"$input")
transcript=$(jq -r '.transcript_path // ""' <<<"$input")
cwd=$(jq -r '.workspace.current_dir // .cwd // ""' <<<"$input")

# Effort comes from settings, not the status payload
effort=$(jq -r '.effortLevel // "default"' ~/.claude/settings.json 2>/dev/null)

# Context window: 1M models flagged with [1m]; otherwise 200k
if [[ "$model_id" == *"[1m]"* || "$model_id" == *"1m"* ]]; then
  ctx_max=1000000
else
  ctx_max=200000
fi

# Pull token usage from most recent assistant message in transcript
tokens=0
if [[ -f "$transcript" ]]; then
  tokens=$(tail -r "$transcript" 2>/dev/null | awk '
    /"usage"/ {
      print
      exit
    }
  ' | jq -r '
    (.message.usage.input_tokens // 0)
    + (.message.usage.cache_read_input_tokens // 0)
    + (.message.usage.cache_creation_input_tokens // 0)
    + (.message.usage.output_tokens // 0)
  ' 2>/dev/null)
  [[ -z "$tokens" || "$tokens" == "null" ]] && tokens=0
fi

pct=$(awk -v t="$tokens" -v m="$ctx_max" 'BEGIN { printf "%.0f", (t/m)*100 }')
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

echo " ${model_seg}  ${SEP}  ${effort_seg}  ${SEP}  ${ctx_seg}  ${SEP}  ${dir_seg}"


 
