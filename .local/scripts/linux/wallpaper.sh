#! /bin/sh

killall xwinwrap
killall mpv

feh --bg-fill ~/Pictures/wallpaper.png

[ -e ~/Videos/wallpaper.mp4 ] && xwinwrap -fs -fdt -ni -b -nf -un -o 1.0 -debug -- mpv -wid WID --loop --no-audio --hwdec=yes ~/Videos/wallpaper.mp4
