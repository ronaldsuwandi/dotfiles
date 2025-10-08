#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

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
    click_script="osascript -e \"tell application \\\"System Events\\\" to key code ${KEY_CODES[i]} using control down\""
  )
  sketchybar --add space space."$sid" left --set space."$sid" "${space[@]}"
done

# frontapp
COLOR="$WHITE"
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
  --set running_apps_updater script="plugins/list_apps.sh" \
  --subscribe running_apps_updater space_change \
  --subscribe running_apps_updater space_windows_change \


# front app
sketchybar --add item front_app center \
	--set front_app "${front_app_setting[@]}" \
	--subscribe front_app front_app_switched
# sketchybar --set running_apps_updater script="plugins/front_app.sh"
# 	--subscribe running_apps_updater front_app_switched

# right spacer
sketchybar --add item right_spacer right \
  --set right_spacer background.padding_right=40
