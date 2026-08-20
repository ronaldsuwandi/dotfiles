#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh"

BATT="$(pmset -g batt)"
[[ "$BATT" =~ ([0-9]+)% ]] && PERCENTAGE="${BASH_REMATCH[1]}"
[ -z "$PERCENTAGE" ] && exit 0

if [ "$PERCENTAGE" -ge 88 ]; then
  ICON="􀛨"
elif [ "$PERCENTAGE" -ge 63 ]; then
  ICON="􀺸"
elif [ "$PERCENTAGE" -ge 38 ]; then
  ICON="􀺶"
elif [ "$PERCENTAGE" -ge 13 ]; then
  ICON="􀛩"
else
  ICON="􀛪"
fi

COLOR="$ICON_COLOR"
if [[ "$BATT" == *"AC Power"* ]]; then
  ICON="􀢋"
elif [ "$PERCENTAGE" -le 20 ]; then
  COLOR="$RED"
fi

sketchybar --set "$NAME" icon="${PERCENTAGE}%" label.color="$COLOR" label=" $ICON" label.padding_right=6
