#!/usr/bin/env bash

source $HOME/.config/sketchybar/icons.sh

# Get CPU usage using top (sample 2 times over 1 second for accuracy)
CPU_USAGE=$(top -l 2 -n 0 -F -R -o cpu | grep "CPU usage" | tail -1 | awk '{print $3}' | sed 's/%//')

# Fallback to 0 if empty
CPU_USAGE=${CPU_USAGE:-0}

# Convert to integer
CPU_PERCENTAGE=$(printf "%.0f" "$CPU_USAGE")

sketchybar --set $NAME icon="$CPU_ICN" label="${CPU_PERCENTAGE}%"
