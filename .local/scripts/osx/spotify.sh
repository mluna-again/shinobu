#! /bin/sh

command -v spotify &>/dev/null || { echo "No spotify!"; exit; }

pgrep Spotify &>/dev/null || exit

output=$(spotify status)
song_name=$(grep -i track <<< "$output" | sed 's/Track: //')
artist=$(grep -i artist <<< "$output" | sed 's/Artist: //')
title="$song_name- $artist"
short_title=$(echo $title | cut -c -30)
playing=$(grep -i paused <<< "$output" && echo no || echo yes)

should_truncate=$([ ${#title} -gt 30 ] && echo yes || echo no)

if [ "$playing" == "yes" ]; then
	[ "$should_truncate" == yes ] && echo "#[fg=green]阮$short_title...#[fg=default]" || echo "#[fg=green]阮$title#[fg=default]"
else
	[ "$should_truncate" == yes ] && echo "#[fg=gray]阮$short_title...#[fg=default]" || echo "#[fg=gray]阮$title#[fg=default]"
fi
