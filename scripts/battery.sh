#! /bin/sh

# This script prints the colored (tmux format) current battery percentage.

battery=$(upower -e | grep -i bat0)

percentage=$(upower -i $battery | grep -i percentage | awk '{print $2}')

low_battery=$([ $(echo $percentage | cut -c -2) -le 25 ] && echo "yes" || echo "no")

plugged=$(upower -i $battery | grep -i ".*state:.*\bcharging\b.*" &>/dev/null && echo "yes" || echo "no")

if [ "$plugged" == "yes" ]; then
	echo "#[fg=green] $percentage"
elif [ "$low_battery" == "no" ]; then

	if [ "$percentage" -ge 90 ]; then
		echo "#[fg=green] $percentage"
	elif [ "$percentage" -ge 70 ]; then
		echo "#[fg=green] $percentage"
	elif [ "$percentage" -ge 50 ]; then
		echo "#[fg=green] $percentage"
	elif [ "$percentage" -ge 30 ]; then
		echo "#[fg=green] $percentage"
	fi

else
	echo "#[fg=red] $percentage"
fi
