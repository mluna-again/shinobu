#! /usr/bin/env bash
#
background="#282727"
colors="#[fg=white,bg=$background]"
pgrep Spotify &>/dev/null || colors="#[fg=$background,bg=white]"

uname | grep -i darwin &>/dev/null || exit

printf "%s" "$colors"
round() {
	{ [ "$1" = "100%" ] && printf " %%"; } || printf "%s" "$1"
}

format_level() {
	{ [ "$1" = "null" ] && printf "-"; } || round "$1"
	printf " 󱡏 "
	{ [ "$2" = "null" ] && printf "-"; } || round "$2"
}

airpods() {
	info="$(system_profiler SPBluetoothDataType -json | jq '.SPBluetoothDataType[0].device_connected | map(select(. | keys | .[0] | contains("AirPods")))[0]["AirPods Pro"]')"

	[ -z "$info" ] && return
	[ "$info" = "null" ] && return

	right="$(jq -r '.device_batteryLevelRight' <<< "$info")"
	left="$(jq -r '.device_batteryLevelLeft' <<< "$info")"

	format_level "$left" "$right"
}

output="$(airpods)"
{ [ -n "$output" ] && printf " %s " "$output"; } || true
