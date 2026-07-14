#!/usr/bin/env bash
AXIS="$1"  # h or v
WINDOW=$(yabai -m query --windows --window)
DISPLAY=$(yabai -m query --displays --display)

if [ "$AXIS" = "h" ]; then
    X=$(jq -n --argjson w "$WINDOW" --argjson d "$DISPLAY" '(($d.frame.x + ($d.frame.w - $w.frame.w) / 2) | floor)')
    Y=$(echo "$WINDOW" | jq '.frame.y | floor')
else
    X=$(echo "$WINDOW" | jq '.frame.x | floor')
    Y=$(jq -n --argjson w "$WINDOW" --argjson d "$DISPLAY" '(($d.frame.y + ($d.frame.h - $w.frame.h) / 2) | floor)')
fi

yabai -m window --move abs:"$X":"$Y"
