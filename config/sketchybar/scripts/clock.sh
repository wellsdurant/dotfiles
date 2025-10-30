#!/usr/bin/env bash

source $HOME/.config/sketchybar/icons.sh

sketchybar --set $NAME icon="$TIME_ICN" label="$(date '+%H:%M')"
