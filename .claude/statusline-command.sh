#!/usr/bin/env bash
input=$(cat)

# Extract values
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
model_id=$(echo "$input" | jq -r '.model.id // ""')
model_display_name=$(echo "$input" | jq -r '.model.display_name // ""')
total_cost=$(printf "%.2f" "$(echo "$input" | jq -r '.cost.total_cost_usd // 0')")
tokens_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
tokens_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
cache_pct=$(echo "$input" | jq -r '.context_window.current_usage | (.cache_read_input_tokens // 0) as $r | ((.cache_read_input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.input_tokens // 0)) as $t | if $t > 0 then ($r * 100 / $t | floor) else 0 end')

# CWD
cwd_display=$(echo "$input" | jq -r '.cwd // ""')
cwd_display="${cwd_display/#$HOME/~}"
[ "${#cwd_display}" -gt 40 ] && cwd_display="…${cwd_display: -39}"

# Colors
R='\033[0m'
C1='\033[38;2;36;40;59m'
C2='\033[38;2;65;72;104m'
C3='\033[38;2;192;202;245m'
C4='\033[38;2;136;136;180m'
C5='\033[38;2;187;154;247m'
C6='\033[38;2;140;194;74m'
C7='\033[38;2;224;175;104m'
C8='\033[38;2;180;180;180m'
C9='\033[38;2;158;206;106m'
C10='\033[38;2;247;118;142m'
C11='\033[38;2;220;200;60m'
C12='\033[38;2;220;60;60m'
C13='\033[38;2;55;55;55m'

number() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    printf "%.1fM" "$(echo "scale=1; $n/1000000" | bc)"
  elif [ "$n" -ge 1000 ]; then
    printf "%.1fk" "$(echo "scale=1; $n/1000" | bc)"
  else
    printf "%d" "$n"
  fi
}

fmt_dur() {
  local ms=$1; local s=$(( ms/1000 )); local m=$(( s/60 )); local h=$(( m/60 ))
  m=$(( m%60 )); s=$(( s%60 ))
  if [ $h -gt 0 ]; then printf "%dh%02dm" $h $m
  elif [ $m -gt 0 ]; then printf "%dm%02ds" $m $s
  else printf "%ds" $s; fi
}

bar_ctx() {
  local pct=${1:-0}
  local w=6
  local f=$(( (pct * w + 50) / 100 ))
  [ $f -gt $w ] && f=$w; [ $f -lt 0 ] && f=0
  local e=$(( w - f ))
  local c="${C6}"
  [ "$pct" -ge 50 ] && c="${C11}"
  [ "$pct" -ge 80 ] && c="${C12}"
  local s=""
  for ((i=0; i<f; i++)); do s+="█"; done
  printf "${c}%s${C13}" "$s"
  s=""
  for ((i=0; i<e; i++)); do s+="█"; done
  printf "%s${R}" "$s"
}

bar_cache() {
  local pct=${1:-0}
  local w=6
  local f=$(( (pct * w + 50) / 100 ))
  [ $f -gt $w ] && f=$w; [ $f -lt 0 ] && f=0
  local e=$(( w - f ))
  local c="${C12}"
  [ "$pct" -ge 50 ] && c="${C11}"
  [ "$pct" -ge 80 ] && c="${C6}"
  local s=""
  for ((i=0; i<f; i++)); do s+="█"; done
  printf "${c}%s${C13}" "$s"
  s=""
  for ((i=0; i<e; i++)); do s+="█"; done
  printf "%s${R}" "$s"
}

# Build output
out=""
out+="${C3}${cwd_display}${R}"
out+="${C1} › ${R}"
out+="${C5}${model_display_name}${R}"
out+="${C1} › ${R}"
out+="${C2}⏱ ${R}${C7}$(fmt_dur "${duration_ms}")${R}"
out+="${C1} › ${R}"
out+="${C9}+$(number "${lines_added}")${R}${C2} ${R}${C10}-$(number "${lines_removed}")${R}"
out+="${C1} › ${R}"
out+="${C3}ctx: ${R}$(bar_ctx "${context_pct}") ${C3}${context_pct}%${R}"
out+="${C1} › ${R}"
out+="${C3}↓$(number "${tokens_in}")${R}"
out+="${C1} › ${R}"
out+="${C5}↑$(number "${tokens_out}")${R}"
out+="${C1} › ${R}"
out+="${C3}\$${total_cost}${R}"
out+="${C1} › ${R}"
out+="${C3}⚡ ${R}$(bar_cache "${cache_pct}") ${C3}${cache_pct}%${R}"

printf "%b" "$out"
