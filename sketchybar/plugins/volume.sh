#!/usr/bin/env bash

source "$CONFIG_DIR/icons.sh"

volume_change() {
  case $INFO in
    [6-9][0-9]|100) ICON=$VOLUME_100 ;;
    [3-5][0-9]) ICON=$VOLUME_66 ;;
    [1-2][0-9]) ICON=$VOLUME_33 ;;
    [1-9]) ICON=$VOLUME_10 ;;
    *) ICON=$VOLUME_0 ;;
  esac

  sketchybar --set volume_icon label=$ICON \
             --set "$NAME" slider.percentage="$INFO"

  sketchybar --animate tanh 30 --set "$NAME" slider.width=100

  sleep 2

  # Check if the volume was changed again while sleeping
  FINAL_PERCENTAGE=$(sketchybar --query "$NAME" | jq -r ".slider.percentage")
  if [ "$FINAL_PERCENTAGE" -eq "$INFO" ]; then
    sketchybar --animate tanh 30 --set "$NAME" slider.width=0
  fi
}

mouse_clicked() {
  osascript -e "set volume output volume $PERCENTAGE"
}

case "$SENDER" in
  "volume_change") volume_change ;;
  "mouse.clicked") mouse_clicked ;;
esac
