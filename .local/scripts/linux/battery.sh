#! /bin/sh

# This script prints the colored (tmux format) current battery percentage.

battery=$(upower -e | grep -i bat0)

percentage=$(upower -i $battery | grep -i percentage | awk '{print $2}')
percentage_num=$(echo $percentage | cut -c -3)

low_battery=$([ $percentage_num -le 20 ] && echo "yes" || echo "no")

plugged=$(upower -i $battery | grep -i ".*state:.*\bcharging\b.*" &>/dev/null && echo "yes" || echo "no")

if [ "$plugged" == "yes" ]; then
	echo "#[fg=green] $percentage"
elif [ "$low_battery" == "no" ]; then

	if [ "$percentage_num" -ge "90" ]; then
		echo "#[fg=green] $percentage"
	elif [ "$percentage_num" -ge "70" ]; then
		echo "#[fg=green] $percentage"
	elif [ "$percentage_num" -ge "50" ]; then
		echo "#[fg=yellow] $percentage"
	elif [ "$percentage_num" -ge "30" ]; then
		echo "#[fg=yellow] $percentage"
	elif [ "$percentage_num" -ge "20" ]; then
		echo "#[fg=orange] $percentage"
	fi

else
	echo "#[fg=red] $percentage"
fi
