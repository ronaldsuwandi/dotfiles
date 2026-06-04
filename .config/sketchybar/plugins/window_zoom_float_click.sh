#!/usr/bin/env bash
FOCUSED=$(yabai -m query --windows --window 2>/dev/null)
ZOOMED=$(echo "$FOCUSED" | jq -r '.["has-fullscreen-zoom"]')
if [ "$ZOOMED" = "true" ]; then
  yabai -m window --toggle zoom-fullscreen
else
  yabai -m window --toggle float
fi
sketchybar --trigger yabai_zoom_change
