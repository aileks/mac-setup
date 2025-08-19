#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PLUGIN_DIR="$CONFIG_DIR/plugins"

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
             --set space.$sid \
             background.color=$BG1 \
             background.corner_radius=8 \
             background.height=24 \
             background.drawing=off \
             icon.font="BerkeleyMono Nerd Font:Medium:14.0" \
             label.font="sketchybar-app-font:Regular:16.0" \
             label="$sid" \
             label.padding_right=6 \
             icon.padding_left=6 \
             drawing=off \
             updates=when_shown \
             click_script="aerospace workspace $sid" \
             script="$PLUGIN_DIR/aerospace.sh" \
             --subscribe space.$sid aerospace_workspace_change front_app_switched
done

sketchybar --add item aerospace_refresh left \
           --set aerospace_refresh drawing=off \
           script="$PLUGIN_DIR/aerospace.sh" \
           updates=on \
           --subscribe aerospace_refresh aerospace_workspace_change front_app_switched
