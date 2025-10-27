#!/usr/bin/env bash

# Get the current input source name (e.g. "ABC", "Pinyin", "Japanese")
# SOURCE=$(/usr/libexec/PlistBuddy -c "Print AppleSelectedInputSources" ~/Library/Preferences/com.apple.HIToolbox.plist \
#     | grep 'KeyboardLayout Name' \
#     | awk -F'= ' '{print $2}' \
#     | tr -d ';')

SOURCE=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources \
    | grep -w "KeyboardLayout Name" | sed -E 's/^.+ = "?([^"]+)"?;$/\1/'   )

# Fallback: if empty, use ISO code
if [ "$SOURCE" != "ABC" ]; then
  SOURCE="注"
fi

sketchybar --set $NAME label=$SOURCE
