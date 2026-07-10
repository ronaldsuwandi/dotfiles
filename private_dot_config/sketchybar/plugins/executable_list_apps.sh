#!/usr/bin/env bash

LOCKFILE="/tmp/sketchybar_list_apps.lock"
[ -f "$LOCKFILE" ] && exit 0
touch "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT
sleep 0.1

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

# tiled windows, in paneru's on-screen order, for the active workspace
TILED=$(paneru query state | jq -c '.virtual_workspaces[] | select(.active == true) | .windows')
TILED_APPS=$(echo "$TILED" | jq -c '[.[].app_name] | unique')

# paneru doesn't track floating windows at all, and yabai's own is-floating flag isn't
# reliable now that yabai no longer manages tiling. So: anything yabai sees on this space
# that paneru doesn't already account for must be floating. paneru takes priority on
# conflict (edge case: same app with one managed + one floating window shows as tiled-only for now)
FLOATING=$(yabai -m query --windows --space | jq -c --argjson tiled "$TILED_APPS" \
  'map(select(.["is-visible"] == true and .subrole == "AXStandardWindow" and (.app as $a | $tiled | index($a)) == null))')

COLOR="$WHITE"
app=(
  background.height=20
  background.border_width=2
  background.corner_radius=5
  background.border_color=0xffcdd6f4
  background.color=0xff1a1b26
  label.padding_left=6
  label.padding_right=10
  background.padding_left=7
  background.padding_right=7
  label.background.height=30
  label.height=30
  label.color=$COLOR
  drawing=on
  icon.padding_left=10
  icon.font.size=20
)

# ponytail: O(n^2) dedup via jq object-merge (keeps first-seen order); fine, a space only ever has a handful of windows
apps=$(echo "$FLOATING" | jq -r 'reduce .[] as $w ({}; . + {($w.pid|tostring): $w.app}) | to_entries | map(.value) | join(" | ")')

# Clear if no visible apps
if [[ -z "$apps" ]]; then
  sketchybar --set running_apps_updater background.border_width=0 label="" label.drawing=off background.drawing=off icon.drawing=off
else
  sketchybar --set running_apps_updater "${app[@]}" label="› $apps" label.drawing=on background.drawing=on icon="󰅟" icon.color=$ORANGE icon.drawing=on
fi

count=$(( $(echo "$TILED" | jq 'length') + $(echo "$FLOATING" | jq 'length') ))
sketchybar --set windows label="$count 󰖲"
