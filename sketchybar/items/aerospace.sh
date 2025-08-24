#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
PLUGIN_DIR="$CONFIG_DIR/plugins"

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
             --set space.$sid \
             background.color=$BG1 \
             label.padding_left=4 \
             label.padding_right=8 \
             icon.padding_left=8 \
             icon.padding_right=4 \
             drawing=off \
             click_script="aerospace workspace $sid"
done

sketchybar --add item aerospace_controller left \
           --set aerospace_controller drawing=off \
           script="$PLUGIN_DIR/aerospace.sh" \
           --subscribe aerospace_controller aerospace_workspace_change front_app_switched space_windows_change
