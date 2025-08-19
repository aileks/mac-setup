#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

sketchybar --set "$NAME" icon="" icon.color="$ORANGE" label="$(date '+%a %b %d  %H:%M')"
