#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

windows=(
    padding_right=20
    click_script="open -a 'Mission Control'"
)

# window count
sketchybar --add item windows left \
  --set windows label="0 󰖲" "${windows[@]}"

# Mission Control specifics using yabai
SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
KEY_CODES=("18" "19" "20" "21" "23" "22" "26" "28" "25" "29")
for i in "${!SPACE_ICONS[@]}"; do
  sid="$(($i+1))"
  space=(
    space="$sid"
    icon="${SPACE_ICONS[i]}"
    icon.padding_left=10
    icon.padding_right=10
    background.color=0x40ffffff
    background.corner_radius=5
    background.height=20
    label.drawing=off
    script="$PLUGIN_DIR/space.sh"
    #old using system event to push ctrl+number
    #click_script="osascript -e \"tell application \\\"System Events\\\" to key code ${KEY_CODES[i]} using control down\""
    click_script="sketchybar --set /space\../ background.drawing=off --set space.${SPACE_ICONS[i]} background.drawing=on; yabai -m space --focus ${SPACE_ICONS[i]}"
  )
  sketchybar --add space space."$sid" left \
    --set space."$sid" "${space[@]}"
done

space_layout=(
  label=""
  label.padding_left=8
  label.padding_right=8
  label.font.size=22
  script="$PLUGIN_DIR/space_layout.sh"
  click_script="$PLUGIN_DIR/space_layout_toggle.sh"
)
sketchybar --add item space_layout left \
  --set space_layout "${space_layout[@]}"\
  --subscribe space_layout space_change \
  --subscribe space_layout yabai_layout_change

# to focus on first window if no window is focused
sketchybar --add item space_focus left \
  --set space_focus script="$PLUGIN_DIR/focus_window.sh" \
  --subscribe space_focus space_change

# frontapp
front_app_setting=(
  script="$PLUGIN_DIR/front_app.sh"
	icon.drawing=off
	background.drawing=true
	background.height=20
	background.image.scale=0.8
	associated_display=active
	label.padding_left=30
)


# apps
sketchybar --add item running_apps_updater right \
  --set running_apps_updater script="$PLUGIN_DIR/list_apps.sh" \
  --subscribe running_apps_updater space_change \
  --subscribe running_apps_updater space_windows_change


# front app
sketchybar --add item front_app center \
	--set front_app "${front_app_setting[@]}" \
	--subscribe front_app front_app_switched \
	--subscribe front_app yabai_zoom_change \
	--subscribe front_app space_change

window_zoom=(
  label="󰊓"
  label.font.size=22
  label.color=$ORANGE
  label.padding_left=12
  label.padding_right=6
  drawing=off
  click_script="$PLUGIN_DIR/window_zoom_float_click.sh"
)
sketchybar --add item window_zoom_float center \
  --set window_zoom_float "${window_zoom[@]}"
# sketchybar --set running_apps_updater script="plugins/front_app.sh"
# 	--subscribe running_apps_updater front_app_switched

# right spacer
sketchybar --add item right_spacer right \
  --set right_spacer background.padding_right=40
