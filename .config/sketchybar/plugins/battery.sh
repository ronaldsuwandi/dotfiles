#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo '[0-9]+%' | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep -c 'AC Power')"
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

COLOR="$BLACK"
if [ "$CHARGING" -gt 0 ]; then
  ICON="􀢋"
elif [ "$PERCENTAGE" -le 20 ]; then
  COLOR="$RED"
fi

sketchybar --set "$NAME" icon="${PERCENTAGE}%" label.color="$COLOR" label=" $ICON" label.padding_right=8
