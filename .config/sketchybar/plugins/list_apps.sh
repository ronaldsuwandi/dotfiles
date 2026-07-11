#!/usr/bin/env bash

LOCKFILE="/tmp/sketchybar_list_apps.lock"
[ -f "$LOCKFILE" ] && exit 0
touch "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT
sleep 0.05

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

# tiled windows, in paneru's on-screen order, for the active workspace
TILED=$(paneru query state | jq -c '.virtual_workspaces[] | select(.active == true) | .windows')
TILED_IDS=$(echo "$TILED" | jq -c '[.[].window_id]')

# paneru doesn't track floating windows at all, and yabai's own is-floating flag isn't
# reliable now that yabai no longer manages tiling. So: anything yabai sees on this space
# that paneru doesn't already list must be floating. paneru's window_id and yabai's id
# are the same underlying value, so this excludes exactly the tiled windows, not whole
# apps — a second window of an already-tiled app still shows up here as floating.
FLOATING=$(yabai -m query --windows --space | jq -c --argjson tiled "$TILED_IDS" \
  'map(select(.["is-visible"] == true and .subrole == "AXStandardWindow" and (.id as $i | $tiled | index($i)) == null))')

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

# mark the focused tiled window with ‹ › (paneru's own per-window .focused flag)
apps_tiled=$(echo "$TILED" | jq -r 'map(if .focused then "‹ " + .app_name + " ›" else .app_name end) | join(" | ")')

# ponytail: O(n^2) dedup via jq object-merge (keeps first-seen order); fine, a space only ever has a handful of windows
apps_floating=$(echo "$FLOATING" | jq -r 'reduce .[] as $w ({}; . + {($w.pid|tostring): $w.app}) | to_entries | map("󰅟 " + .value) | join(" | ")')

label="$apps_tiled"
[ -n "$apps_floating" ] && label="${label:+$label | }$apps_floating"

# Clear if no visible apps
if [[ -z "$label" ]]; then
  sketchybar --set running_apps_updater background.border_width=0 label="" label.drawing=off background.drawing=off
else
  sketchybar --set running_apps_updater "${app[@]}" label="$label" label.drawing=on background.drawing=on
fi

count=$(( $(echo "$TILED" | jq 'length') + $(echo "$FLOATING" | jq 'length') ))
sketchybar --set windows label="$count 󰖲"
