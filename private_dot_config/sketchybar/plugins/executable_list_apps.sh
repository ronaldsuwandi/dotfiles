#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

# Query windows in the current space
WINDOWS=$(yabai -m query --windows --space | jq -c 'unique_by(.pid) | map(select(.["is-visible"] == true)) | sort_by(.app|ascii_downcase)')
WINDOWS_COUNT=$(echo $WINDOWS | jq -c 'length')
ACTIVE_PID=$(echo "$WINDOWS" | jq -c 'map(select(.["has-focus"] == true)) | .[].pid ');

COLOR="$WHITE"
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
  label.color=$COLOR
  drawing=on
)

apps=""
while read -r window; do
  pid=$(echo "$window" | jq -r '.pid')
  app_name=$(echo "$window" | jq -r '.app')
  if [[ -z "$apps" ]]; then
    apps="$app_name"
  else
    apps+=" | $app_name"
  fi
done <<< "$(echo "$WINDOWS" | jq -c 'map({pid: .pid, app: .app}) | .[]')"

# Remove trailing pipe symbol
apps="${apps%|}"

# Clear if no visible apps
if [[ -z "$apps" ]]; then
  sketchybar --set running_apps_updater background.border_width=0 label=""
else
  sketchybar --set running_apps_updater "${app[@]}" label="$apps"
fi
