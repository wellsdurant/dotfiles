#!/usr/bin/env bash

# Shared styling configuration for sketchybar items

# Common background styling for right-side items with borders
ITEM_BG_BORDER_STYLE="
    background.border_color=0xff939ab7
    background.border_width=1
    background.color=0x44000000
    background.corner_radius=6
    background.height=24
    background.padding_left=0
    background.padding_right=0
"

# Add a right-side item with border styling
# Usage: add_item_with_border <name> <update_freq> <script> [additional_options]
add_item_with_border() {
    local name=$1
    local update_freq=$2
    local script=$3
    shift 3
    local additional_options="$@"

    sketchybar --add item "$name" right \
               --set "$name" update_freq="$update_freq" \
                             script="$SCRIPT_DIR/$script" \
                             $ITEM_BG_BORDER_STYLE \
                             $additional_options
}

# Subscribe an item to system events
# Usage: subscribe_item <name> <events...>
subscribe_item() {
    local name=$1
    shift
    sketchybar --subscribe "$name" "$@"
}
