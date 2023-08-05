#!/bin/sh

percentage=$(system_profiler SPPowerDataType | grep -i "state of charge" | awk '{print $(NF)}')

low_battery=$([ $percentage -le 20 ] && echo yes || echo no)
plugged=$(system_profiler SPPowerDataType | grep -i "connected: no" && echo no || echo yes)

if [ "$plugged" == "yes" ]; then
	echo "   $percentage%"
elif [ "$low_battery" == "no" ]; then

	if [ "$percentage" -ge "90" ]; then
		echo " 󰁹 $percentage%"
	elif [ "$percentage" -ge "70" ]; then
		echo " 󰂂 $percentage%"
	elif [ "$percentage" -ge "50" ]; then
		echo " 󰂀 $percentage%"
	elif [ "$percentage" -ge "30" ]; then
		echo " 󰁾 $percentage%"
	elif [ "$percentage" -ge "20" ]; then
		echo " 󰁻 $percentage%"
	fi

else
	echo " 󰁺 $percentage%"
fi
