#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

FOCUSED=$(yabai -m query --windows --window 2>/dev/null)
ZOOMED=$(echo "$FOCUSED" | jq -r '.["has-fullscreen-zoom"]')
FLOATED=$(echo "$FOCUSED" | jq -r '.["is-floating"]')

if [[ "$SENDER" = "front_app_switched" ]]; then
  front_app="$INFO"
else
  front_app=$(echo "$FOCUSED" | jq -r '.app')
fi

sketchybar --set "$NAME" background.image="app.${front_app}" label="$front_app"
if [ "$ZOOMED" = "true" ]; then
  sketchybar --set window_zoom_float drawing=on label="󰊓"
elif [ "$FLOATED" = "true" ]; then
  sketchybar --set window_zoom_float drawing=on label="󰅟"
else
  sketchybar --set window_zoom_float drawing=off
fi
