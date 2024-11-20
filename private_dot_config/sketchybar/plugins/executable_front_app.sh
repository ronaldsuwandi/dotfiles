#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO" 
    # --set /window.*/ label.background.color="$BAR_COLOR" \
    # --set "window.${INFO// /-}" label.background.color="$RED"
fi

