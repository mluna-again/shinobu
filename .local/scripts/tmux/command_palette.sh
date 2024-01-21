#! /usr/bin/env bash

BOP_PORT=8888

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

NOTES_PATH="$HOME/Notes"

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
TODOS: open
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
Spotify: search
Spotify: play/pause
Spotify: next song
Spotify: previous song
Spotify: restart song
Spotify: get song
Spotify: queue
Spotify: save song
Spotify: delete song
Panes: Close all but focused one
Destroy: server
Detach: client
Load: session
Send: command to panes
Time: show
Theme: choose colorscheme
Run: Local script
Borders: Toggle for current window
Helper: Open HTTP session
Helper: Open Database session (SQL)
Pomodoro: new
Pomodoro: stop
Pomodoro: pause
Reload: configuration
Alert: information
Alert: success
Alert: error
Window: reset
Resize: up
Resize: down
Resize: left
Resize: right
Tmux: set current directory as default
Tmux: move window to the left
Tmux: move window to the right
Tmux: zen mode
Tmux: floating terminal
Tmux: block outer session
Lol: wake up
Monitor: open dashboard
Dumb: screen-saver
System: volume
Dotfiles: status
Cheatsheet: select and copy
EOF
)"

try_to_wake_bop() {
	local error
	error=$(curl -sSf "http://localhost:$BOP_PORT/health" 2>&1)

	if [ "$?" -eq 0 ]; then
		return
	fi

	# no server running
	if grep -i "connection refused" <<< "$error"; then
		nohup fish -c "start_bop dev" &>"$HOME/.cache/bop_logs" &
		alert "Waking bop up..."
		sleep 3
		return
	fi

	# something is running, but probably not bop
	if [ -n "$error" ]; then
		error "Looks like something else besides bop is running on port $BOP_PORT."
		return 1
	fi
}

close_all_but_focused() {
	active=$(tmux list-panes -F '#{pane_id} #{pane_active}' | awk '$2 == 1 { print $1 }')
	tmux kill-pane -a -t "$active"
}

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
	tmux display-message -d 0 "#[bg=yellow,fill=yellow,fg=black] 󰭺 Warning: $1"
}

success() {
	tmux display-message -d 0 "#[bg=green,fill=green,fg=black]  Message: $1"
}

error() {
	tmux display-message -d 0 "#[bg=red,fill=red,fg=black]  Error: $1"
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
	command -v yq &>/dev/null || { error "yq is required to run this action!"; exit; }

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

is_installed() {
	command -v "$1" &>/dev/null || {
		shift
		error "$@"
		exit
	}
}

handle_no_device_spotify() {
	if grep -Fiq "no active device" <<< "$1"; then
		error "No device active."
	elif grep -Fiq "server says no (it's not ready)" <<< "$1"; then
		error "You haven't authenticated in bop yet."
	else
		error "Error while trying to connect to bop, is it running?"
	fi

	exit
}

# in macos let's try to use the native client because it's more feature
# rich, if not then i'll fallback to bop
try_shpotify() {
	uname | grep -iq darwin || return 1
	command -v spotify &>/dev/null || return 1
	[ -e "$HOME/.shpotify.cfg" ] || {
		alert "It looks like you don't have shpotify credentials set up."
		return 1
	}

	cmd="$1"

	case "$cmd" in
		pause)
			spotify pause &>/dev/null || return 1
			;;

		next)
			spotify next &>/dev/null || return 1
			;;

		prev)
			spotify prev &>/dev/null || return 1
			;;

		restart)
			spotify replay &>/dev/null || return 1
			;;

		status)
			output=$(spotify status)
			[ $? -ne 0 ] && return 1

			song=$(awk -F':' 'NR == 4 {print $2}' <<< "$output" | xargs)
			artist=$(awk -F':' 'NR == 2 {print $2}' <<< "$output" | xargs)

			[ -z "$song" ] && [ -z "$artist" ] && return 1

			success "$song by $artist"
			;;

		play)
			type="$2"
			item="$3"
			id="$4"

			item=$(sed 's/\[.*\] //' <<< "$item")

			case "$type" in
				album)
					if [ -n "$id" ]; then
						spotify play uri "spotify:album:$id" &>/dev/null || return 1
					else
						spotify play album "$item" &>/dev/null || return 1
					fi
					;;

				track)
					if [ -n "$id" ]; then
						spotify play uri "spotify:track:$id" &>/dev/null || return 1
					else
						spotify play "$item" &>/dev/null || return 1
					fi
					;;

				playlist)
					if [ -n "$id" ]; then
						spotify play uri "spotify:playlist:$id" &>/dev/null || return 1
					else
						spotify play list "$item" &>/dev/null || return 1
					fi
					;;

				*)
					error "Invalid item type."
					exit
					;;
			esac
			;;

		*)
			error "Invalid command."
			exit
			;;
	esac
}

