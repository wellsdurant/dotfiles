#!/usr/bin/env bash

source $HOME/.config/sketchybar/icons.sh

sketchybar --set $NAME icon="$DATE_ICN" label="$(date '+%b %d, %Y')"
