#!/bin/sh

if uname | grep -i darwin &>/dev/null; then
  ~/.local/scripts/osx/weather.sh
else
  ~/.local/scripts/linux/weather.sh
fi
