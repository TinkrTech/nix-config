#!/usr/bin/env bash

sleep_off="󰒳"
sleep_on="󰒲"

screen_timeout="$(xset q | grep -A 2 "Screen Saver" | awk '{print $2}' | tail -1)"

if (( screen_timeout == 0 )); then
	echo "$sleep_off"
else
	echo "$sleep_on"
fi
