#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

windows=(
    padding_right=$RIGHT_ITEM_GAP
    click_script="open -a 'Mission Control'"
)

# Mission Control specifics using yabai
for i in {1..10}; do
  space=(
    space="$i"
    icon="$i"
    icon.width=$SPACE_ICON_WIDTH
    icon.align=center
    background.color=$OVERLAY
    background.corner_radius=$SPACE_CORNER_RADIUS
    background.height=$SPACE_BG_HEIGHT
    label.drawing=off
    script="$PLUGIN_DIR/space.sh"
    click_script="$PLUGIN_DIR/focus_space.sh $i"
  )
  sketchybar --add space space."$i" left \
    --set space."$i" "${space[@]}"
done

# to focus on first window if no window is focused
sketchybar --add item space_focus left \
  --set space_focus script="$PLUGIN_DIR/focus_window.sh" \
  --subscribe space_focus space_change

sketchybar --add item spacer_focus left \
  --set spacer_focus background.padding_left=$SPACER_PADDING

sketchybar --add item focus_left left \
  --set focus_left icon="􀁲" icon.color=$ICON_COLOR icon.font.size=18 padding_right=5 \
              click_script="paneru send-cmd window focus west"
sketchybar --add item focus_right left \
  --set focus_right icon="􀁴" icon.color=$ICON_COLOR icon.font.size=18\
              click_script="paneru send-cmd window focus east"

sketchybar --add item focus_apps left \
  --set focus_apps background.padding_right=$SPACER_PADDING

# apps
sketchybar --add item running_apps_left left
sketchybar --add item running_apps_updater left \
  --set running_apps_updater script="$PLUGIN_DIR/list_apps.sh" \
  --subscribe running_apps_updater space_change \
  --subscribe running_apps_updater space_windows_change \
  --subscribe running_apps_updater paneru_manage_change \
  --subscribe running_apps_updater front_app_switched \
  --subscribe running_apps_updater system_woke
sketchybar --add item running_apps_right left

# date/time
sketchybar --add item clock right \
  --set clock icon.drawing=off update_freq=20 script="$PLUGIN_DIR/clock.sh" padding_right="$SPACER_PADDING"

# battery
sketchybar --add item battery right \
  --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" padding_right=$RIGHT_ITEM_GAP \
  --subscribe battery system_woke power_source_change

# volume
sketchybar --add item volume right \
  --set volume label.drawing=off script="$PLUGIN_DIR/volume.sh" icon.width=22 padding_right=$RIGHT_ITEM_GAP \
  --subscribe volume volume_change mouse.clicked

volume_slider=(
    slider.highlight_color=$OVERLAY
    slider.background.height=6
    slider.background.corner_radius=3
    slider.background.color=$OVERLAY
    slider.knob="●"
    slider.knob.drawing=on
    background.color=$BAR_COLOR
    background.padding_left=25
    background.padding_right=25
    background.height=50
    script="$PLUGIN_DIR/volume_slider.sh"
)
sketchybar --add slider volume_slider popup.volume 130 \
  --set volume_slider "${volume_slider[@]}" \
  --subscribe volume_slider mouse.clicked mouse.exited

# window count
sketchybar --add item windows right \
  --set windows label="0 $WINDOWS_ICON" "${windows[@]}"

# floating apps (moved off the left so they don't get clipped by the notch)
sketchybar --add item running_apps_float_spacer right \
  --set running_apps_float_spacer background.padding_right=$SPACER_PADDING
sketchybar --add item running_apps_float right
