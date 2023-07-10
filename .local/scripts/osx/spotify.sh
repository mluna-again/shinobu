#! /bin/bash

term_width="$1"

width=$([ "$term_width" -lt 100 ] && echo 15 || echo 30)

pgrep Spotify &>/dev/null || exit

icon=""

output=$(spotify status)

get_song_name() {
	grep -i track <<< "$output" | awk -F':' '{sub(/ $/, "", $2); sub(/^ /, "", $2); print $2}'
}
song_name=$(get_song_name)

get_artist() {
	grep -i artist <<< "$output" | awk -F':' '{sub(/^ /, "", $2); print $2}'
}
artist=$(get_artist)

title="$icon $song_name - $artist"
short_title=$(echo "$title" | cut -c -"$width")

should_truncate=$([ ${#title} -gt "$width" ] && echo yes || echo no)

[ "$should_truncate" == yes ] && echo "#[bg=yellow,fg=black] $short_title...#[fg=default]" || echo "#[bg=yellow,fg=black] $title#[fg=default]"
