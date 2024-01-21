#! /usr/bin/env bash

BOP_URL="http://localhost:8888"

_display_bop_dead_message() {
  local msg
  msg=${1:-"bop is asleep!"}
	tmux display -d 0 "#[bg=red,fill=red,fg=black] 󰭺 Message: $msg"
}

status=$(curl -sSf "$BOP_URL" 2>&1)
if grep -i "connection refused" <<< "$status"; then
  _display_bop_dead_message "bop is offline."
  exit
fi

if grep -i "404" <<< "$status"; then
  _display_bop_dead_message "no music playing right now."
  exit
fi

DELAY=7
CURRENT_PATH="$HOME/.local/scripts/dashboard"
CENTER=true
[ "$1" = "--no-center" ] && CENTER=false
[ "$1" = "-nc" ] && CENTER=false

[ -d "$CURRENT_PATH/downloads" ] || mkdir "$CURRENT_PATH/downloads"

command -v chafa &>/dev/null || {
	printf "chafa is not installed.\n"
	exit 1
}

command -v jq &>/dev/null || {
	printf "jq is not installed.\n"
	exit 1
}

_ellipsis() {
	read -r text
	awk '{printf substr($0, 0, 29); if (length($0) > 29) { printf "..."; } printf "\n"}' <<< "$text"
}

date() {
	if uname | grep -iq darwin; then
		gdate "$@"
	else
		/usr/bin/date "$@"
	fi
}

download_if_not_exists() {
	url="$1"
	[ -z "$url" ] && return

	hash=$(sha256sum <<< "$url" | awk '{print $1}')
	image_path="$CURRENT_PATH/downloads/$hash"
	printf "%s\n" "$image_path"
	find "$CURRENT_PATH/downloads" -type f -iname "$hash\.*" | grep -q . && return

	curl -fs --output "${image_path}.jpg" "$url" || {
		_display_bop_dead_message
		exit 1
	}
}

chafa_if_not_yet() {
	path="$1"

	[ -e "$path" ] && return

	chafa -s 30x30 "${path}.jpg" > "$path"
}

progress_bar() {
	local current
	local total

	current="$1"
	total="$2"
	# im going to jail for this one
	percentage=$(jq -n "(${current}/${total}) * 100 | round")
	steps=$(( percentage / 10 ))

	start=$(date +"%M:%S" -d "1970-01-01 $current seconds")
	ending=$(date +"%M:%S" -d "1970-01-01 $total seconds")

	printf "%s " "$start"
	for (( i=0; i<10; i++ )); do
		(( i == 0 )) && {
			printf '\e[33m█\033[0m'
			continue
		}
		(( i <= steps )) && {
			printf '\e[33m██\033[0m'
			continue
		}
		printf '\e[38;5;238m██\033[0m'
	done
	printf " %s" "$ending"
}

current_song=$(curl -fs "$BOP_URL/status")
[ "$?" -ne 0 ] && {
	_display_bop_dead_message
	exit 1
}
grep -iq "Not found" <<< "$current_song" && {
	printf "No song playing.\n"
	exit
}

song=$(jq -r '.display_name' <<< "$current_song" | _ellipsis)
artist=$(jq -r '.artist' <<< "$current_song" | _ellipsis)
image=$(jq -r '.image_url' <<< "$current_song")
is_playing=$(jq -r '.is_playing' <<< "$current_song")
current_time=$(jq -r '.current_second' <<< "$current_song")
total_time=$(jq -r '.total_seconds' <<< "$current_song")

image_path=$(download_if_not_exists "$image")
chafa_if_not_yet "$image_path"

refetch_data() {
	current_song=$(curl -fs "$BOP_URL/status")
	grep -iq "Not found" <<< "$current_song" && {
		printf "No song playing.\n"
		exit
	}
	song=$(jq -r '.display_name' <<< "$current_song" | _ellipsis)
	artist=$(jq -r '.artist' <<< "$current_song" | _ellipsis)
	image=$(jq -r '.image_url' <<< "$current_song")
	current_time=$(jq -r '.current_second' <<< "$current_song")
	total_time=$(jq -r '.total_seconds' <<< "$current_song")
	is_playing=$(jq -r '.is_playing' <<< "$current_song")

	image_path=$(download_if_not_exists "$image")
	chafa_if_not_yet "$image_path"
}

lines=$(tput lines)
lines=$(( (lines - 15) / 2 )) # 15 is the size of the album cover
horizontal_padd=$(( ($(tput cols) - 60) / 2 ))

time_since_last_fetch=0

printf '\033[?25l'
trap "printf '\033[?25h' ; trap - SIGTERM SIGINT ; exit" SIGTERM SIGINT

while true; do
	(( current_time >= total_time )) && {
		time_since_last_fetch=0
		refetch_data || break
	}
	(( time_since_last_fetch > "$DELAY" )) && {
		time_since_last_fetch=0
		refetch_data || break
	}

	index=0
	progress="$(progress_bar "$current_time" "$total_time")"

	IFS=$'\n'
	for line in $(cat "$image_path"); do
		[ $index -eq 0 ] && {
			clear
			[ "$CENTER" = true ] && for (( i=0;i<lines;i++ )); do printf "\n"; done
		}

		for (( i=0; i<horizontal_padd; i++ )); do printf " "; done

		printf "%s" "$line"

		[ $index -eq 4 ] && printf "     %s" "$song"
		[ $index -eq 5 ] && printf "     %s" "$artist"
		[ $index -eq 6 ] && printf "     %s" "$progress"

		printf "\n"

		index=$((index + 1))
	done

	current_time=$(( current_time + 1 ))
	time_since_last_fetch=$(( time_since_last_fetch + 1 ))

	[ "$is_playing" = false ] && {
		sleep "$DELAY"
		time_since_last_fetch=$(( time_since_last_fetch + DELAY ))
		continue
	}

	sleep 1
done
