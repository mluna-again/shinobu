#! /bin/sh

# This script prints the current battery percentage.

battery=$(upower -e | grep -i bat0)

percentage=$(upower -i $battery | grep -i percentage | awk '{print $2}')
percentage_num=$(echo $percentage | cut -c -3)

echo $percentage_num
