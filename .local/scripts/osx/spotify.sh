#! /bin/sh

pgrep ncspot &>/dev/null || pgrep Spotify &>/dev/null || exit

using_spotify=$(pgrep ncspot &>/dev/null && echo no || echo yes)
get_info() {
	[ $using_spotify = no ] && { nc -w 1 -U ~/.cache/ncspot/ncspot.sock && return; }
}

output=$(get_info)

get_song_name() {
	[ $using_spotify = no ] && { echo $output | jq '.playable.title' | sed 's/"//g' && return; }

	spotify status track
}
song_name=$(get_song_name)

get_artist() {
	[ $using_spotify = no ] && { echo $output | jq '.playable.artists[0]' | sed 's/"//g' && return; }

	spotify status artist
}
artist=$(get_artist)

title="$song_name - $artist"
short_title=$(echo $title | cut -c -30)

should_truncate=$([ ${#title} -gt 30 ] && echo yes || echo no)

[ "$should_truncate" == yes ] && echo "#[bg=red,fg=black] 阮 $short_title...#[fg=default]" || echo "#[bg=red,fg=black] 阮 $title#[fg=default]"
