#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

VOLUME=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

if [ "$MUTED" = "true" ]; then
  ICON="󰖁"
  COLOR=$GREY
  LABEL="muted"
else
  if [ "$VOLUME" -eq 0 ]; then
    ICON="󰕿"
  elif [ "$VOLUME" -lt 30 ]; then
    ICON="󰖀"
  elif [ "$VOLUME" -lt 70 ]; then
    ICON="󰕾"
  else
    ICON="󰕾"
  fi
  COLOR=$BLUE
  LABEL="${VOLUME}%"
fi

sketchybar --set "$NAME" icon="$ICON" \
                        icon.color="$COLOR" \
                        label="$LABEL" \
                        label.color="$COLOR"
