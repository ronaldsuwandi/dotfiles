#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

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
)

if [[ "$SENDER" = "front_app_switched" ]]; then
  front_app="$INFO"
  ZOOMED=$(yabai -m query --windows --space 2>/dev/null \
    | jq -r 'map(select(.["has-focus"] == true)) | .[0]["has-fullscreen-zoom"]' 2>/dev/null)
  ZOOM_SUFFIX=$([ "$ZOOMED" = "true" ] && echo " Z" || echo "")
  sketchybar --set "$NAME" background.image="app.${front_app}" label="${front_app}${ZOOM_SUFFIX}"
elif [[ "$SENDER" = "yabai_zoom_change" ]]; then
  FOCUSED=$(yabai -m query --windows --space 2>/dev/null \
    | jq -c 'map(select(.["has-focus"] == true)) | .[0]' 2>/dev/null)
  front_app=$(echo "$FOCUSED" | jq -r '.app')
  ZOOMED=$(echo "$FOCUSED" | jq -r '.["has-fullscreen-zoom"]')
  ZOOM_SUFFIX=$([ "$ZOOMED" = "true" ] && echo " Z" || echo "")
  sketchybar --set "$NAME" background.image="app.${front_app}" label="${front_app}${ZOOM_SUFFIX}"
fi
