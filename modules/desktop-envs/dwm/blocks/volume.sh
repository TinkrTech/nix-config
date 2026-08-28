#!/usr/bin/env bash

IS_MUTED=$(pamixer --get-mute)
VOLUME=$(pamixer --get-volume)

ICON=
if $IS_MUTED || (( VOLUME == 0 )); then ICON="󰖁"; VOLUME=0
elif (( VOLUME < 25 )); then ICON="󰕿"
elif (( VOLUME < 75 )); then ICON="󰖀"
else ICON="󰕾"
fi
printf "%s(%02d)" "$ICON" "$VOLUME"
