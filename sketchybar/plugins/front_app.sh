#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "front_app_switched" ]; then
    APP_NAME="$INFO"
else
    APP_NAME=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null)
fi

# Exit if no app name
if [ -z "$APP_NAME" ]; then
    sketchybar --set "$NAME" drawing=off
    return
fi

sketchybar --set "$NAME" icon="" \
                         icon.color="$FG2" \
                         icon.padding_left=8 \
                         label="$APP_NAME" \
                         label.color="$FG1" \
                         label.font="BerkeleyMono Nerd Font:Bold:14" \
                         label.padding_right=8 \
                         background.color="$BG1" \
                         drawing=on
