#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')

if [ -z "$CPU_USAGE" ]; then
    CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
fi

CPU_USAGE=$(printf "%.0f" "$CPU_USAGE")

if [ "$CPU_USAGE" -gt 80 ]; then
    COLOR=$RED
elif [ "$CPU_USAGE" -gt 60 ]; then
    COLOR=$YELLOW
else
    COLOR=$GREEN
fi

sketchybar --set "$NAME" label="${CPU_USAGE}%" icon="󰻠" icon.color="$COLOR"
