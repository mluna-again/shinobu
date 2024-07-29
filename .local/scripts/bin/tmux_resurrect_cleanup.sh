#! /usr/bin/env bash

if [ "$1" = help ] || [ "$1" = -h ] || [ "$1" = --help ]; then
  cat - <<EOF
Sometimes tmux-resurrect doesn't feel like working, for some reason the last session points to a file that
doesn't exist. This script re-creates the link to the last existing session. If it doesn't work the first
time maybe run it once more, that'll surely fix it :D (it won't).

Usage:
tmux_resurrect_cleanup.sh             # re-links the last session file
tmux_resurrect_cleanup.sh rollback    # deletes the latest session file, and re-links the before last session file
EOF
  exit 1
fi

CURR_DIR="$(pwd)"
CACHE_DIR="$HOME/.cache/resurrect"

cd "$CACHE_DIR" || exit
last_file=$(find . -printf "%T@ %Tc %p\n" | sort -n | head -1 | awk '{print $NF}' | sed 's|./||')

if [ ! -f "$last_file" ]; then
  >&2 echo no session found
  exit 1
fi

if [ "$1" = rollback ]; then
  rm "$CACHE_DIR/$last_file"
  last_file=$(find . -printf "%T@ %Tc %p\n" | sort -n | head -1 | awk '{print $NF}' | sed 's|./||')
fi

if [ ! -f "$last_file" ]; then
  >&2 echo no session found
  exit 1
fi

ln -sf "$CACHE_DIR/$last_file" "$CACHE_DIR/last" || exit

cd "$CURR_DIR" || exit
