#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PLUGIN_DIR="$CONFIG_DIR/plugins"

sketchybar --add item ram right \
           --set ram update_freq=2 \
           script="$PLUGIN_DIR/ram.sh" \
           background.color=$BG1
