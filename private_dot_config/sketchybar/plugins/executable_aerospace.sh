#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

if [ ! -z "${FOCUSED_WORKSPACE}" ]; then
    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
        sketchybar --set $NAME \
            label.background.color="$RED" \
            label.color="$BLACK"
            # --set window_count label="⊞ $(aerospace list-windows --workspace focused --count)"
            # --remove /window.*/

        # windows=()
        # while IFS= read -r line; do
        #     windows+=("$line")
        # done < <(aerospace list-windows --workspace focused --format "%{window-id}|||%{app-name}")

        # # Print the array to verify
        # for window in "${windows[@]}"; do
        #     echo "w=$window"
        # done

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
    else
        sketchybar --set $NAME \
            label.color="$COMMENT" \
            label.background.color="$BAR_COLOR" \
    fi
fi
