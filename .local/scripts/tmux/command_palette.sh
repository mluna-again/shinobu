#! /usr/bin/env bash

RESULTS_FILE="$HOME/.cache/.shift_command_result"
CACHE_PATH="$HOME/.cache/.i_dont_know_how_to_program_and_my_code_should_be_illegal"

commands="$(cat - <<EOF
Notes
Clear panes
Terminate processes
Send command
EOF
)"

input() {
	local title
	local icon
	local input
	local mode

	title="$1"
	icon="$2"
	input="$3"
	mode="${4:-switch}"

	tmux display-popup -w 65 -h 11 -y 15 -E "[ -e \"$RESULTS_FILE\" ] && rm \"$RESULTS_FILE\" ; $HOME/.local/scripts/shift/shift -icon \"$icon\" -title \"$title\" -input \"$input\" -output \"$RESULTS_FILE\" -width 65 -height 9 -mode \"$mode\""
}

read_input() {
	tail -1 "$RESULTS_FILE"
}

input " Command Palette " " 󰘳 " "$commands"

case "$(read_input)" in
	Notes)
		tmux display-popup -w "65" -h "11" -y 15 -E "$HOME/.local/scripts/notes/notes.sh"
		[ ! -e "$CACHE_PATH" ] && exit # no note selected
		tmux display-popup -b heavy -S fg=yellow -w "80%" -h "80%" -E "$HOME/.local/scripts/tmux/selectedcmd.sh"
		;;

	"Clear panes")
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} C-l
		;;

	"Terminate processes")
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} C-c
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} C-c
		;;

	"Send command")
		input " Command to send " " 󰘳 " " " "rename"
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} "$(read_input)" Enter
		;;
esac
