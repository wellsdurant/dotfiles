#!/usr/bin/env bash

set -euo pipefail

# Focus on Obsidian window, searching current space first, then other spaces, or open if not found

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

# Query for Obsidian windows in the current space
obsidian_window=$(yabai -m query --windows --space "$current_space" | \
                  jq -r '.[] | select(.app == "Obsidian") | .id' | \
                  head -n 1)

if [[ -n "$obsidian_window" ]]; then
    # Focus on the existing Obsidian window in current space
    yabai -m window --focus "$obsidian_window"
else
    # Search for Obsidian windows in other spaces (sorted by space index)
    obsidian_window=$(yabai -m query --windows | \
                      jq -r '.[] | select(.app == "Obsidian") | "\(.space):\(.id)"' | \
                      sort -n | \
                      cut -d: -f2 | \
                      head -n 1)

    if [[ -n "$obsidian_window" ]]; then
        # Focus on the existing Obsidian window in another space
        yabai -m window --focus "$obsidian_window"
    else
        # Open Obsidian if not found anywhere
        open -a Obsidian
    fi
fi
