#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

ACTIVE=$(paneru query active 2>/dev/null)
FOCUSED_APP=$(echo "$ACTIVE" | jq -r '.focused_app_name')
FOCUSED_ID=$(echo "$ACTIVE" | jq -r '.focused_window_id')
FLOATING=false

if [[ "$FOCUSED_APP" == "null" || -z "$FOCUSED_APP" ]]; then
  # paneru doesn't track focus for floating windows; fall back to yabai, but only
  # trust it for a real window (AXStandardWindow) — otherwise nothing is actually
  # focused (e.g. empty space) and yabai reports a stale/phantom window
  FOCUSED=$(yabai -m query --windows --window 2>/dev/null)
  if [[ "$(echo "$FOCUSED" | jq -r '.subrole')" == "AXStandardWindow" ]]; then
    FOCUSED_APP=$(echo "$FOCUSED" | jq -r '.app')
    FLOATING=true
  else
    FOCUSED_APP=""
  fi
fi

if [[ "$SENDER" = "front_app_switched" ]]; then
  front_app="$INFO"
else
  front_app="$FOCUSED_APP"
fi

# app strip: paneru's tiled window order for this workspace, with the focused
# one wrapped in ‹ ›. If a floating window is focused (not tracked by paneru,
# so it won't match anything above), append it marked at the end instead of
# losing it.
TILED=$(paneru query state | jq -c '.virtual_workspaces[] | select(.active == true) | .windows')
strip=$(echo "$TILED" | jq -r --arg focused_id "$FOCUSED_ID" \
  'map(if (.window_id|tostring) == $focused_id then "‹ " + .app_name + " ›" else .app_name end) | join("  ")')

if [ "$FLOATING" = "true" ]; then
  strip="${strip:+$strip  }‹ 󰅟 $front_app 󰅟 ›"
fi

# icon hidden for now (background.drawing=false in items.sh)
sketchybar --set "$NAME" label="${strip:-$front_app}"

