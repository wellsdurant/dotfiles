#!/usr/bin/env bash

set -euo pipefail

# Focus on Brave Browser window, searching current space first, then other spaces, or open if not found

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

# Query for Brave Browser windows in the current space
brave_window=$(yabai -m query --windows --space "$current_space" | \
               jq -r '.[] | select(.app == "Brave Browser") | .id' | \
               head -n 1)

if [[ -n "$brave_window" ]]; then
    # Focus on the existing Brave Browser window in current space
    yabai -m window --focus "$brave_window"
else
    # Search for Brave Browser windows in other spaces (sorted by space index)
    brave_window=$(yabai -m query --windows | \
                   jq -r '.[] | select(.app == "Brave Browser") | "\(.space):\(.id)"' | \
                   sort -n | \
                   cut -d: -f2 | \
                   head -n 1)

    if [[ -n "$brave_window" ]]; then
        # Focus on the existing Brave Browser window in another space
        yabai -m window --focus "$brave_window"
    else
        # Open Brave Browser if not found anywhere
        open -a "Brave Browser"
    fi
fi
