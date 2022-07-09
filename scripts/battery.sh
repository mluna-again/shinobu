#! /bin/sh

# This script prints the colored (tmux format) current battery percentage.

battery=$(upower -e | grep -i bat0)

percentage=$(upower -i $battery | grep -i percentage | awk '{print $2}')

low_battery=$([ $(echo $percentage | cut -c -2) -le 25 ] && echo "yes" || echo "no")

if [ "$low_battery" == "no" ]; then
	echo "#[fg=green]$percentage"
else
	echo "#[fg=red]$percentage"
fi
