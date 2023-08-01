#! /usr/bin/env bash

RESULTS_FILE="$HOME/.cache/.shift_command_result"

commands="$(cat - <<EOF
Notes
EOF
)"

tmux display-popup -w 65 -h 11 -y 15 -E "$HOME/.local/scripts/shift/shift -title ' Command Palette ' -input \"$commands\" -output \"$RESULTS_FILE\" -width 65 -height 9"

case "$(tail -1 "$RESULTS_FILE")" in
	Notes)
		tmux display-popup -w "65" -h "11" -y 15 -E "$HOME/.local/scripts/notes/notes.sh" \; \
			display-popup -b heavy -S fg=yellow -w "80%" -h "80%" -E "$HOME/.local/scripts/tmux/selectedcmd.sh"
		;;
esac
