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
SPACE_ICONS=({1..10})
for i in "${!SPACE_ICONS[@]}"; do
  space=(
    space="${SPACE_ICONS[i]}"
    icon="${SPACE_ICONS[i]}"
    icon.padding_left=10
    icon.padding_right=10
    background.color=0x40ffffff
    background.corner_radius=5
    background.height=20
    label.drawing=off
    script="$PLUGIN_DIR/space.sh"
    click_script="sketchybar --set /space\../ background.drawing=off --set space.${SPACE_ICONS[i]} background.drawing=on; yabai -m space --focus ${SPACE_ICONS[i]}"
  )
  sketchybar --add space space."${SPACE_ICONS[i]}" left \
    --set space."${SPACE_ICONS[i]}" "${space[@]}"
done

# to focus on first window if no window is focused
sketchybar --add item space_focus left \
  --set space_focus script="$PLUGIN_DIR/focus_window.sh" \
  --subscribe space_focus space_change

# apps
sketchybar --add item running_apps_left center
sketchybar --add item running_apps_updater center \
  --set running_apps_updater script="$PLUGIN_DIR/list_apps.sh" \
  --subscribe running_apps_updater space_change \
  --subscribe running_apps_updater space_windows_change \
  --subscribe running_apps_updater paneru_manage_change \
  --subscribe running_apps_updater front_app_switched
sketchybar --add item running_apps_right center
sketchybar --add item running_apps_float right

# right spacer
sketchybar --add item right_spacer right \
  --set right_spacer background.padding_right=40
