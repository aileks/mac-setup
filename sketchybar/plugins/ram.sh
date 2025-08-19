#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

MEMORY_PRESSURE=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print $5}' | sed 's/%//')
MEMORY_USED=$((100 - MEMORY_PRESSURE))

if [ -z "$MEMORY_USED" ]; then
  VM_STAT=$(vm_stat)
  PAGES_FREE=$(echo "$VM_STAT" | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
  PAGES_ACTIVE=$(echo "$VM_STAT" | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
  PAGES_INACTIVE=$(echo "$VM_STAT" | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
  PAGES_SPECULATIVE=$(echo "$VM_STAT" | grep "Pages speculative" | awk '{print $3}' | sed 's/\.//')
  PAGES_WIRED=$(echo "$VM_STAT" | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')

  PAGES_TOTAL=$((PAGES_FREE + PAGES_ACTIVE + PAGES_INACTIVE + PAGES_SPECULATIVE + PAGES_WIRED))
  PAGES_USED=$((PAGES_ACTIVE + PAGES_INACTIVE + PAGES_SPECULATIVE + PAGES_WIRED))

  if [ "$PAGES_TOTAL" -gt 0 ]; then
    MEMORY_USED=$((PAGES_USED * 100 / PAGES_TOTAL))
  else
    MEMORY_USED=0
  fi
fi

if [ "$MEMORY_USED" -lt 60 ]; then
  COLOR=$GREEN
elif [ "$MEMORY_USED" -lt 80 ]; then
  COLOR=$YELLOW
else
  COLOR=$RED
fi

sketchybar --set "$NAME" label="${MEMORY_USED}%" \
                        icon.color="$COLOR" \
                        label.color="$COLOR"
