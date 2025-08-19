#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PLUGIN_DIR="$CONFIG_DIR/plugins"

sketchybar --add item volume right \
           --set volume script="$PLUGIN_DIR/volume.sh" \
           background.color=$BG1 \
           --subscribe volume volume_change
