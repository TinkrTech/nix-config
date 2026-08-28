#!/usr/bin/env bash

ord() {
	printf "%d" "\"$1"
}
# ICON=$(printf "<U+0%X>" $(( ((PERCENT - 5)/10) + 0xF007A )) )

STATUS=$(</sys/class/power_supply/BAT0/status)
PERCENT=$(</sys/class/power_supply/BAT0/capacity)

ICON=
if   [[ ${STATUS,,} == "charging" ]]; then ICON="󰂄";
elif (( PERCENT < 5 )); then ICON="󰂎";
elif (( PERCENT < 15 )); then ICON="󰁺";
elif (( PERCENT < 25 )); then ICON="󰁻";
elif (( PERCENT < 35 )); then ICON="󰁼";
elif (( PERCENT < 45 )); then ICON="󰁽";
elif (( PERCENT < 55 )); then ICON="󰁾";
elif (( PERCENT < 65 )); then ICON="󰁿";
elif (( PERCENT < 75 )); then ICON="󰂀";
elif (( PERCENT < 85 )); then ICON="󰂁";
elif (( PERCENT < 95 )); then ICON="󰂂";
else ICON="󰁹";
fi

echo -e "$ICON($PERCENT%)"
