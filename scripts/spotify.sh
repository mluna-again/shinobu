#! /bin/sh

# This scripts just returns the current spotify song. ;)

# spotify not installed
command -v spotify &>/dev/null || { echo "No spotify!" ; exit; }

# spotify not playing
playerctl -p spotify metadata &>/dev/null  || exit

song_name=$(playerctl -p spotify metadata | grep -i title | cut -f 3- -d " " | tr -s "[:blank:]")
artist=$(playerctl -p spotify metadata artist)

echo "$artist -$song_name"
