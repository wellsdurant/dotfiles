#!/usr/bin/env bash

set -euo pipefail

# Focus on kitty window, searching current space first, then other spaces, or open if not found

# Check dependencies
if ! command -v yabai &>/dev/null; then
    echo "Error: yabai is not installed" >&2
    exit 1
fi

if ! command -v jq &>/dev/null; then
    echo "Error: jq is not installed" >&2
    exit 1
fi

# Get the current space index
current_space=$(yabai -m query --spaces --space | jq '.index')

# Query for kitty windows in the current space
kitty_window=$(yabai -m query --windows --space "$current_space" | \
               jq -r '.[] | select(.app == "kitty") | .id' | \
               head -n 1)

if [[ -n "$kitty_window" ]]; then
    # Focus on the existing kitty window in current space
    yabai -m window --focus "$kitty_window"
else
    # Search for kitty windows in other spaces (sorted by space index)
    kitty_window=$(yabai -m query --windows | \
                   jq -r '.[] | select(.app == "kitty") | "\(.space):\(.id)"' | \
                   sort -n | \
                   cut -d: -f2 | \
                   head -n 1)

    if [[ -n "$kitty_window" ]]; then
        # Focus on the existing kitty window in another space
        yabai -m window --focus "$kitty_window"
    else
        # Open kitty if not found anywhere
        open -a kitty
    fi
fi
