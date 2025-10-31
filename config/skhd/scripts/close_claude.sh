#!/usr/bin/env bash

set -euo pipefail

# Close Claude window in current space

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

# Query for Claude windows in the current space
claude_window=$(yabai -m query --windows --space "$current_space" | \
                jq -r '.[] | select(.app == "Claude") | .id' | \
                head -n 1)

if [[ -n "$claude_window" ]]; then
    # Close the Claude window
    yabai -m window "$claude_window" --close
fi
