#!/usr/bin/env bash
# yabai/paneru can't see Zoom's windows, so route Zoom's frontmost window through
# the Accessibility API (osascript) instead; every other app uses yabai directly.
# Grid padding is computed here (not via yabai's config) so it can't drift from paneru.toml.
# ponytail: assumes a single display (main screen bounds) — this machine only has one.
POS="$1"

FRONT=$(yabai -m query --windows --window | jq -r '.app')

if { [ "$POS" = centerh ] || [ "$POS" = centerv ]; } && [ "$FRONT" != "zoom.us" ]; then
    AXIS="${POS#center}"
    WINDOW=$(yabai -m query --windows --window)
    DISPLAY=$(yabai -m query --displays --display)
    if [ "$AXIS" = "h" ]; then
        X=$(jq -n --argjson w "$WINDOW" --argjson d "$DISPLAY" '(($d.frame.x + ($d.frame.w - $w.frame.w) / 2) | floor)')
        Y=$(echo "$WINDOW" | jq '.frame.y | floor')
    else
        X=$(echo "$WINDOW" | jq '.frame.x | floor')
        Y=$(jq -n --argjson w "$WINDOW" --argjson d "$DISPLAY" '(($d.frame.y + ($d.frame.h - $w.frame.h) / 2) | floor)')
    fi
    yabai -m window --move abs:"$X":"$Y"
    exit 0
fi

# mirrors [padding] in paneru.toml (screen-edge padding, not the inter-window gap)
PAD_TOP=4; PAD_BOTTOM=30; PAD_LEFT=4; PAD_RIGHT=4

read -r SX SY SW SH <<< "$(yabai -m query --displays --display | jq -r '.frame | "\(.x|floor) \(.y|floor) \(.w|floor) \(.h|floor)"')"
UX=$(( SX + PAD_LEFT ))
UY=$(( SY + PAD_TOP ))
UW=$(( SW - PAD_LEFT - PAD_RIGHT ))
UH=$(( SH - PAD_TOP - PAD_BOTTOM ))
CW=$(( UW / 3 ))
CH=$(( UH / 2 ))

case "$POS" in
    topleft)     X=$UX;          Y=$UY;        W=$CW; H=$CH ;;
    topright)    X=$((UX+2*CW)); Y=$UY;        W=$CW; H=$CH ;;
    bottomright) X=$((UX+2*CW)); Y=$((UY+CH)); W=$CW; H=$CH ;;
    bottomleft)  X=$UX;          Y=$((UY+CH)); W=$CW; H=$CH ;;
esac

if [ "$POS" = centerh ] || [ "$POS" = centerv ]; then
    read -r WX WY WW WH <<< "$(osascript -e 'tell application "System Events" to tell process "zoom.us" to get {position, size} of window 1' | tr -d ',')"
    if [ "$POS" = centerh ]; then
        X=$(( UX + (UW - WW) / 2 )); Y=$WY
    else
        X=$WX; Y=$(( UY + (UH - WH) / 2 ))
    fi
    osascript -e "tell application \"System Events\" to tell process \"zoom.us\" to set position of window 1 to {$X, $Y}"
elif [ "$FRONT" = "zoom.us" ]; then
    osascript -e "tell application \"System Events\" to tell process \"zoom.us\" to set position of window 1 to {$X, $Y}"
    osascript -e "tell application \"System Events\" to tell process \"zoom.us\" to set size of window 1 to {$W, $H}"
else
    yabai -m window --resize abs:"$W":"$H" --move abs:"$X":"$Y"
fi
