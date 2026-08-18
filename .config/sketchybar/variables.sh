#!/usr/bin/env bash

# Color Palette
BLACK=0xff1e1e2e
WHITE=0xffffffff
BAR_COLOR=0xFFAAD7FF
RED=0xffff3b30 # low-battery tint, mimics macOS

OVERLAY_LIGHT=0x40000000   # space bg / float pill border
OVERLAY=0xC15079A2   # focused-app pill bg

# General bar colors
ICON_COLOR=$BLACK  # Color of all icons
LABEL_COLOR=$BLACK # Color of all labels

PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

FONT="SF Pro"
FONT_WEIGHT="Regular"
FONT_SIZE=13

HEIGHT=30

# Bar geometry
BAR_PADDING_LEFT=20
BAR_PADDING_RIGHT=10
BAR_BLUR_RADIUS=20
BAR_NOTCH_WIDTH=200

# Space icons
SPACE_ICON_WIDTH=28
SPACE_BG_HEIGHT=26
SPACE_CORNER_RADIUS=200

# Running-app pills
APP_BG_HEIGHT=24
APP_BORDER_WIDTH=2
APP_CORNER_RADIUS=100

# Spacers
SPACER_PADDING=10
WINDOWS_PADDING_RIGHT=20

# Glyphs
WINDOWS_ICON="􀐅"
FLOAT_ICON="􀇂"
