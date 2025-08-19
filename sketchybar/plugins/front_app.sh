#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

FRONT_APP=$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null | head -n1)

if [ -z "$FRONT_APP" ]; then
  FRONT_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
fi

# Final fallback
if [ -z "$FRONT_APP" ]; then
  FRONT_APP="Desktop"
fi

sketchybar --set "$NAME" label="$FRONT_APP" label.color=$GREEN
