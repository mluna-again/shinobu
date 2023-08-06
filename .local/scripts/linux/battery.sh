#! /bin/bash

# This script prints the colored (tmux format) current battery percentage.
command -v upower &>/dev/null || { echo "Please install upower :)"; exit; }

battery=$(upower -e 2>/dev/null | grep -i bat0)

# something bad happened, for example, you tried to use wsl (windows 🤮) and
# that is something very, very bad.
[ -z "$battery" ] && { echo " 󰂑 #[bg=terminal,fg=terminal] ???%"; exit; }

percentage=$(upower -i "$battery" | grep -i percentage | awk '{print $2}')
percentage=$(echo "$percentage" | cut -c -3)

low_battery=$([ "$percentage" -le 20 ] && echo "yes" || echo "no")

plugged=$(upower -i "$battery" | grep -i ".*state:.*\bcharging\b.*" &>/dev/null && echo "yes" || echo "no")

if [ "$plugged" == "yes" ]; then
	echo "   #[bg=terminal,fg=terminal] $percentage%"
elif [ "$low_battery" == "no" ]; then

	if [ "$percentage" -ge "90" ]; then
		echo " 󰁹 #[bg=terminal,fg=terminal] $percentage%"
	elif [ "$percentage" -ge "70" ]; then
		echo " 󰂂 #[bg=terminal,fg=terminal] $percentage%"
	elif [ "$percentage" -ge "50" ]; then
		echo " 󰂀 #[bg=terminal,fg=terminal] $percentage%"
	elif [ "$percentage" -ge "30" ]; then
		echo " 󰁾 #[bg=terminal,fg=terminal] $percentage%"
	elif [ "$percentage" -ge "20" ]; then
		echo " 󰁻 #[bg=terminal,fg=terminal] $percentage%"
	fi

else
	echo " 󰁺 #[bg=terminal,fg=terminal] $percentage%"
fi
