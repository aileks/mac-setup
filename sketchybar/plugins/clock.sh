#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

sketchybar --set "$NAME" icon="􀐫" icon.font="SF Pro:SemiBold:16" \
                         icon.color="$CYAN" label="$(date '+%a  %b %d  %H:%M')"
