#! /bin/sh

if [ ! -z $(uname | grep -i darwin) ]; then
  ~/.local/scripts/osx/spotify.sh "$@"
else
  ~/.local/scripts/linux/spotify.sh "$@"
fi
