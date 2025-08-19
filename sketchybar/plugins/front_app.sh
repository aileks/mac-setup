#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "front_app_switched" ]; then
  APP_NAME="$INFO"
  WINDOW_TITLE=$(aerospace list-windows --focused --format "%{window-title}" 2>/dev/null)

  if [ -z "$WINDOW_TITLE" ] || [ "$WINDOW_TITLE" = "null" ] || [ "$WINDOW_TITLE" = "$APP_NAME" ]; then
    DISPLAY_TEXT="$APP_NAME"
  else
    DISPLAY_TEXT="$APP_NAME - $WINDOW_TITLE"
  fi

  if [ ${#DISPLAY_TEXT} -gt 40 ]; then
    DISPLAY_TEXT="${DISPLAY_TEXT:0:37}..."
  fi

  sketchybar --set "$NAME" label="  $DISPLAY_TEXT" \
                          label.color="$LABEL_COLOR" \
                          background.color="$BACKGROUND_1"
fi
