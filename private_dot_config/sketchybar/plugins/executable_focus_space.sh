#!/usr/bin/env sh
n="$1"
sketchybar --set /space\../ background.drawing=off icon.color=0xff1e1e2e --set space."$n" background.drawing=on icon.color=0xffffffff
yabai -m space --focus "$n"
