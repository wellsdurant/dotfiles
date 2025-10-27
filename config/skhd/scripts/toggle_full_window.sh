#!/usr/bin/env sh

window_info=$(yabai -m query --windows --window)
is_floating=$(echo "$window_info" | jq -r '."is-floating"')

if [ "$is_floating" = "true" ]; then
    width=$(echo "$window_info" | jq -r '.frame.w')
    if [ "$(echo "$width > 1500" | bc)" -eq 1 ]; then
        yabai -m window --grid 6:6:1:1:4:4
    else
        yabai -m window --grid 1:1:1:1:1:1
    fi
else
    yabai -m window --toggle zoom-fullscreen
fi

