#! /usr/bin/env bash

tmux kill-session -t __WELCOME__ &>/dev/null || true

# i do this because resurrect will restore this session otherwise, but i want to create it myself
# so it always starts with nvim running (i know there is an option to restore nvim but i don't want to
# overcomplicate it)
tmux kill-session -t scratch &>/dev/null || true
tmux new-session -d -c "$HOME/Notes" -s scratch -n index "nvim index.org" \; set status off

"$HOME/.local/scripts/tmux/welcome/welcome.sh"
