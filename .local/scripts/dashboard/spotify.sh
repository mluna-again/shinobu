#! /usr/bin/env bash

CURRENT_PATH="$HOME/.local/scripts/dashboard"
BOP_URL="http://localhost:8888"

[ -d "$CURRENT_PATH/downloads" ] || mkdir "$CURRENT_PATH/downloads"

command -v chafa &>/dev/null || {
	printf "chafa is not installed.\n"
	exit 1
}

command -v jq &>/dev/null || {
	printf "jq is not installed.\n"
	exit 1
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

	curl -s --output "${image_path}.jpg" "$url"
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

current_song=$(curl -s "$BOP_URL/status")
song=$(jq -r '.display_name' <<< "$current_song")
artist=$(jq -r '.artist' <<< "$current_song")
image=$(jq -r '.image_url' <<< "$current_song")
current_time=$(jq -r '.current_second' <<< "$current_song")
total_time=$(jq -r '.total_seconds' <<< "$current_song")

image_path=$(download_if_not_exists "$image")
chafa_if_not_yet "$image_path"

refetch_data() {
	current_song=$(curl -s "$BOP_URL/status")
	song=$(jq -r '.display_name' <<< "$current_song")
	artist=$(jq -r '.artist' <<< "$current_song")
	image=$(jq -r '.image_url' <<< "$current_song")
	current_time=$(jq -r '.current_second' <<< "$current_song")
	total_time=$(jq -r '.total_seconds' <<< "$current_song")

	image_path=$(download_if_not_exists "$image")
	chafa_if_not_yet "$image_path"
}

lines=$(tput lines)
lines=$(( (lines - 15) / 2 )) # 15 is the size of the album cover

time_since_last_fetch=0
while true; do
	(( current_time >= total_time )) && {
		time_since_last_fetch=0
		refetch_data || break
	}
	(( time_since_last_fetch > 7 )) && {
		time_since_last_fetch=0
		refetch_data || break
	}

	index=0
	progress="$(progress_bar "$current_time" "$total_time")"

	IFS=$'\n'
	for line in $(cat "$image_path"); do
		[ $index -eq 0 ] && {
			clear
			for (( i=0;i<lines;i++ )); do printf "\n"; done
		}
		printf "%s" "$line"

		[ $index -eq 4 ] && printf "     %s" "$song"
		[ $index -eq 5 ] && printf "     %s" "$artist"
		[ $index -eq 6 ] && printf "     %s" "$progress"

		printf "\n"

		index=$((index + 1))
	done

	current_time=$(( current_time + 1 ))
	time_since_last_fetch=$(( time_since_last_fetch + 1 ))
	sleep 1
done
