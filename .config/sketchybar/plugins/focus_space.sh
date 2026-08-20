#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"

n="$1"
sketchybar --set /space\../ background.drawing=off icon.color="$ICON_COLOR" --set space."$n" background.drawing=on icon.color="$WHITE"
yabai -m space --focus "$n"
