#! /bin/sh

truncate() {
  printf "%.45s" "$1"
}

if uname | grep -i darwin &>/dev/null; then
  truncate "$(~/.local/scripts/osx/spotify.sh)"
else
  truncate "$(~/.local/scripts/linux/spotify.sh)"
fi
