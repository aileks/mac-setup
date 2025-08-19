#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

COUNT=$(brew outdated 2>/dev/null | wc -l | xargs)

if [ "$COUNT" -eq 0 ]; then
  sketchybar --set "$NAME" label="" \
                          icon.color=$BLUE \
                          label.color=$GREEN
else
  sketchybar --set "$NAME" label="$COUNT Updates" \
                          icon.color=$YELLOW \
                          label.color=$YELLOW
fi
