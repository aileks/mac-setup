#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PLUGIN_DIR="$CONFIG_DIR/plugins"

sketchybar --add item weather right \
    --set weather \
    icon=􀇃 \
    icon.color=$BLUE \
    icon.font="SF Pro:Bold:14" \
    update_freq=1800 \
    background.color=$BG1 \
    script="$PLUGIN_DIR/weather.sh" \
    --subscribe weather system_woke
