#!/usr/bin/env bash

FOCUSED=$(yabai -m query --windows --window 2>/dev/null)
if [[ -z "$FOCUSED" ]]; then
  FIRST=$(yabai -m query --windows --space | \
    jq -r '[.[] | select(.subrole == "AXStandardWindow" and .["is-visible"] == true)] | first | .id // empty')
  [[ -n "$FIRST" ]] && yabai -m window --focus "$FIRST"
fi
