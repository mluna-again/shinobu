#!/bin/sh

percentage=$(system_profiler SPPowerDataType | grep -i "state of charge" | awk '{print $(NF)}')

low_battery=$([ $percentage -le 20 ] && echo yes || echo no)
plugged=$(system_profiler SPPowerDataType | grep -i "connected: no" && echo no || echo yes)

if [ "$plugged" == "yes" ]; then
	echo "#[fg=#252535,bg=#76946A]   $percentage%"
elif [ "$low_battery" == "no" ]; then

	if [ "$percentage" -ge "90" ]; then
		echo "#[fg=#252535,bg=#76946A]  $percentage%"
	elif [ "$percentage" -ge "70" ]; then
		echo "#[fg=#252535,bg=#76946A]  $percentage%"
	elif [ "$percentage" -ge "50" ]; then
		echo "#[fg=#252535,bg=#E6C384]  $percentage%"
	elif [ "$percentage" -ge "30" ]; then
		echo "#[fg=#252535,bg=#E6C384]  $percentage%"
	elif [ "$percentage" -ge "20" ]; then
		echo "#[fg=#252535,bg=#E46876]  $percentage%"
	fi

else
	echo "#[fg=#252535,bg=#E46876]  $percentage%"
fi
