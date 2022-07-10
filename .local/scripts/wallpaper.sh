#! /bin/sh

killall xwinwrap
killall mpv

[ -e ~/Videos/wallpaper.mp4 ] && xwinwrap -fs -fdt -ni -b -nf -un -o 1.0 -debug -- mpv -wid WID --loop --no-audio --hwdec=yes ~/Videos/wallpaper.mp4 || feh --bg-fill ~/Pictures/wallpaper.png
