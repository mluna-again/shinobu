#! /usr/bin/env bash

THEMES="$(
cat - <<EOF
Kanagawa Dragon
Kanagawa Wave
Everforest
Gruvbox
EOF
)"

RESULTS_FILE="$HOME/.cache/.shift_command_result"

SESSIONS_PATH="$HOME/.cache/shift_sessions"
[ ! -d "$SESSIONS_PATH" ] && mkdir "$SESSIONS_PATH"

commands="$(cat - <<EOF
Notes: fuzzy find
Cleanup: clear panes
Cleanup: terminate processes and clear panes
Kill: processes
Kill: window
Kill: session
Destroy: server
Detach: client
Load: session
Send: command to panes
Time: clock
Theme: choose colorscheme
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

alert() {
	tmux display-popup -w 65 -h 11 -y 15 echo "$@"
}

read_input() {
	tail -1 "$RESULTS_FILE"
	rm "$RESULTS_FILE"
}

send_keys_to_nvim() {
	tmux list-panes -a -F "#{pane_id} #{pane_current_command}" |\
		grep -i nvim |\
		awk '{print $1}' |\
		xargs -I{} -n1 tmux send-keys -t {} Escape Escape : colorscheme Space "$1" Enter
}

modify_nvim_and_alacritty() {
	command -v yq &>/dev/null || { alert "yq is required to run this action!"; exit 1; }

	yq -i ".import[0] = \"~/.config/alacritty/themes/$1.yml\"" "$HOME/.config/alacritty/alacritty.yml"
	sed -i '' "s/^vim.cmd(\"colorscheme.*/vim.cmd(\"colorscheme $1\")/" "$HOME/.config/nvim/lua/config/init.lua"
}

input " Command Palette " " 󰘳 " "$commands"

case "$(read_input)" in
	"Load: session")
		command -v tmuxp &>/dev/null || {
			tmux display-popup -w "65" -h "11" -y 15 echo "tmuxp is not installed!"
			exit
		}
		sessions=$(find "$SESSIONS_PATH" -type f -or -type l | sed "s|^$SESSIONS_PATH/||")
		input " Choose session " "  " "${sessions:-No sessions}"
		session_name=$(read_input)
		session_path="$SESSIONS_PATH/$session_name"

		[  "$session_name" = "No sessions" ] && exit
		[ ! -e "$RESULTS_FILE" ] && exit

		session_path=$(readlink "$session_path")
		session_name_without_extension=$(sed "s/.yml$//" <<< "$session_name")

		if tmux list-sessions | grep -i "$session_name_without_extension" &>/dev/null; then
			tmux switch-client -t "$session_name_without_extension"
		else
			tmuxp load -s "$session_name_without_extension" -d "$session_path" >/dev/null && \
				tmux switch-client -t "$session_name_without_extension"
		fi
		;;

	"Notes: fuzzy find")
		tmux display-popup -w "65" -h "11" -y 15 -E "[ -e \"$RESULTS_FILE\" ] && rm \"$RESULTS_FILE\"; $HOME/.local/scripts/notes/notes.sh \"$RESULTS_FILE\""
		[ ! -e "$RESULTS_FILE" ] && exit
		file="$(cat "$RESULTS_FILE")"
		[ -z "$file" ] && exit
		tmux display-popup -b heavy -S fg=yellow -w "80%" -h "80%" -E "nvim \"$file\""
		;;

	"Cleanup: clear panes")
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} C-l
		;;

	"Kill: processes")
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} C-c
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} C-c
		;;

	"Send: command to panes")
		input " Command to send " " 󰘳 " " " "rename"
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} "$(read_input)" Enter
		;;

	"Cleanup: terminate processes and clear panes")
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} C-c
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} C-c
		tmux list-panes -F "#{pane_index}" | xargs -I{} -n1 tmux send-keys -t {} C-l
		;;

	"Destroy: server")
		tmux kill-server
		;;

	"Kill: session")
		tmux kill-session
		;;

	"Detach: client")
		tmux detach
		;;

	"Kill: window")
		tmux kill-window
		;;

	"Time: now")
		tmux clock-mode
		;;

	"Theme: choose colorscheme")
		input " Choose colorscheme " " 󰏘 " "$THEMES"
		case "$(read_input)" in
			"Kanagawa Dragon")
				send_keys_to_nvim "kanagawa-dragon"
				modify_nvim_and_alacritty kanagawa-dragon
				;;

			"Kanagawa Wave")
				send_keys_to_nvim "kanagawa-wave"
				modify_nvim_and_alacritty kanagawa-wave
				;;

			"Everforest")
				send_keys_to_nvim "everforest"
				modify_nvim_and_alacritty everforest
				;;

			"Gruvbox")
				send_keys_to_nvim "gruvbox"
				modify_nvim_and_alacritty gruvbox
				;;
		esac
		;;
esac
