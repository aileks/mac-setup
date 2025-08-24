#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PLUGIN_DIR="$CONFIG_DIR/plugins"

sketchybar --add item brew right \
  --set brew update_freq=7200 \
  script="$PLUGIN_DIR/brew.sh" \
  background.color=$BG1
