#!/usr/bin/env bash

source $HOME/.config/sketchybar/icons.sh

# Check if Do Not Disturb/Focus mode is enabled by parsing the JSON
DND_ACTIVE=$(python3 -c "
import json
import sys

try:
    with open('$HOME/Library/DoNotDisturb/DB/Assertions.json', 'r') as f:
        data = json.load(f)

    # Check if there are any active assertion records
    # When DND/Focus is active, storeAssertionRecords will be present
    if 'data' in data and len(data['data']) > 0:
        for entry in data['data']:
            if 'storeAssertionRecords' in entry and len(entry['storeAssertionRecords']) > 0:
                print('active')
                sys.exit(0)
except Exception:
    pass

print('')
" 2>/dev/null)

if [ "$DND_ACTIVE" = "active" ]; then
    # DND/Focus mode is enabled
    sketchybar --set $NAME icon="$DND_ICN" icon.color=0xffffffff drawing=on
else
    # DND/Focus mode is disabled - hide the item
    sketchybar --set $NAME icon="$NON_DND_ICN" icon.color=0xffffffff drawing=on
fi
