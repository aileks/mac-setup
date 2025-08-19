#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

update_front_app() {
    APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')

    WINDOW_TITLE=""
    if [ "$APP_NAME" = "Safari" ]; then
        WINDOW_TITLE=$(osascript -e 'tell application "Safari" to get name of front document' 2>/dev/null)
    elif [ "$APP_NAME" = "Google Chrome" ]; then
        WINDOW_TITLE=$(osascript -e 'tell application "Google Chrome" to get title of active tab of front window' 2>/dev/null)
    elif [ "$APP_NAME" = "Firefox" ]; then
        WINDOW_TITLE=$(osascript -e 'tell application "Firefox" to get name of front document' 2>/dev/null)
    else
        WINDOW_TITLE=$(aerospace list-windows --focused --format "%{window-title}" 2>/dev/null)
    fi

    if [ -z "$WINDOW_TITLE" ] || [ "$WINDOW_TITLE" = "null" ] || [ "$WINDOW_TITLE" = "$APP_NAME" ]; then
        DISPLAY_TEXT="$APP_NAME"
    else
        DISPLAY_TEXT="$APP_NAME - $WINDOW_TITLE"
    fi

    if [ ${#DISPLAY_TEXT} -gt 40 ]; then
        DISPLAY_TEXT="${DISPLAY_TEXT:0:37}..."
    fi

    sketchybar --set "$NAME" icon="" \
                             icon.color="$MAGENTA" \
                             label="$DISPLAY_TEXT" \
                             label.color="$LABEL_COLOR" \
                             background.color="$BACKGROUND_1"
}

case "$SENDER" in
  "front_app_switched"|"space_windows_change"|"window_focus"|"")
    update_front_app
    ;;
esac
