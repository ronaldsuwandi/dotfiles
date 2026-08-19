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

# paneru now reports floating (unmanaged) windows inline via the `floating`
# flag, and tracks focus correctly even onto floating windows — no more
# cross-referencing yabai to tell tiled from floating.
STATE=$(paneru query state)

# lid closed (clamshell, external-only) is the only case where the notch isn't in play
NOTCH_ACTIVE=true
ioreg -r -k AppleClamshellState -d 4 2>/dev/null | grep -q '"AppleClamshellState" = Yes' && NOTCH_ACTIVE=false
[[ "$NOTCH_ACTIVE" = true ]] && SIDE_FONT_SIZE=9.0 || SIDE_FONT_SIZE=10.5

COLOR="$BLACK"
app=(
  background.height=$APP_BG_HEIGHT
  background.border_width=$APP_BORDER_WIDTH
  background.corner_radius=$APP_CORNER_RADIUS
  label.padding_left=10
  label.padding_right=12
  label.background.height=$HEIGHT
  label.color=$COLOR
  drawing=on
)

# split tiled windows around the focused one (paneru's on-screen order), floating windows
# (deduped by bundle id, ponytail: O(n^2) object-merge, fine for a handful of windows) get their own bucket;
# ponytail: no focused tiled window (empty space / floating frontmost) -> no split point, everything goes left
fields=()
while IFS= read -r line; do
  fields+=("$line")
done < <(echo "$STATE" | jq -r '
  (.active.focused_window_id // 0) as $fid
  | (.virtual_workspaces[] | select(.active == true) | .windows) as $windows
  | ($windows | map(select(.floating == false))) as $tiled
  | ($windows | map(select(.floating == true))) as $floating
  | ($tiled | map(.window_id == $fid) | index(true)) as $idx
  | ($tiled | if $idx == null then . else .[0:$idx] end) as $left
  | ($tiled | if $idx == null then null else .[$idx] end) as $center
  | ($tiled | if $idx == null then [] else .[($idx+1):] end) as $right_tiled
  | ($floating | reduce .[] as $w ({}; . + {($w.bundle_id): $w.app_name}) | [.[]]) as $floating_names
  | ($left | map(.app_name) | join("    ")),
    (if $center.app_name then $center.app_name else "" end),
    ($right_tiled | map(.app_name) | join("    ")),
    ($floating_names | join("  |  ")),
    (($tiled | length) + ($floating | length) | tostring)
')

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
    args=("${app[@]}" background.drawing=on label.color=$COLOR label="$label" label.drawing=on label.font.size=$SIDE_FONT_SIZE)
  fi
}

center_args_fn() {
  local label="$1"
  if [[ -z "$label" ]]; then
    args=(background.drawing=off label="" label.drawing=off)
  else
    args=("${app[@]}" background.color=$OVERLAY label.color=$WHITE label="$label" label.drawing=on background.drawing=on)
  fi
}

float_args_fn() {
  local label="$1"
  if [[ -z "$label" ]]; then
    args=(background.drawing=off icon.drawing=off label="" label.drawing=off)
  else
    args=(
      "${app[@]}"
      background.border_color=$OVERLAY_LIGHT
      background.padding_left=10
      background.padding_right=10
      icon="$FLOAT_ICON"
      icon.color=$BLACK
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

[[ "$window_count" -gt 0 ]] && nav_drawing=on || nav_drawing=off

# single invocation -> one bar redraw instead of four, avoids the flicker
sketchybar --set running_apps_left "${left_args[@]}" \
           --set running_apps_updater "${center_args[@]}" \
           --set running_apps_right "${right_args[@]}" \
           --set running_apps_float "${float_args[@]}" \
           --set windows label="$window_count $WINDOWS_ICON" \
           --set focus_left drawing=$nav_drawing \
           --set focus_right drawing=$nav_drawing
done
# ponytail: microsecond race between last pending-check and rmdir can drop one
# event; self-heals on the next event, unlike the old 200ms drop window
