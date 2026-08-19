#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh"

if [ "$SENDER" = "mouse.clicked" ]; then
  popup=(
    popup.drawing=toggle
    popup.background.color=$BAR_COLOR
    popup.align=center
    popup.background.corner_radius=8
  )
  sketchybar --set volume "${popup[@]}"
  exit
fi

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
  if [ "$VOLUME" -eq 0 ]; then
    ICON="􀊣"
  elif [ "$VOLUME" -le 33 ]; then
    ICON="􀊥"
  elif [ "$VOLUME" -le 67 ]; then
    ICON="􀊧"
  else
    ICON="􀊩"
  fi
  sketchybar --set "$NAME" icon="$ICON" \
             --set volume_slider slider.percentage="$VOLUME"
fi
