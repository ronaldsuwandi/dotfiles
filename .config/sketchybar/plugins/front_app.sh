#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

ACTIVE=$(paneru query active 2>/dev/null)
FOCUSED_APP=$(echo "$ACTIVE" | jq -r '.focused_app_name')
FLOATING=false

if [[ "$FOCUSED_APP" == "null" || -z "$FOCUSED_APP" ]]; then
  # paneru doesn't track focus for floating windows; fall back to yabai, but only
  # trust it for a real window (AXStandardWindow) — otherwise nothing is actually
  # focused (e.g. empty space) and yabai reports a stale/phantom window
  FOCUSED=$(yabai -m query --windows --window 2>/dev/null)
  if [[ "$(echo "$FOCUSED" | jq -r '.subrole')" == "AXStandardWindow" ]]; then
    FOCUSED_APP=$(echo "$FOCUSED" | jq -r '.app')
    FLOATING=true
  else
    FOCUSED_APP=""
  fi
fi

if [[ "$SENDER" = "front_app_switched" ]]; then
  front_app="$INFO"
else
  front_app="$FOCUSED_APP"
fi

sketchybar --set "$NAME" background.image="app.${front_app}" label="$front_app"
if [ "$FLOATING" = "true" ]; then
  sketchybar --set window_zoom_float drawing=on label="󰅟"
else
  sketchybar --set window_zoom_float drawing=off
fi
