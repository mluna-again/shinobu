#! /bin/sh

# This script prints the colored current battery percentage.

battery=$(upower -e | grep -i bat0)

percentage=$(upower -i $battery | grep -i percentage | awk '{print $2}')

low_battery=$([ $(echo $percentage | cut -c -2) -le 25 ] && echo "yes" || echo "no")

if [ "$low_battery" == "no" ]; then
  echo -e "\e[32m$percentage\e[0m"
else
  echo -e "\e[31m$percentage\e[0m"
fi
