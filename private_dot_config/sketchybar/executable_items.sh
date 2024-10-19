#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

sketchybar --add event aerospace_workspace_change

# aerospace workspace
for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        label.padding_left=20 \
		label.padding_right=20 \
		icon.padding_left=0 \
		icon.padding_right=0 \
		background.padding_left=0 \
		background.padding_right=0 \
		background.color=$BAR_COLOR \
        label="$sid" \
        click_script="aerospace workspace $sid" \
        script="$CONFIG_DIR/plugins/aerospace.sh $sid"
done

# frontapp
COLOR="$WHITE"
front_app_setting=(
    script="$PLUGIN_DIR/front_app.sh"
	icon.drawing=off
	background.height=26
	background.padding_left=10
	background.padding_right=10
	background.border_width="$BORDER_WIDTH"
	background.border_color="$COLOR"
	background.corner_radius="$CORNER_RADIUS"
	background.color="$BAR_COLOR"
	label.color="$COLOR"
	label.padding_left=10
	label.padding_right=10
	associated_display=active
)

# front app
sketchybar --add item front_app center \
	--set front_app "${front_app_setting[@]}" \
	--subscribe front_app front_app_switched

sketchybar --set "space.$(aerospace list-workspaces --focused)" \
    label.background.color=$RED \
    label.color="$BLACK"

# window_count=(
#     label.padding_left=20
#     label.padding_right=20
#     label="⊞ $(aerospace list-windows --workspace focused --count)"
#     label.background.height=$HEIGHT
#     script="$CONFIG_DIR/plugins/aerospace.sh $sid"
# )
# sketchybar --add item window_count right \
#     --set window_count "${window_count[@]}"

# aerospace windows
# windows=()
# while IFS= read -r line; do
#   windows+=("$line")
# done < <(aerospace list-windows --workspace focused --format "%{window-id}|||%{app-name}")


# for (( i=${#windows[@]}-1; i>=0; i-- )); do
#     id=${windows[i]%|||*}
#     name=${windows[i]#*|||}
#     echo "window name=${name}"
#     window=(
#         label.padding_left=20
#         label.padding_right=20
#         label="$name"
#         label.background.height=$HEIGHT
#         click_script="aerospace focus --window-id $id"
#         script="$CONFIG_DIR/plugins/aerospace.sh $sid"
#     )
#     sketchybar --add item window.${name// /-} right \
#         --set window.${name// /-} "${window[@]}"
# done
# focused=$(aerospace list-windows --focused --format "%{app-name}")
# sketchybar --set "window.${focused// /-}" label.background.color=$RED
