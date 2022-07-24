#! /bin/sh

command -v spotify &>/dev/null || { echo "No spotify!"; exit; }

pgrep Spotify &>/dev/null || exit

output=$(spotify status)
song_name=$(grep -i track <<< "$output" | sed 's/Track: //')
artist=$(grep -i artist <<< "$output" | sed 's/Artist: //')
title="$song_name - $artist"
short_title=$(echo $title | cut -c -30)
playing=$(grep -i paused <<< "$output" && echo no || echo yes)

if [ "$playing" == "yes" ]; then
	[ "$title" != "$short_title" ] && echo "#[fg=green]阮$short_title..." || echo "#[fg=green]阮$title"
else
	[ "$title" != "$short_title" ] && echo "#[fg=gray]阮$short_title..." || echo "#[fg=gray]阮$title"
fi
