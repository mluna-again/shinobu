#! /usr/bin/env bash

declare OUTFILE="$HOME/.cache/.cornucopia"

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

istmux || { echo this script only works inside tmux 1>&2; exit 1; }
assert_installed cornucopia

if [ ! -x mshift ]; then
	terror "shift not installed"
	exit
fi

case "${1:-add}" in
add)
	clear_response
	tmux display-popup -w 65 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "\n" |
		mshift \
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
	recipes="$(cornucopia recipes search -q "$query")" || die "Could not fetch recipes"
	food="$(cornucopia search -q "$query")" || die "Could not fetch food"
	options="$({ echo "$recipes"; echo "$food"; })"
	[ -z "$options" ] && die "No matches found."
	options="$(sed 's/"//g' <<< "$options")"
	tmux display-popup -w 95 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "$options" |
		mshift \
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
		mshift \
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

	if echo "$recipes" | grep -iq "$item"; then
		grams=100
	else
		clear_response
		tmux display-popup -w 65 -h 11 -y 15 -E "$(
			cat - <<EOF
		echo "\n" |
			mshift \
			-title " Grams/Milliliters " \
			-icon " 󰉜 " \
			-width 65 \
			-height 9 \
			-output "$OUTFILE" \
			-mode create \
			-initial 100
EOF
		)"
		grams=$(read_result)
		if [[ ! "$grams" =~ ^[0-9]+$ ]]; then
			die "Invalid number"
		fi
	fi

	cornucopia entries add -n "$item" -t "$time" -c "$calories" -g "$grams" || die "Could not add entry."

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
		mshift \
		-title " Calories per 100gr/ml " \
		-icon " 󰉜 " \
		-width 65 \
		-height 9 \
		-output "$OUTFILE" \
		-mode create
EOF
	)"
	calories="$(read_result)"
	[ -z "$calories" ] && exit
	if [[ ! "$calories" =~ ^[0-9.]+$ ]]; then
		die "Invalid number"
	fi

	clear_response
	tmux display-popup -w 65 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "\n" |
		mshift \
		-title " Food name " \
		-icon " 󰉜 " \
		-width 65 \
		-height 9 \
		-output "$OUTFILE" \
		-mode create
EOF
	)"
	name="$(read_result)"
	[ -z "$name" ] && exit

	clear_response
	tmux display-popup -w 65 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "\n" |
		mshift \
		-title " Brand name " \
		-icon " 󰉜 " \
		-width 65 \
		-height 9 \
		-output "$OUTFILE" \
		-mode create
EOF
	)"
	brand="$(read_result)"

	cornucopia foods add -n "$name" -c "$calories" -b "$brand" || die "Could not create entry."

	tsuccess "Food added."
	;;


report)
	tmux display-popup -w "100%" -h "100%" -E "cornucopia reports today"
	;;

delete)
	clear_response
	options="$(cornucopia entries today)" || die "Could not fetch entries"
	tmux display-popup -w 95 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "$options" |
		mshift \
		-title " Daily entries " \
		-icon " 󰉜 " \
		-width 95 \
		-height 9 \
		-output "$OUTFILE"
EOF
	)"

	item="$(read_result)"
	[ -z "$item" ] && die

	output=$(cornucopia entries delete -q "$item" 2>&1)
	if [[ "$output" =~ .*Duplicate.* ]]; then
		clear_response
		tmux display-popup -w 95 -h 11 -y 15 -E "$(
			cat - <<EOF
		echo "\n" |
			mshift \
			-title " Duplicated entry, delete all? [N/y] " \
			-icon " 󰉜 " \
			-width 95 \
			-height 9 \
			-output "$OUTFILE" \
			-mode create \
			-initial n
EOF
		)"

		resp="$(read_result)"
		[ -z "$resp" ] && die
		[[ ! "$resp" =~ ^(y|Y)$ ]] && die

		cornucopia entries delete -f -q "$item" &>/dev/null || die "Could not delete entries."
		tsuccess "Entries deleted."
		exit
	fi

	tsuccess "Entry deleted."
	;;

recipe)
	clear_response
	tmux display-popup -w 65 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "\n" |
		mshift \
		-title " Recipe's name " \
		-icon " 󰉜 " \
		-width 65 \
		-height 9 \
		-output "$OUTFILE" \
		-mode create
EOF
	)"
	name="$(read_result)"
	[ -z "$name" ] && exit

	clear_response
	tmux display-popup -w 65 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "\n" |
		mshift \
		-title " Recipe's description " \
		-icon " 󰉜 " \
		-width 65 \
		-height 9 \
		-output "$OUTFILE" \
		-mode create
EOF
	)"
	description="$(read_result)"
	[ -z "$description" ] && exit

	cornucopia recipes add -n "$name" -d "$description" || die "Could not create recipe."

	tsuccess "Recipe added."
	;;

*)
	terror "Invalid cmd: $1"
	die
	;;
esac
