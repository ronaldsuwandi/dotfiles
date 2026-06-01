#!/usr/bin/env bash
LAYOUT=$(yabai -m query --spaces --space | jq -r '.type')
if [ "$LAYOUT" = "bsp" ]; then
  yabai -m space --layout stack
else
  yabai -m space --layout bsp
fi
sketchybar --trigger yabai_layout_change
