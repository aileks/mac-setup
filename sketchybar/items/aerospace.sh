#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
PLUGIN_DIR="$CONFIG_DIR/plugins"

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
             --set space.$sid \
                   background.color=$BG1 \
                   background.corner_radius=8 \
                   background.height=32 \
                   background.drawing=off \
                   label="$sid" \
                   label.padding_right=6 \
                   icon.padding_left=6 \
                   drawing=off \
                   click_script="aerospace workspace $sid"
done

sketchybar --add item aerospace_controller left \
           --set aerospace_controller \
                 drawing=off \
                 script="$PLUGIN_DIR/aerospace.sh" \
           --subscribe aerospace_controller aerospace_workspace_change front_app_switched space_windows_change
