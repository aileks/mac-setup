#!/usr/bin/env bash

aerospace listen workspace-focus-changed workspace-changed | while read -r event; do
  sketchybar --trigger aerospace_workspace_change
done
