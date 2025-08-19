#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')

CPU_INT=${CPU_USAGE%.*}

if [ "$CPU_INT" -lt 30 ]; then
  COLOR=$GREEN
elif [ "$CPU_INT" -lt 70 ]; then
  COLOR=$YELLOW
else
  COLOR=$RED
fi

sketchybar --set "$NAME" label="${CPU_USAGE}%" \
                        icon.color="$COLOR" \
                        label.color="$COLOR"
