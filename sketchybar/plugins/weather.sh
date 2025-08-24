#!/usr/bin/env bash

sketchybar --set $NAME label="Fetching Weather..."

IP=$(curl -s https://ipinfo.io/ip)
LOCATION_JSON=$(curl -s https://ipinfo.io/$IP/json)

LOCATION="$(echo $LOCATION_JSON | jq '.city' | tr -d '"')"
REGION="$(echo $LOCATION_JSON | jq '.region' | tr -d '"')"
COUNTRY="$(echo $LOCATION_JSON | jq '.country' | tr -d '"')"

LOCATION_ESCAPED="${LOCATION// /+}+${REGION// /+}"
WEATHER_JSON=$(curl -s "https://wttr.in/$LOCATION_ESCAPED?format=j1")

if [ -z "$WEATHER_JSON" ]; then
    sketchybar --set $NAME label="$LOCATION"
    return
fi

TEMPERATURE=$(echo $WEATHER_JSON | jq '.current_condition[0].temp_F' | tr -d '"')˚F
WEATHER_DESCRIPTION=$(echo $WEATHER_JSON | jq '.current_condition[0].weatherDesc[0].value' | tr -d '"' | sed 's/\(.\{25\}\).*/\1.../')

sketchybar --set $NAME label="$TEMPERATURE • $WEATHER_DESCRIPTION"
