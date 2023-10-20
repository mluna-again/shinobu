#! /usr/bin/env bash

skip=$(( ( $(tput lines) - 14 ) / 2))

for (( i=0;i<skip;i++ )); do printf "\n"; done

date +"%H:%M:%S" | figlet -c -f "$HOME/.local/fonts/ansi_shadow.flf"
