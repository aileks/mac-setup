#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

update_front_app() {
    APP_NAME=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null)

    if [ -z "$APP_NAME" ]; then
        return
    fi

    sketchybar --set "$NAME" icon="" \
                             icon.color="$FG2" \
                             icon.padding_left=8 \
                             label="$APP_NAME" \
                             label.color="$FG1" \
                             label.font="BerkeleyMono Nerd Font:Black:14" \
                             label.padding_right=8 \
                             background.color="$BG1"
}

case "$SENDER" in
    "front_app_switched"|"space_windows_change"|"window_focus"|"forced"|"")
        update_front_app
        ;;
esac
