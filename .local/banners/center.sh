#! /bin/bash

file="$HOME/.local/banners/$1"
width="$2"
cols="$(tput cols)"
padd=$(( (cols - width) / 2 ))

padding="$(for ((i=1; i <= padd; i++)); do printf ' '; done)"
cat $file | sed -e "s/^/$padding/"
