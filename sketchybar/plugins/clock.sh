#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

DATETIME=$(date "+%a %b %d  %I:%M %p")

sketchybar --set "$NAME" label="$DATETIME" \
                        icon.color=$ORANGE \
                        label.color=$WHITE
