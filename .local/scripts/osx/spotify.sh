#! /bin/sh

[[ -S ~/.cache/ncspot/ncspot.sock ]] || exit
pgrep ncspot || exit

output=$(nc -w 1 -U ~/.cache/ncspot/ncspot.sock)
song_name=$(echo $output | jq '.playable.title')
artist=$(echo $output | jq '.playable.title')
title="$song_name- $artist"
short_title=$(echo $title | cut -c -30)
playing=$(grep -i paused <<< "$output" && echo no || echo yes)

[ "$playing" == "yes" ] || exit

should_truncate=$([ ${#title} -gt 30 ] && echo yes || echo no)

if [ "$playing" == "yes" ]; then
	[ "$should_truncate" == yes ] && echo "#[bg=red,fg=black] 阮 $short_title...#[fg=default]" || echo "#[bg=red,fg=black] 阮 $title#[fg=default]"
else
	[ "$should_truncate" == yes ] && echo "#[bg=black,fg=red] 阮 $short_title...#[fg=default]" || echo "#[bg=black,fg=red] 阮 $title#[fg=default]"
fi
