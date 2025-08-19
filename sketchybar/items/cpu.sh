#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PLUGIN_DIR="$CONFIG_DIR/plugins"

sketchybar --add item cpu right \
           --set cpu update_freq=2 \
           script="$PLUGIN_DIR/cpu.sh" \
           background.color=$BG1
