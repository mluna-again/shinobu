#! /usr/bin/env bash

THEMES="$(
cat - <<EOF
Kanagawa Dragon
Kanagawa Wave
Yoru
Rosé Pine
Gruvbox
Catppuccin
Dracula
Everforest
EOF
)"

RESULTS_FILE="$HOME/.cache/.shift_command_result"

SESSIONS_PATH="$HOME/.cache/shift_sessions"
[ ! -d "$SESSIONS_PATH" ] && mkdir "$SESSIONS_PATH"

BUDGET_FILE="$HOME/Notes/budget.sc"

LOCAL_SCRIPTS_FOLDER="$HOME/.local/custom_scripts"

orientations="$(cat - <<EOF
Horizontal
Vertical
EOF
)"

commands="$(cat - <<EOF
Notes: fuzzy find
Cleanup: clear panes
Cleanup: terminate processes and clear panes
Kill: processes
Kill: window
Kill: session
Swap: pane
Layouts: Even-Horizontal
Layouts: Even-Vertical
Layouts: Tiled
Layouts: Main-Horizontal
Layouts: Main-Vertical
Layouts: Make grid
Reorder: Running programs first
Panes: Close all but focused one
Destroy: server
Detach: client
Load: session
Send: command to panes
Time: clock
Theme: choose colorscheme
Run: Local script
Borders: Toggle for current window
Helper: Open HTTP session
Helper: Open Database session (SQL)
Reload: configuration
Alert: print message
EOF
)"

input() {
	local title
	local icon
	local input
	local mode
	rm "$RESULTS_FILE"

	title="$1"
	icon="$2"
	input="$3"
	mode="${4:-switch}"

	tmux display-popup -w 65 -h 11 -y 15 -E "[ -e \"$RESULTS_FILE\" ] && rm \"$RESULTS_FILE\" ; $HOME/.local/scripts/shift/shift -icon \"$icon\" -title \"$title\" -input \"$input\" -output \"$RESULTS_FILE\" -width 65 -height 9 -mode \"$mode\""
}

free_input() {
	local title
	local icon
	rm "$RESULTS_FILE"

	title="$1"
	icon="$2"

	tmux display-popup -w 65 -h 11 -y 15 -E "[ -e \"$RESULTS_FILE\" ] && rm \"$RESULTS_FILE\" ; $HOME/.local/scripts/shift/shift -icon \"$icon\" -title \"$title\" -input '\n' -output \"$RESULTS_FILE\" -width 65 -height 9 -mode rename"
}

alert() {
	tmux display-message -d 0 " 󰭺 Message: $1"
}

read_input() {
	tail -1 "$RESULTS_FILE"
}

send_keys_to_nvim() {
	tmux list-panes -a -F "#{pane_id} #{pane_current_command}" |\
		grep -i nvim |\
		awk '{print $1}' |\
		xargs -I{} -n1 tmux send-keys -t {} Escape Escape : colorscheme Space "$1" Enter
}

modify_nvim_and_alacritty() {
	command -v yq &>/dev/null || { alert "yq is required to run this action!"; exit 1; }

	yq -i ".import[0] = \"~/.config/alacritty/themes/$1.yml\"" "$HOME/.config/alacritty/alacritty.yml" || true

	# -_-
	if uname | grep -i darwin &>/dev/null; then
		sed -i '' "s/^vim.cmd(\"colorscheme.*/vim.cmd(\"colorscheme $1\")/" "$HOME/.config/nvim/lua/config/init.lua" || true
	else
		sed -i "s/^vim.cmd(\"colorscheme.*/vim.cmd(\"colorscheme $1\")/" "$HOME/.config/nvim/lua/config/init.lua" || true
	fi

	[ ! -d "$HOME/.config/shift" ] && mkdir "$HOME/.config/shift"
	echo "$1" > "$HOME/.config/shift/theme"
}

current_program() {
	tmux list-panes -F "#{pane_current_command} #{pane_id} #{pane_current_path} #{pane_active}" | awk '$4 == 1' | head -1
}

is_nvim_open() {
	program=$(current_program | awk '{ print $1 }')
	grep -i nvim <<< "$program" &>/dev/null
}

input " Command Palette " " 󰘳 " "$commands"

