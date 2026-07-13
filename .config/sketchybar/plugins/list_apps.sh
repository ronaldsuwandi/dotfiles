#!/usr/bin/env bash

LOCKFILE="/tmp/sketchybar_list_apps.lock"
PENDING="/tmp/sketchybar_list_apps.pending"

# every event marks work as pending, then tries to become the updater.
# if someone else holds the lock, they'll see $PENDING and do another pass —
# events are coalesced, never dropped (this was the stuck-floating bug).
touch "$PENDING"
mkdir "$LOCKFILE" 2>/dev/null || exit 0   # mkdir is atomic, unlike touch
trap 'rmdir "$LOCKFILE"' EXIT

while [ -f "$PENDING" ]; do
rm -f "$PENDING"
sleep 0.05

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

# tiled windows, in paneru's on-screen order, for the active workspace
TILED=$(paneru query state | jq -c '.virtual_workspaces[] | select(.active == true) | .windows')

# paneru doesn't track floating windows at all, and yabai's own is-floating flag isn't
# reliable now that yabai no longer manages tiling. So: anything yabai sees on this space
# that paneru doesn't already list must be floating. paneru's window_id and yabai's id
# are the same underlying value, so this excludes exactly the tiled windows, not whole
# apps — a second window of an already-tiled app still shows up here as floating.
FLOATING=$(yabai -m query --windows --space | jq -c --argjson tiled "$TILED" '
  ([$tiled[].window_id]) as $tiled_ids
  | map(select(.["is-visible"] == true and .subrole == "AXStandardWindow" and (.id as $i | $tiled_ids | index($i)) == null))')

COLOR="$WHITE"
app=(
  background.height=20
  background.border_width=2
  background.corner_radius=5
  label.padding_left=10
  label.padding_right=12
  label.background.height=30
  label.color=$COLOR
  drawing=on
)

# split tiled windows around the focused one (paneru's on-screen order), floating windows
# (deduped by pid, ponytail: O(n^2) object-merge, fine for a handful of windows) get their own bucket;
# ponytail: no focused tiled window (empty space / floating frontmost) -> no split point, everything goes left
SPLIT=$(jq -n -c --argjson tiled "$TILED" --argjson floating "$FLOATING" '
  ($tiled | [.[] | .focused] | index(true)) as $idx
  | ($tiled | if $idx == null then . else .[0:$idx] end) as $left
  | ($tiled | if $idx == null then null else .[$idx] end) as $center
  | ($tiled | if $idx == null then [] else .[($idx+1):] end) as $right_tiled
  | ($floating | reduce .[] as $w ({}; . + {($w.pid|tostring): $w.app}) | [.[]]) as $floating_names
  | { left: ($left | map(.app_name) | join("  ")),
      center: ($center.app_name // ""),
      right: ($right_tiled | map(.app_name) | join("  ")),
      float: ($floating_names | join(" | ")),
      count: (($tiled | length) + ($floating | length)) }')


# use 1 jq command and split into array
fields=()
while IFS= read -r line; do
  fields+=("$line")
done < <(echo "$SPLIT" | jq -r '.left, .center, .right, .float, .count')

apps_left="${fields[0]}"
center_app="${fields[1]}"
apps_right="${fields[2]}"
apps_float="${fields[3]}"
window_count="${fields[4]}"

plain_args() {
  local label="$1"; shift
  if [[ -z "$label" ]]; then
    args=(background.drawing=off label="" label.drawing=off)
  else
    args=("${app[@]}" background.drawing=on label.color=$COLOR label="$label" label.drawing=on)
  fi
}

center_args_fn() {
  local label="$1"
  if [[ -z "$label" ]]; then
    args=(background.drawing=off label="" label.drawing=off)
  else
    args=("${app[@]}" background.color=0x40ffffff label="$label" label.drawing=on background.drawing=on)
  fi
}

float_args_fn() {
  local label="$1"
  if [[ -z "$label" ]]; then
    args=(background.drawing=off icon.drawing=off label="" label.drawing=off)
  else
    args=(
      "${app[@]}"
      background.border_color=0xffcdd6f4
      background.color=0xff1a1b26
      background.padding_left=7
      background.padding_right=7
      icon=󰅟
      icon.color=$ORANGE
      icon.padding_left=8
      icon.padding_right=4
      icon.drawing=on
      label.padding_left=4
      label="$label"
      label.drawing=on
      background.drawing=on
    )
  fi
}

plain_args "$apps_left"; left_args=("${args[@]}")
center_args_fn "$center_app"; center_args=("${args[@]}")
plain_args "$apps_right"; right_args=("${args[@]}")
float_args_fn "$apps_float"; float_args=("${args[@]}")

# single invocation -> one bar redraw instead of four, avoids the flicker
sketchybar --set running_apps_left "${left_args[@]}" \
           --set running_apps_updater "${center_args[@]}" \
           --set running_apps_right "${right_args[@]}" \
           --set running_apps_float "${float_args[@]}" \
           --set windows label="$window_count 󰖲"
done
# ponytail: microsecond race between last pending-check and rmdir can drop one
# event; self-heals on the next event, unlike the old 200ms drop window
