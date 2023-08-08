#!/bin/sh

percentage=$(system_profiler SPPowerDataType | grep -i "state of charge" | awk '{print $(NF)}')

low_battery=$([ "$percentage" -le 20 ] && echo yes || echo no)
plugged=$(system_profiler SPPowerDataType | grep -i "connected: no" && echo no || echo yes)

if [ "$plugged" = "yes" ]; then
	echo "#[bg=terminal,fg=terminal]$percentage% #[bg=$2,fg=black]  "
elif [ "$low_battery" = "no" ]; then

	if [ "$percentage" -ge "90" ]; then
		echo "#[bg=terminal,fg=terminal]$percentage% #[bg=$2,fg=black] 󰁹 "
	elif [ "$percentage" -ge "70" ]; then
		echo "#[bg=terminal,fg=terminal]$percentage% #[bg=$2,fg=black] 󰂂 "
	elif [ "$percentage" -ge "50" ]; then
		echo "#[bg=terminal,fg=terminal]$percentage% #[bg=$2,fg=black] 󰂀 "
	elif [ "$percentage" -ge "30" ]; then
		echo "#[bg=terminal,fg=terminal]$percentage% #[bg=$2,fg=black] 󰁾 "
	elif [ "$percentage" -ge "20" ]; then
		echo "#[bg=terminal,fg=terminal]$percentage% #[bg=$2,fg=black] 󰁻 "
	fi

else
	echo "#[bg=terminal,fg=terminal]$percentage% #[bg=$2,fg=black] 󰁺 "
fi
