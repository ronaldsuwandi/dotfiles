#!/usr/bin/env bash
if [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set volume popup.drawing=off
else
  osascript -e "set volume output volume $PERCENTAGE"
fi
