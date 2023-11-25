#! /usr/bin/env bash

big() {
  tmux set -g status-left "${base_path}${ram_usage}${todos_indicator}${ssh_indicator}${status_zoom}${status_prefix}"
  tmux set -g status-right "${pomodoro}${dots_indicator}${lock_indicator}${status_date_time}${status_battery}"
}

small() {
  tmux set -g status-left ""
  tmux set -g status-right "${status_prefix}${status_date_time}"
}

width=$(tmux display -p "#{client_width}")

[ "$width" -ge 100 ] && {
  tmux set -g status-justify absolute-centre
  big
  exit
}

tmux set -g status-justify left
small
