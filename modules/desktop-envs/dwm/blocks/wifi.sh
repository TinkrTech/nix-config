#!/usr/bin/env bash

strength=$(nmcli -t -f active,signal device wifi | grep '^yes' | cut -d: -f2-)
vpn=$(nmcli -t -f name,type connection show --active | grep "wireguard")

if [[ -z "$strength" ]]; then
	echo "󰤭"; exit 0
fi

SANS_VPN_ICONS=( "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" )
WITH_VPN_ICONS=( "󰤬" "󰤡" "󰤤" "󰤧" "󰤪" )

index=$(( (strength - 1) / 20 ))
if [[ -z "$vpn" ]]; then
	ICON=${SANS_VPN_ICONS[$index]}
else
	ICON=${WITH_VPN_ICONS[$index]}
fi

echo "$ICON"
