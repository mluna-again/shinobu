#! /bin/sh

if uname | grep -i darwin &>/dev/null; then
  ~/.local/scripts/spotify_osx.sh
else
  ~/.local/scripts/spotify_linux.sh
fi
