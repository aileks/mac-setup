#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/icon_map.sh"

FOCUSED_WORKSPACE="$(aerospace list-workspaces --focused)"

for sid in $(aerospace list-workspaces --all); do
    APPS=$(aerospace list-windows --workspace "$sid" --format "%{app-name}")

    if [ -z "$APPS" ] && [ "$sid" != "$FOCUSED_WORKSPACE" ]; then
        sketchybar --set space.$sid drawing=off
    else
        ICONS=""
        while IFS= read -r app; do
            if [ -n "$app" ]; then
                __icon_map "$app"
                ICONS+="$icon_result "
            fi
        done <<< "$APPS"
        ICON=$(echo "$ICONS" | sed 's/ $//')

        if [ "$sid" = "$FOCUSED_WORKSPACE" ] && [ -z "$APPS" ]; then
            ICON="—"
        fi

        if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
            sketchybar --set space.$sid drawing=on \
                                        background.drawing=on \
                                        icon="$sid" \
                                        label="$ICON" \
                                        icon.color=$MAGENTA \
                                        label.color=$FG1
        else
            sketchybar --set space.$sid drawing=on \
                                        background.drawing=off \
                                        icon="$sid" \
                                        label="$ICON" \
                                        icon.color=$BG3 \
                                        label.color=$BG4
        fi
    fi
done
