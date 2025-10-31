#!/usr/bin/env bash

set -euo pipefail

# Focus on Claude window in current space if can-move, else search other spaces, else create new
# After focusing/opening, send hyper+c to the Claude application

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

# Query for Claude windows in the current space that can move
claude_window=$(yabai -m query --windows --space "$current_space" | \
                jq -r '.[] | select(.app == "Claude" and .["can-move"] == true) | .id' | \
                head -n 1)

if [[ -n "$claude_window" ]]; then
    # Focus on the existing Claude window in current space
    yabai -m window --focus "$claude_window"
else
    # Search for Claude windows in other spaces (sorted by space index) that can move
    claude_window=$(yabai -m query --windows | \
                    jq -r '.[] | select(.app == "Claude" and .["can-move"] == true) | "\(.space):\(.id)"' | \
                    sort -n | \
                    cut -d: -f2 | \
                    head -n 1)

    if [[ -n "$claude_window" ]]; then
        # Focus on the existing Claude window in another space
        yabai -m window --focus "$claude_window"
    else
        # Open Claude if not found anywhere (or all windows have can-move: false)
        open -a Claude
        # Wait for the window to appear and be queryable
        for i in {1..10}; do
            sleep 0.2
            if yabai -m query --windows | jq -e '.[] | select(.app == "Claude")' &>/dev/null; then
                break
            fi
        done
    fi
fi

# Send hyper+c to the Claude application using skhd
if command -v skhd &>/dev/null; then
    skhd -k "hyper - c"
fi
