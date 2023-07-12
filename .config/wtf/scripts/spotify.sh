#! /usr/bin/env bash

handle_tildes() {
  awk '{
    gsub("á", "a", $0);
    gsub("é", "e", $0);
    gsub("í", "i", $0);
    gsub("ó", "o", $0);
    gsub("ú", "u", $0);

    print $0
  }' <<< "$1"
}

first_ten_chars() {
  deftitle="$2"

  output=$(awk '{ print substr($0, 1, 21) }' <<< "$1")
  output=$(handle_tildes "$output")
  char_len=$(awk '{ gsub(/ */, "", $0); print $0 }' <<< "$output" | wc -c)

  [ "$char_len" -eq 0 ] && echo "$deftitle"
  [ "$char_len" -gt 0 ] && echo "$output"
}

output=$(spotify status)
track=$(grep -i track <<< "$output" | awk -F':' '{print $2}' | sed 's/^ //')
artist=$(grep -i artist <<< "$output" | awk -F':' '{print $2}' | sed 's/^ //')

printf "\e[31m"
figlet -w 65 -f ~/.local/fonts/ansi_shadow.flf "$(first_ten_chars "$track" "Cool song!")"
printf "\e[33m"
figlet -w 65 -f ~/.local/fonts/ansi_shadow.flf "$(first_ten_chars "$artist" "Cool artist!")"

if grep -i pause <<< "$output" &>/dev/null; then
  printf "\e[90m"
  figlet -w 65 -f ~/.local/fonts/ansi_shadow.flf "Paused"
else
  printf "\e[32m"
  figlet -w 65 -f ~/.local/fonts/ansi_shadow.flf "Playing"
fi
