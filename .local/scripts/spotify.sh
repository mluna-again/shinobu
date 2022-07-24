#! /bin/sh

if uname | grep -i darwin &>/dev/null; then
  ~/.local/scripts/osx/spotify.sh
else
  ~/.local/scripts/linux/spotify.sh
fi