case "$(read_input)" in
	"Load: session")
		command -v tmuxp &>/dev/null || {
			alert "tmuxp is not installed!"
			exit
		}
		sessions=$(find "$SESSIONS_PATH" -type f -or -type l | sed "s|^$SESSIONS_PATH/||")
		input " Choose session " "  " "${sessions:-No sessions}"
		session_name=$(read_input)
		session_path="$SESSIONS_PATH/$session_name"

		[  "$session_name" = "No sessions" ] && exit
		[ ! -e "$RESULTS_FILE" ] && exit

		[ -L "$session_path" ] && session_path=$(readlink "$session_path")
		session_name_without_extension=$(sed "s/.yml$//" <<< "$session_name")

		if tmux list-sessions | grep -i "$session_name_without_extension" &>/dev/null; then
			tmux switch-client -t "$session_name_without_extension"
		else
			tmuxp load -s "$session_name_without_extension" -d "$session_path" >/dev/null && \
				tmux switch-client -t "$session_name_without_extension"
		fi
		;;

	"Notes: fuzzy find")
		[ ! -e "$BUDGET_FILE" ] && touch "$BUDGET_FILE"

		tmux display-popup -w "65" -h "11" -y 15 -E "[ -e \"$RESULTS_FILE\" ] && rm \"$RESULTS_FILE\"; $HOME/.local/scripts/notes/notes.sh \"$RESULTS_FILE\""
		[ ! -e "$RESULTS_FILE" ] && exit
		file="$(cat "$RESULTS_FILE")"

		if grep -i "budget" <<< "$file" &>/dev/null; then
			tmux display-popup -b heavy -S fg=yellow -w "80%" -h "80%" -E "sc-im \"$BUDGET_FILE\""
		else
			[ -z "$file" ] && exit
			tmux display-popup -b heavy -S fg=yellow -w "80%" -h "80%" -E "nvim \"$file\""
		fi
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
		cmd=$(read_input)
		[ -z "$cmd" ] && exit
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

	"Time: clock")
		tmux clock-mode
		;;

	"Layouts: Even-Vertical")
		tmux select-layout even-vertical
		tmux swap-pane -s . -t 1
		tmux select-pane -t 1
		;;

	"Layouts: Even-Horizontal")
		tmux select-layout even-horizontal
		tmux swap-pane -s . -t 1
		tmux select-pane -t 1
		;;

	"Layouts: Main-Vertical")
		tmux select-layout main-vertical
		tmux swap-pane -s . -t 1
		tmux select-pane -t 1
		;;

	"Layouts: Main-Horizontal")
		tmux select-layout main-horizontal
		tmux swap-pane -s . -t 1
		tmux select-pane -t 1
		;;

	"Layouts: Tiled")
		tmux select-layout tiled
		tmux swap-pane -s . -t 1
		tmux select-pane -t 1
		;;

	"Layouts: Make grid")
		free_input " Size " " 󱗼 " "hello"
		size=$(read_input)
		[ -z "$size" ] && exit
		sequence="$(seq 1 "$size")"
		[ -z "$sequence" ] && exit # not a number
		sequence="$(seq 1 $(( size - 1 )))"
		for _ in $sequence; do
			tmux split-window
			tmux select-layout tiled
		done
		tmux select-layout tiled
		tmux list-panes -F "#{pane_id}" |\
			xargs -I{} -n1 tmux send-keys -t {} C-l
		tmux select-pane -t 1
		;;

	"Panes: Close all but focused one")
		active=$(tmux list-panes -F '#{pane_id} #{pane_active}' | awk '$2 == 1 { print $1 }')
		tmux kill-pane -a -t "$active"
		;;

	"Swap: pane")
		panes="$(tmux list-panes -F '#{pane_index} #{pane_title} #{pane_current_command}')"
		input " Destination " "  " "$panes"
		target="$(read_input | awk '{print $1}')"
		tmux swap-pane -s . -t "$target"
		tmux select-pane -t "$target"
		;;

	"Reorder: Running programs first")
		panes=$(
		tmux list-panes -F "#{pane_current_command} #{pane_id}" | \
			grep -iv "^zsh$" | \
			grep -iv "^fish$" | \
			grep -iv "^bash$" | \
			awk '{print $2}'
		)
		counter=1
		for _ in $panes; do
			tmux swap-pane -t "$counter"
			counter=$((counter + 1))
		done
		tmux select-pane -t 1
		;;

	"Run: Local script")
		[ -d "$LOCAL_SCRIPTS_FOLDER" ] || mkdir "$LOCAL_SCRIPTS_FOLDER"
		files=$(find "$LOCAL_SCRIPTS_FOLDER" -type f -iname "*.sh")
		trimmed_files=$(sed "s|$LOCAL_SCRIPTS_FOLDER/||g" <<< "$files")
		[ -z "$files" ] && {
			free_input " Script to run " "  " ""
			exit
		}

		input " Script to run " "  " "$trimmed_files"
		[ -z "$files" ] && exit

		file=$(read_input)
		[ -z "$file" ] && exit

		file="$LOCAL_SCRIPTS_FOLDER/$file"
		[ -x "$file" ] || {
			alert "File is not executable!"
			exit
		}
		tmux display-popup -w "80%" -h "70%" -y 35 -b heavy -S fg=black,bg=black -s bg=black -EE "$file"

		[ "$?" -eq 0 ] && alert "Script ran successfully :)"

		true
		;;

	"Borders: Toggle for current window")
		current_ignored=$(
	grep '^ignored_windows' "$HOME/.local/scripts/tmux/toggle_pane_borders.sh" | \
		sed 's/^ignored_windows=//' | \
		sed "s/^'//" | \
		sed "s/'$//" | \
		jq .
		)
		current_window=$(tmux list-windows -F "#{window_active} #{window_name}" | awk '$1 == 1' | awk '{print $2}')

		arg=$(printf '. += ["%s"]' "$current_window")
		new_ignored=$(jq -c "$arg" <<< "$current_ignored")

		arg=$(printf '. as $f | "%s" | IN($f[])' "$current_window")
		res=$(jq "$arg" <<< "$current_ignored")
		if [ "$res" = true ]; then
			arg=$(printf '. - map(select(. | contains("%s")))' "$current_window")
			new_ignored=$(jq -c "$arg" <<< "$current_ignored")
		fi

		if uname | grep -i darwin &>/dev/null; then
			sed -i '' "s/^ignored_windows=.*\$/ignored_windows='$new_ignored'/" "$HOME/.local/scripts/tmux/toggle_pane_borders.sh"
		else
			sed -i "s/^ignored_windows=.*\$/ignored_windows='$new_ignored'/" "$HOME/.local/scripts/tmux/toggle_pane_borders.sh"
		fi

		"$HOME/.local/scripts/tmux/toggle_pane_borders.sh"
		;;

	"Helper: Open HTTP session")
		input " Orientation " " 󰞁 " "$orientations"
		orientation=$(read_input)
		[ -z "$orientation" ] && exit

		program=$(current_program | awk '{ print $1 }')
		cwd=$(current_program | awk '{ print $3 }')
		if [ "$orientation" = Horizontal ]; then
			tmux rename-window api
			tmux split-window -h -c "$cwd"
			tmux split-window -v -c "$cwd"
			tmux select-pane -U
			tmux resize-pane -D 10
			tmux send-keys -t . ihurl
			if grep -vi nvim <<< "$program" &>/dev/null; then
				tmux select-pane -R
				tmux send-keys -t . nvim Enter
			fi
		else
			tmux rename-window api
			if grep -vi nvim <<< "$program" &>/dev/null; then
				tmux select-pane -t 1
				tmux send-keys -t . nvim Enter
			fi
			tmux split-window -v -c "$cwd"
			tmux split-window -v -c "$cwd"
			tmux select-pane -t 2
			tmux send-keys -t . ihurl
			tmux select-pane -t 1
			tmux select-layout even-vertical
		fi
		;;

	"Helper: Open Database session (SQL)")
		is_nvim_open || {
			tmux rename-window db
			tmux send-keys -t . nvim Space -c Space "DBUI" Enter
			exit
		}

		true
		;;

	"Reload: configuration")
		tmux source-file "$HOME/.tmux.conf"
		alert "Reloaded!"
		;;

	"Alert: print message")
		free_input " Message " " 󰭺 " "hello"
		alert "$(read_input)"
		;;

	"Theme: choose colorscheme")
		input " Choose colorscheme " " 󰏘 " "$THEMES"
		case "$(read_input)" in
			"Kanagawa Dragon")
				tmux set -g @components_active_background1 yellow
				tmux set -g @components_active_background2 red
				tmux set -g @components_active_background3 blue
				send_keys_to_nvim "kanagawa-dragon"
				modify_nvim_and_alacritty kanagawa-dragon
				;;

			"Kanagawa Wave")
				tmux set -g @components_active_background1 yellow
				tmux set -g @components_active_background2 orange
				tmux set -g @components_active_background3 blue
				send_keys_to_nvim "kanagawa-wave"
				modify_nvim_and_alacritty kanagawa-wave
				;;

			"Everforest")
				tmux set -g @components_active_background1 green
				tmux set -g @components_active_background2 red
				tmux set -g @components_active_background3 yellow
				send_keys_to_nvim "everforest"
				modify_nvim_and_alacritty everforest
				;;

			"Gruvbox")
				tmux set -g @components_active_background1 orange
				tmux set -g @components_active_background2 red
				tmux set -g @components_active_background3 blue
				send_keys_to_nvim "gruvbox-material"
				modify_nvim_and_alacritty gruvbox-material
				;;

			"Catppuccin")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				send_keys_to_nvim "catppuccin"
				modify_nvim_and_alacritty catppuccin
				;;

			"Rosé Pine")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				send_keys_to_nvim "rose-pine"
				modify_nvim_and_alacritty rose-pine
				;;

			"Yoru")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				send_keys_to_nvim "yoru"
				modify_nvim_and_alacritty yoru
				;;

			"Dracula")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				send_keys_to_nvim "dracula"
				modify_nvim_and_alacritty dracula
				;;
		esac
		;;
esac
