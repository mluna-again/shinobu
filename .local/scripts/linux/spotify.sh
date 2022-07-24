#! /bin/sh

# This scripts just returns the current spotify song. ;)

# spotify not installed
command -v spotify &>/dev/null || { echo "No spotify!" ; exit; }

# spotify not playing
playerctl -p spotify metadata &>/dev/null  || exit

song_name=$(playerctl -p spotify metadata | grep -i title | cut -f 3- -d " " | tr -s "[:blank:]")
artist=$(playerctl -p spotify metadata artist)

title="$song_name - $artist"
short_title=$(echo $title | cut -c -30)
playing=$([ $(playerctl -p spotify status) == "Playing" ] && echo "yes" || echo "no")


if [ "$playing" == "yes" ]; then
	[ "$title" != "$short_title" ] && echo "#[fg=green]阮$short_title...#[fg=defaut]" || echo "#[fg=green]阮$title#[fg=defaut]"
else
	[ "$title" != "$short_title" ] && echo "#[fg=gray]阮$short_title...#[fg=defaut]" || echo "#[fg=gray]阮$title#[fg=defaut]"
fi
