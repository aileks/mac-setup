#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

COUNT=$(brew outdated 2>/dev/null | wc -l | xargs)

if [ "$COUNT" -eq 0 ]; then
  sketchybar --set "$NAME" label="no updates" \
                          icon.color=$GREEN \
                          label.color=$GREEN
else
  sketchybar --set "$NAME" label="$COUNT updates" \
                          icon.color=$YELLOW \
                          label.color=$YELLOW
fi