action="$1"
[ -z "$action" ] && {
	input " Command Palette " " 󰘳 " "$commands"
	action=$(read_input)
}

case "$action" in
	"Load: session")
		command -v tmuxp &>/dev/null || {
			error "tmuxp is not installed!"
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
			tmux switch-client -t "$session_name_without_extension" && \
			alert "Session already exists. Switching to it."
		else
			tmuxp load -s "$session_name_without_extension" -d "$session_path" >/dev/null && \
				tmux switch-client -t "$session_name_without_extension" && \
				success "Session created."
		fi
		;;

	"Notes: fuzzy find")
		[ ! -e "$BUDGET_FILE" ] && touch "$BUDGET_FILE"

		tmux display-popup -w "65" -h "11" -y 15 -E "[ -e \"$RESULTS_FILE\" ] && rm \"$RESULTS_FILE\"; $HOME/.local/scripts/notes/notes.sh \"$RESULTS_FILE\""
		[ ! -e "$RESULTS_FILE" ] && exit
		file="$(cat "$RESULTS_FILE")"

		if grep -i "budget" <<< "$file" &>/dev/null; then
			tmux display-popup -b heavy -S fg=black,bg=black -s bg=black -w "80%" -h "80%" -E "sc-im \"$BUDGET_FILE\""
		else
			[ -z "$file" ] && exit
			tmux display-popup -b heavy -S fg=black,bg=black -s bg=black -w "80%" -h "80%" -E "nvim -c 'hi NORMAL guibg=NONE' -c 'hi LineNr guibg=NONE' \"$file\""
		fi
		;;

	"TODOS: open")
		[ -d "$NOTES_PATH" ] || mkdir "$NOTES_PATH"
		[ -e "$NOTES_PATH/todo" ] || touch "$NOTES_PATH/todo"

		tmux display-popup -b heavy -S fg=black,bg=black -s bg=black -w "80%" -h "80%" -E "nvim -c 'hi NORMAL guibg=NONE' -c 'hi LineNr guibg=NONE' \"$NOTES_PATH/todo\""

		true
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

	"Time: show")
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
		close_all_but_focused
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
			error "File is not executable!"
			exit
		}
		tmux display-popup -w "80%" -h "70%" -y 40 -b heavy -S fg=black,bg=black -s bg=black -EE "$file"

		if [ "$?" -eq 0 ]; then
			success "Script ran successfully :)"
		else
			error "Something went wrong!"
		fi

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

	"Pomodoro: new")
	lines=$(cat - <<EOF
15 minutes
25 minutes
1 hour
Custom timer
EOF
)
		input " Time " "  " "$lines"
		response=$(read_input)

		case "$response" in
			"Custom timer")
				free_input " Time " "  " "hello"
				time=$(read_input)
				output=$(pomo start "$time")
				if [ "$?" -ne 0 ]; then
					error "$output"
					exit
				fi
				;;

			"15 minutes")
				output=$(pomo start 15m)
				if [ "$?" -ne 0 ]; then
					error "$output"
					exit
				fi
				;;

			"25 minutes")
				output=$(pomo start 25m)
				if [ "$?" -ne 0 ]; then
					error "$output"
					exit
				fi
				;;

			"1 hour")
				output=$(pomo start 60m)
				if [ "$?" -ne 0 ]; then
					error "$output"
					exit
				fi
				;;
		esac

		tmux set -g status-interval 1
		true
		;;

	"Pomodoro: stop")
		pomo stop &>/dev/null
		( sleep 2; tmux set -g status-interval 5 ) &>/dev/null &
		;;

	"Pomodoro: pause")
		tmux set -g status-interval 1
		pomo pause &>/dev/null
		;;

	"Reload: configuration")
		tmux source-file "$HOME/.tmux.conf"
		success "Reloaded!"
		;;

	"Alert: success")
		free_input " Message " " 󰭺 " "hello"
		[ -z "$(read_input)" ] && exit
		success "$(read_input)"
		;;

	"Alert: information")
		free_input " Message " " 󰭺 " "hello"
		[ -z "$(read_input)" ] && exit
		alert "$(read_input)"
		;;

	"Alert: error")
		free_input " Message " " 󰭺 " "hello"
		[ -z "$(read_input)" ] && exit
		error "$(read_input)"
		;;

	"Window: reset")
		tmux select-layout tiled
		close_all_but_focused
		;;

	"Resize: up")
		tmux resize-pane -t . -U 5
		;;

	"Resize: down")
		tmux resize-pane -t . -D 5
		;;

	"Resize: left")
		tmux resize-pane -t . -L 10
		;;

	"Resize: right")
		tmux resize-pane -t . -R 10
		;;

	"Tmux: set current directory as default")
		tmux attach-session -t . -c "#{pane_current_path}"
		true
		;;


	"Monitor: open dashboard")
		command -v btm &>/dev/null || { error "btm is not installed!" ; exit ; }
		tmux display-popup -w "90%" -h "95%" -b heavy -S fg=black,bg=black -s bg=black -EE btm
		;;

	"Dumb: screen-saver")
		is_installed rusty-rain "rusty-rain is not installed!"

		tmux display-popup -w "100%" -h "99%" -y S -B -s bg=terminal -EE rusty-rain -C 230,195,132 -H 255,93,98 -s -c jap
		;;

	"Spotify: play/pause")
		try_to_wake_bop || exit
		try_shpotify pause && exit
		is_installed http "httpie is not installed!"

		output=$(http -Ib --check-status GET "http://localhost:8888/pause")
		[ "$?" -ne 0 ] && {
			handle_no_device_spotify "$output"
		}

		true
		;;

	"Spotify: next song")
		try_to_wake_bop || exit
		try_shpotify next && exit
		is_installed http "httpie is not installed!"

		output=$(http -Ib --check-status GET "http://localhost:8888/next")
		[ "$?" -ne 0 ] && {
			handle_no_device_spotify "$output"
		}

		true
		;;

	"Spotify: previous song")
		try_to_wake_bop || exit
		try_shpotify prev && exit
		is_installed http "httpie is not installed!"

		output=$(http -Ib --check-status GET "http://localhost:8888/prev")
		[ "$?" -ne 0 ] && {
			handle_no_device_spotify "$output"
		}

		true
		;;

	"Spotify: restart song")
		try_to_wake_bop || exit
		try_shpotify restart && exit
		is_installed http "httpie is not installed!"

		output=$(http -Ib --check-status GET "http://localhost:8888/restart")
		[ "$?" -ne 0 ] && {
			handle_no_device_spotify "$output"
		}

		true
		;;

	"Spotify: get song")
		try_to_wake_bop || exit
		is_installed http "httpie is not installed!"

		tmux display-popup -s bg=black -w "50%" -h "40%" -y "#{popup_pane_top}" -x "#{popup_pane_right}" -E "$HOME/.local/scripts/dashboard/spotify.sh"
		;;

	"Spotify: save song")
		try_to_wake_bop || exit
		is_installed http "httpie is not installed!"

		# we delete it first so if the song its already liked it will appear at the top after liking it again
		output=$(http -Ib --check-status POST "http://localhost:8888/removeFromLiked" ID="")
		[ "$?" -ne 0 ] && {
			handle_no_device_spotify "$output"
			exit
		}

		output=$(http -Ib --check-status POST "http://localhost:8888/addToLiked" ID="")
		[ "$?" -ne 0 ] && {
			handle_no_device_spotify "$output"
			exit
		}

		success "Song saved."
		;;

	"Spotify: delete song")
		try_to_wake_bop || exit
		is_installed http "httpie is not installed!"

		output=$(http -Ib --check-status POST "http://localhost:8888/removeFromLiked" ID="")
		[ "$?" -ne 0 ] && {
			handle_no_device_spotify "$output"
		}

		success "Song deleted."
		;;

	"Spotify: queue")
		try_to_wake_bop || exit
		is_installed http "httpie is not installed!"
		output=$(http -Ib --check-status GET "http://localhost:8888/queue")
		[ "$?" -ne 0 ] && {
			handle_no_device_spotify "$output"
		}

		items=$(jq -r '. | to_entries | .[] | "\(.key + 1). \(.value.display_name) by \(.value.artist)"' <<< "$output")
		items=$(awk '{ printf substr($0, 1, 37); if (length($0) > 37) { printf "..."; }; printf "\n"; }' <<< "$items")
		[ -z "$items" ] && {
			alert "No next item in queue."
			exit
		}

		message=$(printf "\n                  Queue                 \n\n%s" "$items")
		tmux display-popup -w 40 -h 25 -x "#{popup_pane_right}" -y "#{popup_pane_top}" -s bg=black echo "$message"

		true
		;;

	"Spotify: search")
		try_to_wake_bop || exit
		is_installed http "httpie is not installed!"

		free_input " Search by name " " 󰓇 " "hello"
		song=$(read_input)
		[ -z "$song" ] && exit

		# if bop is not running then try without selection menu
		if pgrep bop &>/dev/null; then
			output=$(http -Ib --check-status POST "http://localhost:8888/search" query="$song")
			code=$?
			[ "$code" -ne 0 ] && {
				handle_no_device_spotify "$output"
			}

			songs=$(jq -r '.[] | "\(.id) \(.display_name) by \(.artist)"' <<< "$output")
			songs_without_ids=$(awk '{ $1=""; print $0 }' <<< "$songs" | sed 's/^ //' | sed 's/"//g')

			[ -z "$songs_without_ids" ] && {
				alert "No matches found."
				exit
			}

			input " WHICH/ONE " " 󰓇 " "$songs_without_ids"

			response=$(read_input)
			[ -z "$response" ] && exit

			song_id=$(grep -Fi "$response" <<< "$songs" | head -1 | awk '{print $1}' | xargs)
			[ -z "$song_id" ] && exit
		else
			alert "Bop is offline. Using shpotify only."
		fi

		type=track
		grep -iq album <<< "$response" && type=album
		grep -iq playlist <<< "$response" && type=playlist

		try_shpotify play "$type" "${response:-$song}" "$song_id" && exit

		[ "$type" = playlist ] && {
			error "Playing playlists is a macOS-only feature for now :("
			exit
		}

		output=$(http -Ib --check-status POST "http://localhost:8888/play" item="$song_id" type="$type")
		[ "$?" -ne 0 ] && {
			handle_no_device_spotify "$output"
		}

		true
		;;

	"System: volume")
		uname | grep -iq darwin || {
			error "This cmd only works on macOS."
			exit
		}

		volume=$(osascript -e 'set ovol to output volume of (get volume settings)')
		tmux display-popup -E -x "#{popup_pane_right}" -y "#{popup_pane_top}" -h 3 -w 50 "$HOME/.local/scripts/orfeo/orfeo" -volume "$volume"
		;;

	"Dotfiles: status")
		yadm fetch origin
		count=$(yadm rev-list --left-right --count master...origin/master | awk '{print $2}')

		if [ "$count" -gt 0 ]; then
			alert "You are $count commit(s) behind master."
		else
			success "Everything is up to date :D"
		fi

		true
		;;


	"Tmux: move window to the left")
		tmux swap-window -t -1
		tmux select-window -t -1
		;;

	"Tmux: move window to the right")
		tmux swap-window -t +1
		tmux select-window -t +1
		;;

	"Tmux: zen mode")
		tmux set -g status
		;;

	"Tmux: floating terminal")
		tmux display-popup -b heavy -S fg=black,bg=black -s bg=black -w "80%" -h "80%" -EE
		;;

	"Tmux: block outer session")
		locked=$(tmux display-message -p "#{@lock_outer_session}")

		if [ "$locked" = "true" ]; then
			tmux set -g prefix C-x
			tmux bind C-x send-prefix

			tmux set -g @lock_outer_session false
		else
			tmux set -g prefix None
			tmux unbind -n C-x
			tmux unbind C-x

			tmux set -g @lock_outer_session true
		fi

		;;


	"Cheatsheet: select and copy")
		items=$(jq -r 'to_entries[].key' < "$HOME/.local/cheats/bash.json")
		input " Cheatsheet " "  " "$items"
		key=$(read_input)
		[ -z "$key" ] && exit
		cheat=$(jq -r ".\"${key}\"" < "$HOME/.local/cheats/bash.json")
		if [ -z "$cheat" ]; then
			error "'$cheat' doesn't exist."
			exit
		fi

		tmux send-keys -t . "$cheat"

		;;


	"Lol: wake up")
		tmux display-popup -T "#[bg=#{@components_active_background1},fg=black] 󰂞 Message " \
			-b heavy -S fg=white,bg=terminal -w "80%" -h "80%" -EE "$HOME/.local/scripts/lol.sh 'WAKE UP!'"
		;;

	"Theme: choose colorscheme")
		input " Choose colorscheme " " 󰏘 " "$THEMES"
		case "$(read_input)" in
			"Kanagawa Dragon")
				tmux set -g @components_active_background1 yellow
				tmux set -g @components_active_background2 red
				tmux set -g @components_active_background3 blue
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "kanagawa-dragon"
				modify_nvim_and_alacritty kanagawa-dragon
				;;

			"Kanagawa Wave")
				tmux set -g @components_active_background1 yellow
				tmux set -g @components_active_background2 orange
				tmux set -g @components_active_background3 blue
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "kanagawa-wave"
				modify_nvim_and_alacritty kanagawa-wave
				;;

			"Everforest")
				tmux set -g @components_active_background1 green
				tmux set -g @components_active_background2 red
				tmux set -g @components_active_background3 yellow
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "everforest"
				modify_nvim_and_alacritty everforest
				;;

			"Gruvbox")
				tmux set -g @components_active_background1 orange
				tmux set -g @components_active_background2 red
				tmux set -g @components_active_background3 blue
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "gruvbox-material"
				modify_nvim_and_alacritty gruvbox-material
				;;

			"Catppuccin")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "catppuccin"
				modify_nvim_and_alacritty catppuccin
				;;

			"Rosé Pine")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "rose-pine"
				modify_nvim_and_alacritty rose-pine
				;;

			"Yoru")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "yoru"
				modify_nvim_and_alacritty yoru
				;;

			"Dracula")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "dracula"
				modify_nvim_and_alacritty dracula
				;;
		esac
		;;
esac

"$HOME/.local/scripts/tmux/toggle_pane_borders.sh"
