#! /usr/bin/env bash

case "$1" in
	kanawaga-dragon)
		tmux set -g @components_active_background1 "#c4b28a"
		tmux set -g @components_active_background2 "#c4746e"
		tmux set -g @components_active_background3 "#8ba4b0"
		tmux set -g @components_active_background4 "#a292a3"
		tmux set -g @color_success "#8a9a7b"
		tmux set -g @color_info "#c4b28a"
		tmux set -g @color_error "#c4746e"
		tmux set -g @components_inactive_background terminal
		;;
esac

true
