#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

# Query windows in the current space
WINDOWS=$(yabai -m query --windows --space)

# Clear existing app items from the bar
sketchybar --remove '/runningapp.*/'

app=(
  background.height=20
  background.border_width=2
  background.corner_radius=5
  background.border_color=0xffcdd6f4
  background.color=0xff1a1b26
  label.padding_left=10
  label.padding_right=10
  background.padding_left=7
  background.padding_right=7
  label.background.height=30
)
echo "$WINDOWS" | jq -c 'unique_by(.pid) | .[] | select(.["is-visible"] == true) | {pid: .pid, app: .app}' | while read -r window; do
  pid=$(echo "$window" | jq -r '.pid')
  app_name=$(echo "$window" | jq -r '.app')
  # Add app to sketchybar
  sketchybar --add item runningapp.$pid right \
             --set runningapp.$pid label="$app_name" \
             script="osascript -e \"tell application \\\"System Events\\\" to set frontmost of the first process whose unix id is $pid to true\"" \
             "${app[@]}" \
             --subscribe runningapp.$pid mouse.clicked
done

