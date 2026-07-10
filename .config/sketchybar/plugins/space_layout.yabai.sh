#!/bin/sh
LAYOUT=$(yabai -m query --spaces --space 2>/dev/null | jq -r '.type' 2>/dev/null)
case "$LAYOUT" in
  bsp)   sketchybar --set "$NAME" label="󰓫" label.drawing=on ;;
  stack) sketchybar --set "$NAME" label="󰌨" label.drawing=on ;;
  *)     sketchybar --set "$NAME" label.drawing=off ;;
esac
