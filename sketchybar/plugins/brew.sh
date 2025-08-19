#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

sketchybar --set "$NAME" label="Checking for updates..." \
                        icon.color=$BLUE \
                        label.color=$WHITE

COUNT=$(brew outdated 2>/dev/null | wc -l | xargs)

if [ "$COUNT" -eq 0 ]; then
  sketchybar --set "$NAME" label="" \
                          icon.color=$BLUE \
                          label.color=$GREEN
else
  sketchybar --set "$NAME" label="$COUNT Updates" \
                          icon.color=$ORANGE \
                          label.color=$YELLOW
fi
