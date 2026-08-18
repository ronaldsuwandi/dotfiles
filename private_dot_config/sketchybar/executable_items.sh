#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

windows=(
    padding_right=$WINDOWS_PADDING_RIGHT
    click_script="open -a 'Mission Control'"
)

# window count
sketchybar --add item windows left \
  --set windows label="0 $WINDOWS_ICON" "${windows[@]}"

# Mission Control specifics using yabai
SPACE_ICONS=({1..10})
for i in "${!SPACE_ICONS[@]}"; do
  space=(
    space="${SPACE_ICONS[i]}"
    icon="${SPACE_ICONS[i]}"
    icon.width=$SPACE_ICON_WIDTH
    icon.align=center
    background.color=$OVERLAY
    background.corner_radius=$SPACE_CORNER_RADIUS
    background.height=$SPACE_BG_HEIGHT
    label.drawing=off
    script="$PLUGIN_DIR/space.sh"
    click_script="$PLUGIN_DIR/focus_space.sh ${SPACE_ICONS[i]}"
  )
  sketchybar --add space space."${SPACE_ICONS[i]}" left \
    --set space."${SPACE_ICONS[i]}" "${space[@]}"
done


# to focus on first window if no window is focused
sketchybar --add item space_focus left \
  --set space_focus script="$PLUGIN_DIR/focus_window.sh" \
  --subscribe space_focus space_change

sketchybar --add item spacer_apps left \
  --set spacer_apps background.padding_left=$SPACER_PADDING

# date/time
sketchybar --add item clock right \
  --set clock icon.drawing=off update_freq=20 script="$PLUGIN_DIR/clock.sh" padding_right="$SPACER_PADDING"

# apps
sketchybar --add item running_apps_left left
sketchybar --add item running_apps_updater left \
  --set running_apps_updater script="$PLUGIN_DIR/list_apps.sh" \
  --subscribe running_apps_updater space_change \
  --subscribe running_apps_updater space_windows_change \
  --subscribe running_apps_updater paneru_manage_change \
  --subscribe running_apps_updater front_app_switched
sketchybar --add item running_apps_right left

# status spacer
sketchybar --add item status_spacer right \
  --set status_spacer background.padding_left=$SPACER_PADDING

# battery
sketchybar --add item battery right \
  --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" padding_right="$SPACER_PADDING"   \
  --subscribe battery system_woke power_source_change

# volume
sketchybar --add item volume right \
  --set volume label.drawing=off script="$PLUGIN_DIR/volume.sh" icon.width=$SPACE_ICON_WIDTH \
  --subscribe volume volume_change

# floating apps (moved off the left so they don't get clipped by the notch)
sketchybar --add item running_apps_float_spacer right \
  --set running_apps_float_spacer background.padding_right=$SPACER_PADDING padding_right="$SPACER_PADDING"
sketchybar --add item running_apps_float right
