#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

if [ -x "/opt/homebrew/bin/brew" ]; then
  BREW_EXEC="/opt/homebrew/bin/brew"
elif [ -x "/usr/local/bin/brew" ]; then
  BREW_EXEC="/usr/local/bin/brew"
else
  sketchybar --set $NAME label="brew not found" icon.color=$RED
  exit 1
fi

sketchybar --set $NAME icon.color=$YELLOW label="Checking..."

(
  COUNT=$($BREW_EXEC outdated | wc -l | tr -d ' ')

  # Update label and color based on count
  if [ "$COUNT" -eq 0 ]; then
    sketchybar --set $NAME label="No Updates" icon.color=$GREEN
  else
    sketchybar --set $NAME label="$COUNT Updates" icon.color=$ORANGE
  fi
) &
