#! /usr/bin/env bash

tmux kill-session -t scratch &>/dev/null || true
"$HOME/.local/scripts/tmux/welcome/welcome.sh"
