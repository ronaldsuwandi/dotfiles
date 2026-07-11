#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

FOCUSED_ID=$(paneru query active 2>/dev/null | jq -r '.focused_window_id')
FLOATED=false

if [[ "$SENDER" = "front_app_switched" ]]; then
  front_app="$INFO"
else
  front_app=$(yabai -m query --windows --window 2>/dev/null | jq -r '.app')
fi

# empty space: yabai's fallback query returns nothing to report, and the
# already-displayed app (from the last real front_app_switched) is still
# accurate enough — skip the update rather than flicker to blank
[[ -z "$front_app" || "$front_app" == "null" ]] && exit 0

if [[ "$FOCUSED_ID" == "null" || -z "$FOCUSED_ID" ]]; then
  # paneru doesn't track floating focus; a real floating window is a normal
  # AXStandardWindow — the Finder desktop (no window) reports the same null
  # focused_window_id but isn't an actual window, so don't flag it as floating
  SUBROLE=$(yabai -m query --windows --window 2>/dev/null | jq -r '.subrole')
  [[ "$SUBROLE" == "AXStandardWindow" ]] && FLOATED=true
fi

sketchybar --set "$NAME" background.image="app.${front_app}" label="$front_app"
if [ "$FLOATED" = "true" ]; then
  sketchybar --set window_zoom_float drawing=on label="󰅟"
else
  sketchybar --set window_zoom_float drawing=off
fi
