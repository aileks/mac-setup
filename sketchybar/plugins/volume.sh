#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case "$VOLUME" in
    [6-9][0-9]|100) ICON="􀊧"
    ;;
    [3-5][0-9]) ICON="􀊥"
    ;;
    [1-9]|[1-2][0-9]) ICON="􀊡"
    ;;
    *) ICON="􀊣"
    ;;
  esac

  if [ "$VOLUME" -eq 0 ]; then
    ICON_COLOR=$GREY
  elif [ "$VOLUME" -lt 60 ]; then
    ICON_COLOR=$MAGENTA
  elif [ "$VOLUME" -lt 80 ]; then
    ICON_COLOR=$YELLOW
  else
    ICON_COLOR=$RED
  fi

  sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%" icon.color="$ICON_COLOR"
fi
