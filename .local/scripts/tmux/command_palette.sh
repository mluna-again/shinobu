#! /usr/bin/env bash

RESULTS_FILE="$HOME/.cache/.shift_command_result"
CACHE_PATH="$HOME/.cache/.i_dont_know_how_to_program_and_my_code_should_be_illegal"

commands="$(cat - <<EOF
Notes
Send Ctrl-L to all panes
EOF
)"

tmux display-popup -w 65 -h 11 -y 15 -E "[ -e \"$RESULTS_FILE\" ] && rm \"$RESULTS_FILE\" ; $HOME/.local/scripts/shift/shift -icon ' 󰘳 ' -title ' Command Palette ' -input \"$commands\" -output \"$RESULTS_FILE\" -width 65 -height 9"

case "$(tail -1 "$RESULTS_FILE")" in
	Notes)
		tmux display-popup -w "65" -h "11" -y 15 -E "$HOME/.local/scripts/notes/notes.sh"
		[ ! -e "$CACHE_PATH" ] && exit # no note selected
		tmux display-popup -b heavy -S fg=yellow -w "80%" -h "80%" -E "$HOME/.local/scripts/tmux/selectedcmd.sh"
		;;

	"Send Ctrl-L to all panes")
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} C-l
		;;
esac
