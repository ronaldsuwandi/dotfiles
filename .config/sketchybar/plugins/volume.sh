#!/usr/bin/env bash
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
  sketchybar --set "$NAME" icon="$ICON"
fi
