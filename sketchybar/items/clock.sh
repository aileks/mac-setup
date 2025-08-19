#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PLUGIN_DIR="$CONFIG_DIR/plugins"

sketchybar --add item clock right \
           --set clock update_freq=10 \
           script="$PLUGIN_DIR/clock.sh" \
           background.color=$BG1
