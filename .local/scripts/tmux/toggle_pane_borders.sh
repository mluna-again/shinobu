#! /usr/bin/env sh

count=$(tmux list-panes | wc -l)

[ "$count" -gt 1 ] && tmux set -g pane-border-status top
[ "$count" -lt 2 ] && tmux set -g pane-border-status off

true
