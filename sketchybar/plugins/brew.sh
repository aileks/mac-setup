#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

sketchybar --set "$NAME" label="Checking for updates..." \
                         icon=󰏖 \
                         label.font="BerkeleyMono Nerd Font:SemiBold:14" \
                         icon.color=$BLUE \
                         label.color=$FG1

COUNT=$(brew outdated 2>/dev/null | wc -l | xargs)

if [ "$COUNT" -eq 0 ]; then
    sketchybar --set "$NAME" label="" \
                             label.font="BerkeleyMono Nerd Font:Black:16" \
                             icon=󰏖 \
                             icon.color=$BLUE \
                             label.color=$GREEN
else
    sketchybar --set "$NAME" label="$COUNT Updates" \
                             icon=󰏖 \
                             label.font="BerkeleyMono Nerd Font:SemiBold:14" \
                             icon.color=$ORANGE \
                             label.color=$YELLOW
fi
