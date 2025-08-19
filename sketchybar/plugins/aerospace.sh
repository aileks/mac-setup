#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
WORKSPACES=$(aerospace list-workspaces --all)

for i in {1..10}; do
  WORKSPACE_EXISTS=$(echo "$WORKSPACES" | grep -w "$i")

  if [ -n "$WORKSPACE_EXISTS" ]; then
    if [ "$i" = "$FOCUSED_WORKSPACE" ]; then
      sketchybar --set space.$i icon.color=$GREEN \
                              background.color=$BG1 \
                              background.border_width=1 \
                              background.border_color=$GREEN \
                              drawing=on
    else
      WINDOWS=$(aerospace list-windows --workspace "$i" --format '%{app-name}' 2>/dev/null | wc -l | xargs)
      if [ "$WINDOWS" -gt 0 ]; then
        sketchybar --set space.$i icon.color=$WHITE \
                                background.color=$TRANSPARENT \
                                background.border_width=0 \
                                drawing=on
      else
        sketchybar --set space.$i icon.color=$GREY \
                                background.color=$TRANSPARENT \
                                background.border_width=0 \
                                drawing=on
      fi
    fi
  else
    sketchybar --set space.$i drawing=off
  fi
done
