#! /bin/sh

RESULTS_FILE="$HOME/.cache/.shift_command_result"

read_input() {
	tail -1 "$RESULTS_FILE"
}

input() {
	title="$1"
	icon="$2"
	current_name=$(tmux display -p "#{window_name}")

	tmux display-popup -w 65 -h 11 -y 15 -E "[ -e \"$RESULTS_FILE\" ] && rm \"$RESULTS_FILE\" ; $HOME/.local/scripts/shift/shift -icon \"$icon\" -title \"$title\" -input '\n' -output \"$RESULTS_FILE\" -width 65 -height 9 -mode rename -initial=\"$current_name\""
}

input " Rename window " " 󰑕 " "hello"

new_name=$(read_input)
[ -z "$new_name" ] && exit

tmux rename-window "$new_name"

"$HOME/.local/scripts/tmux/toggle_pane_borders.sh"
