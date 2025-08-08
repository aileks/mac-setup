#!/usr/bin/env bash

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    # Intentionally empty on right click
    echo ''
  else
    # Focus workspace on left click
    aerospace workspace ${NAME#*.}
  fi
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
esac
