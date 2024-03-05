#! /usr/bin/env bash

declare SHIFT_PATH="$HOME/.local/scripts/shift/shift" \
	OUTFILE="$HOME/.cache/.cornucopia"

clear_response() {
	: >"$OUTFILE"
}
clear_response

: # bash 5+ required
# shellcheck disable=SC2120
die() {
	[ -n "$*" ] && terror "$*"
	exit
}
assert_installed() { command -v "$1" &>/dev/null || die "$1 is not installed."; }
istmux() { [ -n "$TMUX" ]; }
talert() { tmux display -d 0 "#[bg=#{@color_info},fill=#{@color_info},fg=black] 󰭺 Message: $*"; }
terror() { tmux display -d 0 "#[bg=#{@color_error},fill=#{@color_error},fg=black]  Message: $*"; }
tsuccess() { tmux display -d 0 "#[bg=#{@color_success},fill=#{@color_success},fg=black]  Message: $*"; }

read_result() {
	tail -1 "$OUTFILE"
}

istmux || die this script only works inside tmux
assert_installed cornucopia

if [ ! -x "$SHIFT_PATH" ]; then
	terror "shift not installed"
	exit
fi

case "${1:-add}" in
add)
	clear_response
	tmux display-popup -w 65 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "\n" |
		"$SHIFT_PATH" \
		-title " Search by name " \
		-icon " 󰉜 " \
		-width 65 \
		-height 9 \
		-output "$OUTFILE" \
		-mode create
EOF
	)"
	query="$(read_result)"
	[ -z "$query" ] && exit

	clear_response
	options="$(cornucopia search -q "$query")" || die "Could not fetch food"
	[ -z "$options" ] && die "No matches found."
	options="$(sed 's/"//g' <<< "$options")"
	tmux display-popup -w 95 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "$options" |
		"$SHIFT_PATH" \
		-title " Select by name " \
		-icon " 󰉜 " \
		-width 95 \
		-height 9 \
		-output "$OUTFILE"
EOF
	)"
	item="$(read_result)"
	[ -z "$item" ] && exit

	clear_response
	options="$(cat - <<-EOF
	Breakfast
	Lunch
	Dinner
	Extra
	EOF
	)"
	tmux display-popup -w 65 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "$options" |
		"$SHIFT_PATH" \
		-title " Time of the day " \
		-icon " 󰉜 " \
		-width 65 \
		-height 9 \
		-output "$OUTFILE"
EOF
	)"

	time="$(read_result | xargs)"
	[ -z "$time" ] && exit

	calories="$(awk '{print $1}' <<< "$item" | sed 's/^\[//' | sed 's/calories//' | xargs)"
	item="$(sed 's/\[.*\]//' <<< "$item" | xargs)"

	cornucopia entries add -n "$item" -t "$time" -c "$calories" || die "Could not add entry."

	tsuccess "Entry added."
	;;

total)
	t=$(cornucopia entries total) || die Could not fetch data

	talert "$t calories consumed today, so far."
	;;

reset)
	cornucopia entries reset &>/dev/null || die Could not update entries.

	tsuccess "Entries reset."
	;;

custom)
	clear_response
	tmux display-popup -w 65 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "\n" |
		"$SHIFT_PATH" \
		-title " Format: <calories> <name> " \
		-icon " 󰉜 " \
		-width 65 \
		-height 9 \
		-output "$OUTFILE" \
		-mode create
EOF
	)"
	entry="$(read_result)"
	[ -z "$entry" ] && exit

	calories="$(awk '{print $1}' <<< "$entry")"
	name="$(awk '{$1=""; print $0}' <<< "$entry" | xargs)"
	if [ -z "$calories" ] || [ -z "$name" ]; then
		die "Invalid entry."
	fi

	cornucopia foods add -n "$name" -c "$calories" || die "Could not create entry."

	tsuccess "Food added."
	;;

*)
	terror "Invalid cmd: $1"
	die
	;;
esac
