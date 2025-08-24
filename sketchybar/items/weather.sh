#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PLUGIN_DIR="$CONFIG_DIR/plugins"

sketchybar --add item weather right \
    --set weather \
    icon= \
    icon.color=$BLUE \
    icon.font="AdwaitaMono Nerd Font Propo:Bold:14" \
    label.font="AdwaitaMono Nerd Font Propo:Bold:14" \
    update_freq=1800 \
    script="$PLUGIN_DIR/weather.sh" \
    --subscribe weather system_woke
