#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

MEMORY_PRESSURE=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print $5}' | sed 's/%//')

if [ -z "$MEMORY_PRESSURE" ]; then
    VM_STAT=$(vm_stat)

    FREE_PAGES=$(echo "$VM_STAT" | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
    ACTIVE_PAGES=$(echo "$VM_STAT" | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
    INACTIVE_PAGES=$(echo "$VM_STAT" | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
    WIRED_PAGES=$(echo "$VM_STAT" | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')
    COMPRESSED_PAGES=$(echo "$VM_STAT" | grep "Pages stored in compressor" | awk '{print $5}' | sed 's/\.//')

    TOTAL_PAGES=$((FREE_PAGES + ACTIVE_PAGES + INACTIVE_PAGES + WIRED_PAGES + COMPRESSED_PAGES))
    USED_PAGES=$((ACTIVE_PAGES + INACTIVE_PAGES + WIRED_PAGES + COMPRESSED_PAGES))

    if [ "$TOTAL_PAGES" -gt 0 ]; then
        MEMORY_USAGE=$((USED_PAGES * 100 / TOTAL_PAGES))
    else
        MEMORY_USAGE=0
    fi
else
    MEMORY_USAGE=$((100 - MEMORY_PRESSURE))
fi

if [ "$MEMORY_USAGE" -gt 80 ]; then
    COLOR=$RED
elif [ "$MEMORY_USAGE" -gt 60 ]; then
    COLOR=$YELLOW
else
    COLOR=$GREEN
fi

sketchybar --set "$NAME" label="${MEMORY_USAGE}%" icon="󰍛" icon.color="$COLOR"
