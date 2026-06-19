#!/usr/bin/env bash
DIRECTION="$1"

snap() {
    [ "$DIRECTION" = "left" ] && yabai -m window --grid "8:3:0:0:1:8" || yabai -m window --grid "8:3:2:0:1:8"
}

WINDOW=$(yabai -m query --windows --window)
IS_FLOATING=$(echo "$WINDOW" | jq '."is-floating"')

if [ "$IS_FLOATING" = "false" ]; then
    yabai -m window --toggle float && snap
else
    SCREEN_MID=$(yabai -m query --displays --display | jq '.frame.w / 2')
    ON_SIDE=$(echo "$WINDOW" | jq --arg d "$DIRECTION" --argjson m "$SCREEN_MID" \
        'if $d == "left" then .frame.x < $m else .frame.x >= $m end')
    [ "$ON_SIDE" = "true" ] && yabai -m window --toggle float || snap
fi
sketchybar --trigger yabai_zoom_change
