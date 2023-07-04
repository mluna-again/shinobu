#! /bin/bash

term_width="$1"

width=`[ $term_width -lt 100 ] && echo 15 || echo 30`

pgrep Spotify &>/dev/null || exit

icon=""

get_song_name() {
	spotify status track
}
song_name=$(get_song_name)

get_artist() {
	spotify status artist
}
artist=$(get_artist)

title="$song_name - $artist"
short_title=$(echo $title | cut -c -$width)

should_truncate=$([ ${#title} -gt $width ] && echo yes || echo no)

[ "$should_truncate" == yes ] && echo "#[bg=yellow,fg=black] $icon $short_title...#[fg=default]" || echo "#[bg=yellow,fg=black] $icon $title#[fg=default]"
