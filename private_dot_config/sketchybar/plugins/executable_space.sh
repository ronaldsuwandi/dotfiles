#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"

if [ "$SELECTED" = "true" ]; then
  SPACE_ICON_COLOR=$WHITE
else
  SPACE_ICON_COLOR=$BLACK
fi

sketchybar --set $NAME background.drawing="$SELECTED" icon.color="$SPACE_ICON_COLOR"
