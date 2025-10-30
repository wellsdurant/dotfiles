#!/usr/bin/env bash

source $HOME/.config/sketchybar/icons.sh

# Temp file to store previous values
TEMP_FILE="/tmp/sketchybar_network_$USER"

# Get the primary network interface (usually en0 for Wi-Fi or en1 for Ethernet)
INTERFACE=$(route -n get default 2>/dev/null | grep interface | awk '{print $2}')

# Fallback to en0 if no default route
if [ -z "$INTERFACE" ]; then
    INTERFACE="en0"
fi

# Get current network stats using netstat
STATS=$(netstat -ibn | grep -e "^$INTERFACE" | awk '{print $7, $10}' | head -1)
RX_BYTES=$(echo $STATS | awk '{print $1}')
TX_BYTES=$(echo $STATS | awk '{print $2}')

# Default to 0 if empty
RX_BYTES=${RX_BYTES:-0}
TX_BYTES=${TX_BYTES:-0}

# Read previous values
if [ -f "$TEMP_FILE" ]; then
    PREV_VALUES=$(cat "$TEMP_FILE")
    PREV_RX=$(echo $PREV_VALUES | awk '{print $1}')
    PREV_TX=$(echo $PREV_VALUES | awk '{print $2}')
    PREV_TIME=$(echo $PREV_VALUES | awk '{print $3}')
else
    PREV_RX=0
    PREV_TX=0
    PREV_TIME=$(date +%s)
fi

# Current time
CURRENT_TIME=$(date +%s)
TIME_DIFF=$((CURRENT_TIME - PREV_TIME))

# Avoid division by zero
if [ $TIME_DIFF -eq 0 ]; then
    TIME_DIFF=1
fi

# Calculate speeds (bytes per second)
RX_SPEED=$(( (RX_BYTES - PREV_RX) / TIME_DIFF ))
TX_SPEED=$(( (TX_BYTES - PREV_TX) / TIME_DIFF ))

# Ensure non-negative values
[ $RX_SPEED -lt 0 ] && RX_SPEED=0
[ $TX_SPEED -lt 0 ] && TX_SPEED=0

# Format both speeds in MB/s with 3-digit whole numbers only
SPEEDS=$(echo "$TX_SPEED $RX_SPEED" | awk '{
    up = $1
    down = $2

    # Convert to MB/s and round to whole numbers
    up_mb = int(up / 1048576 + 0.5)
    down_mb = int(down / 1048576 + 0.5)

    # Format with 3 digits and unit
    up_str = sprintf("%3dMB/s", up_mb)
    down_str = sprintf("%3dMB/s", down_mb)

    printf("%s %s", up_str, down_str)
}')

UP_SPEED=$(echo "$SPEEDS" | awk '{print $1}')
DOWN_SPEED=$(echo "$SPEEDS" | awk '{print $2}')

# Save current values for next iteration
echo "$RX_BYTES $TX_BYTES $CURRENT_TIME" > "$TEMP_FILE"

# Update all items
sketchybar --set network.prefix   label="⇅"   \
           --set network.up   label="$UP_SPEED"   \
           --set network.down label="$DOWN_SPEED"
