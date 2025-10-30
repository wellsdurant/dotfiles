#!/usr/bin/env bash

source $HOME/.config/sketchybar/icons.sh

# Get memory stats using vm_stat
MEMORY_STATS=$(vm_stat)

# Get page size - try multiple patterns
PAGE_SIZE=$(echo "$MEMORY_STATS" | grep -i "page size" | grep -o '[0-9]\+' | head -1)
# Fallback to 4096 if not found
PAGE_SIZE=${PAGE_SIZE:-4096}

# Extract memory values (in pages) - more flexible patterns
PAGES_FREE=$(echo "$MEMORY_STATS" | grep -i "pages free" | grep -o '[0-9]\+' | head -1)
PAGES_ACTIVE=$(echo "$MEMORY_STATS" | grep -i "pages active" | grep -o '[0-9]\+' | head -1)
PAGES_INACTIVE=$(echo "$MEMORY_STATS" | grep -i "pages inactive" | grep -o '[0-9]\+' | head -1)
PAGES_WIRED=$(echo "$MEMORY_STATS" | grep -i "pages wired" | grep -o '[0-9]\+' | head -1)
PAGES_COMPRESSED=$(echo "$MEMORY_STATS" | grep -i "occupied by compressor" | grep -o '[0-9]\+' | head -1)

# Set defaults if empty
PAGES_ACTIVE=${PAGES_ACTIVE:-0}
PAGES_WIRED=${PAGES_WIRED:-0}
PAGES_COMPRESSED=${PAGES_COMPRESSED:-0}

# echo "PAGE_SIZE: '$PAGE_SIZE'"
# echo "PAGES_ACTIVE: '$PAGES_ACTIVE'"
# echo "PAGES_WIRED: '$PAGES_WIRED'"
# echo "PAGES_COMPRESSED: '$PAGES_COMPRESSED'"

# Calculate memory in GB
USED_MEM=$(echo "scale=1; ($PAGES_ACTIVE + $PAGES_WIRED + $PAGES_COMPRESSED) * $PAGE_SIZE / 1024 / 1024 / 1024" | bc)
TOTAL_MEM=$(sysctl -n hw.memsize | awk '{printf "%.1f", $1/1024/1024/1024}')

# Calculate percentage
PERCENTAGE=$(printf "%.0f" $(echo "scale=2; ($USED_MEM / $TOTAL_MEM) * 100" | bc))

# echo "USED: ${USED_MEM}GB / ${TOTAL_MEM}GB"
# echo "PERCENTAGE: $PERCENTAGE%"

sketchybar --set $NAME icon="$MEMORY_ICN" label="${PERCENTAGE}%"


