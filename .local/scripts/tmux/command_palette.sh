#! /usr/bin/env bash

BOP_PORT=8888

WALLPAPERS="$HOME/.local/walls"

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

BORDERS_CACHE_FILECACHE="$HOME/.cache/toggle_borders.sh"
[ -f "$BORDERS_CACHE_FILECACHE" ] || touch "$BORDERS_CACHE_FILECACHE"

orientations="$(cat - <<EOF
Horizontal
Vertical
EOF
)"

commands="$(cat - <<EOF
Notes: fuzzy find
TODO: open
TODO: search by tag
Cleanup: clear panes
Cleanup: clear ALL panes
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
Layouts: terminal bottom
Spotify: search
Spotify: play/pause
Spotify: next song
Spotify: previous song
Spotify: restart song
Spotify: get song
Spotify: queue
Spotify: bop queue
Spotify: save song
Spotify: delete song
Spotify: set device
Spotify: toggle repeat
Panes: Close all but focused one
Destroy: server
Detach: client
Load: session
Send: command to panes
Time: show
Theme: choose colorscheme
Run: Local script
Run: projects in current window
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
Tmux: floating terminal
Tmux: block outer session
Tmux: join panes
Tmux: split panes
Tmux: new window to the left
Tmux: new window to the right
Tmux: welcome screen
Clipboard: push
Clipboard: pop
Lol: wake up
Monitor: open dashboard
Dumb: screen-saver
System: volume
Dotfiles: status
Dotfiles: pull
Cheatsheet: select and copy
Alacritty: toggle opacity
Wezterm: toggle background
Wezterm: choose background
Food: add entry
Food: add custom entry
Food: total today
Food: reset today's entries
Food: report
Food: delete entry
Food: add recipe
EOF
)"

universal_sed() {
	local file="$2" exp="$1"
	if uname | grep -iq darwin; then
		if ! command -v gsed &>/dev/null; then
			error "Please install gnu-sed"
			exit
		fi
		gsed -i "$exp" "$file"
	else
		sed -i "$exp" "$file"
	fi
}

top_right_pane() {
	tmux list-panes -F "#{pane_index} #{pane_at_top} #{pane_at_right}" | \
		awk '$2 == 1 && $3 == 1 { print $1 }'
}

make_popup_border() {
	local title
	local icon
	title="$1"
	icon="${2:-󰂞}"

	echo "#[bg=#{@components_active_background1},fg=black] $icon $title "
}

# returns 16 if there was only one device and it was autoselected. just because
select_bop_device() {
	code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$BOP_PORT/status")
	if [ "$code" = 404 ] || [ "$1" = force ]; then
		devs=$(curl -Ssf "http://localhost:$BOP_PORT/devices") || {
			error "Something went wrong while fetching devices."
			exit
		}

		[ -z "$devs" ] || (( "$(jq 'length' <<< "$devs")" < 1 )) && {
			error "No devices found."
			exit
		}

		devices=$(jq -r '.[] | "[\(.type)] \(.name)"' <<< "$devs" | awk '{ printf "%d. %s\n", NR, $0; }')
		if [ "$(wc -l <<< "$devices")" -eq 1 ]; then
			dev_id=$(jq -r ".[0].id" <<< "$devs")
			curl -X POST -Ssf "http://localhost:$BOP_PORT/setDevice" -d "{\"id\": \"$dev_id\", \"play\": false}" &>/dev/null || {
				error "Something went wrong while setting device."
				return 1
			}
			return 16
		fi

		input " Choose device " "  " "$devices"
		device=$(read_input)
		[ -z "$device" ] && exit
		index=$(awk '{ print $1 }' <<< "$device" | sed 's/[^0-9]//g')
		dev_id=$(jq -r ".[$((index - 1))].id" <<< "$devs")
		[ -z "$dev_id" ] && {
			error "Something is not right (device ID not in response)."
			exit
		}

		curl -X POST -Ssf "http://localhost:$BOP_PORT/setDevice" -d "{\"id\": \"$dev_id\", \"play\": false}" &>/dev/null || {
			error "Something went wrong while setting device."
			exit
		}
	fi
}

try_to_wake_bop() {
	if [ ! -f "$HOME/.cache/bop"  ] || [ "$(cat "$HOME/.cache/bop" | wc -l)" -lt 2 ]; then
		error "Missing credentials. Read bop's README."
		return 1
	fi

	bop_response=$(curl -is http://localhost:8888/health)
	# no server running
	if [ "$?" -eq 7 ]; then
		nohup fish -c "start_bop" &>"$HOME/.cache/bop_logs" &
		tries=0
		while ! pgrep bop &>/dev/null; do
			if [ "$tries" -ge 5 ]; then
				break
			fi

			tries=$(( tries + 1 ))
			sleep 1
		done

		link=$(cat "$HOME/.cache/bop_logs" | grep -i "^https" | head -1)
		if [ -n "$link" ]; then
			if [ -z "$DISPLAY" ] && uname | grep -iq linux; then
				error "No DISPLAY env variable, are you connected through SSH? Login manually please :)"
				return 1
			fi

			if uname | grep -iq darwin; then
				open "$link"
			else
				nohup firefox --new-tab --url "$link" &>/dev/null &
				disown
			fi
			sleep 2
		fi

		return
	fi

	bop_status=$(awk 'NR==1 { print $2 }' <<< "$bop_response")

	case "$bop_status" in
		403)
			alert "You haven't logged in yet."
			return 1
			;;

		200)
			;;

		*)
			error "Looks like something else besides bop is running on port $BOP_PORT."
			return 1
			;;
	esac

	# handle no device active
	if [ "$1" != "--no-select" ]; then
		select_bop_device
		status="$?"
		if [ "$status" -eq 16 ]; then
			# give bop some time to catch up
			sleep 2
			return 0
		fi
		[ "$status" -ne 0 ] && exit 0
		return 0
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
	local history_id
	rm "$RESULTS_FILE"

	title="$1"
	icon="$2"
	input="$3"
	mode="${4:-switch}"
	history_id="${5:-tmux_palette}"

	tmux display-popup -w 65 -h 11 -y 15 -E "[ -e \"$RESULTS_FILE\" ] && rm \"$RESULTS_FILE\" ; mshift -icon \"$icon\" -title \"$title\" -input \"$input\" -output \"$RESULTS_FILE\" -width 65 -height 9 -mode \"$mode\" -history \"$history_id\""
}

free_input() {
	local title
	local icon
	local history_id
	rm "$RESULTS_FILE"

	title="$1"
	icon="$2"
	history_id="${3:-tmux_palette}"

	tmux display-popup -w 65 -h 11 -y 15 -E "[ -e \"$RESULTS_FILE\" ] && rm \"$RESULTS_FILE\" ; mshift -icon \"$icon\" -title \"$title\" -input '\n' -output \"$RESULTS_FILE\" -width 65 -height 9 -mode rename -history \"$history_id\""
}

alert() {
	tmux display-message -d 0 "#[bg=#{@color_info},fill=#{@color_info},fg=black] 󰭺 Warning: $1"
}

success() {
	tmux display-message -d 0 "#[bg=#{@color_success},fill=#{@color_success},fg=black]  Message: $1"
}

error() {
	tmux display-message -d 0 "#[bg=#{@color_error},fill=#{@color_error},fg=black]  Error: $1"
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

_modify_nvim_and_alacritty_err() {
	error "Something went wrong while uploading color scheme."
	exit
}

modify_alacritty_nvim_and_wezterm() {
	universal_sed "s/^vim.cmd(\"colorscheme.*/vim.cmd(\"colorscheme $1\")/" "$HOME/.config/nvim/lua/config/init.lua" || _modify_nvim_and_alacritty_err
	universal_sed "s|~/.config/alacritty/themes/.*]|~/.config/alacritty/themes/$1.toml\"]|" "$HOME/.config/alacritty/alacritty.toml" || _modify_nvim_and_alacritty_err
	universal_sed "s|~/.config/alacritty/themes/.*]|~/.config/alacritty/themes/$1.toml\"]|" "$HOME/.config/alacritty/alacritty_linux.toml" || _modify_nvim_and_alacritty_err
	# TODO: wezterm, i just have kanagawa at the moment

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
	local code
	code="$2"
	if [ "$code" = 28 ]; then
		error "Timeout."
		exit
	fi

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
			if ! command -v sc-im &>/dev/null; then
				error "sc-im not installed."
				exit
			fi

			tmux display-popup -T "$(make_popup_border 'Budget' '')" -b heavy -S fg=white,bg=black -s bg=black -w "80%" -h "80%" -E "sc-im \"$BUDGET_FILE\""
		else
			[ -z "$file" ] && exit
			tmux display-popup -T "$(make_popup_border 'Notes' '󱞎')" -b heavy -S fg=white,bg=black -s bg=black -w "80%" -h "80%" -E "nvim -c 'hi NORMAL guibg=NONE' -c 'hi LineNr guibg=NONE' \"$file\""
		fi
		;;

	"TODO: open")
		[ -d "$NOTES_PATH" ] || mkdir "$NOTES_PATH"
		[ -e "$NOTES_PATH/todo" ] || touch "$NOTES_PATH/index.org"

		tmux display-popup -T "$(make_popup_border 'TODO' '')" -b heavy -S fg=white,bg=black -s bg=black -w "80%" -h "80%" -E "nvim -c 'hi NORMAL guibg=NONE' -c 'hi LineNr guibg=NONE' \"$NOTES_PATH/index.org\""

		true
		;;

	"TODO: search by tag")
		[ -d "$NOTES_PATH" ] || mkdir "$NOTES_PATH"
		[ ! -f "$NOTES_PATH/todo.md" ] || touch "$NOTES_PATH/todo.md"

		tags=$(grep -Eo '@\w*\w' "$NOTES_PATH/todo.md" | sort | uniq)
		if [ -z "$tags" ]; then
			alert "No tags found."
			exit
		fi

		input " Tags " "  " "$tags"
		response=$(read_input)

		todos=$(grep -E "$response" "$NOTES_PATH/todo.md" | sed 's/^\s*\*\s*//' | awk '{printf "%d. %s\n", NR, $0}')

		tmux display-popup -w 40 -h 25 -t "$(top_right_pane)" -x "#{popup_pane_right}" -y "#{popup_pane_top}" -s bg=black echo "$todos"
		;;

	"Cleanup: clear ALL panes")
		original_window=$(tmux display-message -p "#{window_id}")
		for window in $(tmux list-windows -F "#{window_id}"); do
			tmux switch-client -t "$window"
			for pane in $(tmux list-panes -F "#{pane_index}" -t "$window"); do
				tmux send-keys -t "$pane" C-l
			done
		done
		tmux switch-client -t "$original_window"
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

	"Layouts: terminal bottom")
		size="25%"
		pane_count=$(tmux display -p "#{window_panes}")
		if (( pane_count > 2 )); then
			error "Too many panes"
			exit
		fi

		if (( pane_count == 1 )); then
			tmux split-window -t . -v -l "$size" -c "#{pane_current_path}"
			exit
		fi

		tmux select-layout even-vertical
		tmux select-pane -t 2
		tmux resize-pane -t . -y "$size"
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
		free_input " Size " " 󱗼 "
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

	"Run: Local script")
		[ -d "$LOCAL_SCRIPTS_FOLDER" ] || mkdir "$LOCAL_SCRIPTS_FOLDER"
		files=$(find "$LOCAL_SCRIPTS_FOLDER" -type f -iname "*.sh")
		trimmed_files=$(sed "s|$LOCAL_SCRIPTS_FOLDER/||g" <<< "$files")
		[ -z "$files" ] && {
			free_input " Script to run " "  "
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
		tmux display-popup -T "$(make_popup_border 'Runner' '')" -w "80%" -h "70%" -y 40 -b heavy -S fg=white,bg=black -s bg=black -EE "$file"

		if [ "$?" -eq 0 ]; then
			success "Script ran successfully :)"
		else
			error "Something went wrong!"
		fi

		true
		;;

	"Borders: Toggle for current window")
		current_ignored=$(jq . "$BORDERS_CACHE_FILECACHE")
		[ -z "$current_ignored" ] && current_ignored="[]"
		current_window=$(tmux list-windows -F "#{window_active} #{window_name}" | awk '$1 == 1' | awk '{print $2}')

		arg=$(printf '. += ["%s"]' "$current_window")
		new_ignored=$(jq -c "$arg" <<< "$current_ignored")

		arg=$(printf '. as $f | "%s" | IN($f[])' "$current_window")
		res=$(jq "$arg" <<< "$current_ignored")
		if [ "$res" = true ]; then
			arg=$(printf '. - map(select(. | contains("%s")))' "$current_window")
			new_ignored=$(jq -c "$arg" <<< "$current_ignored")
		fi

		echo "$new_ignored" > "$BORDERS_CACHE_FILECACHE"

		"$HOME/.local/scripts/tmux/toggle_pane_borders.sh"
		;;

	"Run: projects in current window")
		default_shell=$(basename "$SHELL")
		while read -r info; do
			current_cmd="$(awk '{print $3}' <<< "$info")"
			if [ "${current_cmd,,}" != "${default_shell,,}" ]; then
				continue
			fi

			pane=$(awk '{print $1}' <<< "$info")
			current_path_original=$(awk '{print $2}' <<< "$info")
			current_path=$(basename "$current_path_original")
			script_name="${current_path}.sh"

			if ! command -v "$script_name" &>/dev/null && [ ! -x "$current_path_original/__START__.sh" ]; then
				error "No script found for $current_path (you can put your scripts in ~/.local/bin or create a __START__.sh file in current dir)."
				exit
			fi

			[ -x "$current_path_original/__START__.sh" ] && script_name="./__START__.sh"
			tmux send-keys -t "$pane" "$script_name" Enter
		done < <(tmux list-panes -F "#{pane_index} #{pane_current_path} #{pane_current_command}")
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
		if ! command -v flock &>/dev/null; then
			error "flock not installed"
			exit
		fi

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
				free_input " Time " "  "
				time=$(read_input)
				nohup pomo start "$time" &>/dev/null &
				disown
				;;

			"15 minutes")
				nohup pomo start "15m" &>/dev/null &
				disown
				;;

			"25 minutes")
				nohup pomo start "25m" &>/dev/null &
				disown
				;;

			"1 hour")
				nohup pomo start "60m" &>/dev/null &
				disown
				;;
		esac

		true
		;;

	"Pomodoro: stop")
		nohup pomo stop &>/dev/null &
		disown
		;;

	"Pomodoro: pause")
		nohup pomo pause &>/dev/null &
		disown
		;;

	"Reload: configuration")
		tmux source-file "$HOME/.tmux.conf"
		success "Reloaded!"
		;;

	"Alert: success")
		free_input " Message " " 󰭺 "
		[ -z "$(read_input)" ] && exit
		success "$(read_input)"
		;;

	"Alert: information")
		free_input " Message " " 󰭺 "
		[ -z "$(read_input)" ] && exit
		alert "$(read_input)"
		;;

	"Alert: error")
		free_input " Message " " 󰭺 "
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

	"Tmux: welcome screen")
		"$HOME/.local/scripts/tmux/welcome/welcome.sh"
		;;

	"Tmux: new window to the left")
		tmux new-window -b -t .
		;;

	"Tmux: new window to the right")
		tmux new-window -a -t .
		;;

	"Tmux: set current directory as default")
		tmux attach-session -t . -c "#{pane_current_path}"
		true
		;;


	"Monitor: open dashboard")
		command -v btm &>/dev/null || { error "btm is not installed!" ; exit ; }
		tmux display-popup -T "$(make_popup_border 'Monitor' '')" -w "90%" -h "95%" -b heavy -S fg=white,bg=black -s bg=black -EE btm
		;;

	"Dumb: screen-saver")
		is_installed rusty-rain "rusty-rain is not installed!"

		tmux display-popup -w "100%" -h "99%" -y S -B -s bg=terminal -EE rusty-rain -C 230,195,132 -H 255,93,98 -s -c jap
		;;

	"Spotify: play/pause")
		try_to_wake_bop || exit 0
		try_shpotify pause && exit

		output=$(curl -X POST -sSf "http://localhost:8888/pause")
		code="$?"
		[ "$code" -ne 0 ] && {
			handle_no_device_spotify "$output" "$code"
		}

		true
		;;

	"Spotify: next song")
		try_to_wake_bop || exit 0
		try_shpotify next && exit

		output=$(curl -X POST -sSf "http://localhost:8888/next")
		code="$?"
		[ "$code" -ne 0 ] && {
			handle_no_device_spotify "$output" "$code"
		}

		true
		;;

	"Spotify: previous song")
		try_to_wake_bop || exit 0
		try_shpotify prev && exit

		output=$(curl -X POST -sSf "http://localhost:8888/prev")
		code="$?"
		[ "$code" -ne 0 ] && {
			handle_no_device_spotify "$output" "$code"
		}

		true
		;;

	"Spotify: restart song")
		try_to_wake_bop || exit 0
		try_shpotify restart && exit

		output=$(curl -X POST -sSf "http://localhost:8888/restart")
		code="$?"
		[ "$code" -ne 0 ] && {
			handle_no_device_spotify "$output" "$code"
		}

		true
		;;

	"Spotify: get song")
		try_to_wake_bop || exit 0

		tmux display-popup -t "$($top_right_pane)" -s bg=black -w "35%" -h "45%" -y "#{popup_pane_top}" -x "#{popup_pane_right}" -E "bop tui player"
		;;

	"Spotify: save song")
		try_to_wake_bop || exit 0

		# we delete it first so if the song its already liked it will appear at the top after liking it again
		output=$(curl -X POST -sSf -d '{"ID": ""}' "http://localhost:8888/removeFromLiked")
		code="$?"
		[ "$code" -ne 0 ] && {
			handle_no_device_spotify "$output" "$code"
			exit
		}

		output=$(curl -X POST -sSf -d '{"ID": ""}' "http://localhost:8888/addToLiked")
		code="$?"
		[ "$code" -ne 0 ] && {
			handle_no_device_spotify "$output" "$code"
			exit
		}

		success "Song saved."
		;;

	"Spotify: delete song")
		try_to_wake_bop || exit 0

		output=$(curl -X POST -sSf -d '{"ID": ""}' "http://localhost:8888/removeFromLiked")
		code="$?"
		[ "$code" -ne 0 ] && {
			handle_no_device_spotify "$output" "$code"
		}

		success "Song deleted."
		;;

	"Spotify: bop queue")
		try_to_wake_bop || exit 0

		tmux display-popup -T "$(make_popup_border 'Bop TUI' '󰄛')" -b heavy -S fg=white,bg=black -s bg=black -w "80%" -h "80%" -E "bop tui select"
		if [ "$?" -eq 0 ]; then
			try_shpotify next && exit

			output=$(curl -X POST -sSf "http://localhost:8888/next")
			code="$?"
			[ "$code" -ne 0 ] && {
				handle_no_device_spotify "$output" "$code"
			}

			true
		fi
		;;

	"Spotify: toggle repeat")
		try_to_wake_bop || exit 0
		output=$(curl -X POST -sSf "http://localhost:8888/repeat") || {
			error "Could not update repeat state."
			exit 0
		}
		new_state=$(jq .new_state <<< "$output")
		success "New repeat state to $new_state"
		;;

	"Spotify: queue")
		try_to_wake_bop || exit 0
		tmux display-popup -w "35%" -h "99%" -x "#{popup_pane_right}" -y "S" -s bg=black "bop tui queue"
		;;

	"Spotify: set device")
		try_to_wake_bop --no-select || exit 0
		select_bop_device force || exit 0
		;;

	"Spotify: search")
		try_to_wake_bop || exit 0

		free_input " Search by name " " 󰓇 " "spotify"
		song=$(read_input)
		[ -z "$song" ] && exit

		# if bop is not running then try without selection menu
		if pgrep bop &>/dev/null; then
			output=$(curl -sSf -d "{\"query\": \"$song\"}" "http://localhost:8888/search")
			code="$?"
			[ "$code" -ne 0 ] && {
				handle_no_device_spotify "$output" "$code"
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

		output=$(curl -X POST -sSf -d "{\"item\": \"$song_id\", \"type\": \"$type\"}" "http://localhost:8888/play")
		code="$?"
		[ "$code" -ne 0 ] && {
			handle_no_device_spotify "$output" "$code"
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

	"Dotfiles: pull")
		err=$(yadm pull 2>&1 >/dev/null)
		if [ "$?" -ne 0 ] || [ -n "$err" ]; then
			error "${err:-"Something went wrong!"}"
			exit
		fi

		tmux source-file "$HOME/.tmux.conf"
		success "Reloaded!"
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
		current=$(tmux display -p "#{@zen_mode}")
		if [ -z "$current" ]; then
			tmux set -g @zen_mode true
			touch "$HOME/.cache/tmux_zen_mode"
		else
			tmux set -g @zen_mode ""
			rm "$HOME/.cache/tmux_zen_mode" &>/dev/null || true
		fi
		;;

	"Tmux: floating terminal")
		tmux display-popup -T "$(make_popup_border 'Terminal' '')" -b heavy -S fg=white,bg=black -s bg=black -w "80%" -h "80%" -EE
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

	"Tmux: split panes")
		pane_count=$(tmux list-panes | wc -l)
		if [ "$pane_count" -le 1 ]; then
			error "Not enough panes."
			exit
		fi

		free_input " New window name " "  "
		name=$(read_input)
		[ -z "$name" ] && exit

		tmux break-pane -ad -n "$name"
		;;

	"Tmux: join panes")
		current="$(tmux display -p "#{window_name}")"
		panes="$(tmux list-windows -F '#{window_name}' | grep -v "$current")"
		items=$(awk '{ printf "%s: vertical\n%s: horizontal\n", $1, $1 }' <<< "$panes")
		input " Target " " 󰓾 " "$items"
		target=$(read_input)
		[ -z "$target" ] && exit

		window_name=$(awk -F ':' '{ print $1 }' <<< "$target" | xargs)
		mode=$(awk -F ':' '{ print $2 }' <<< "$target" | xargs)
		case "$mode" in
			vertical)
				mode="-h"
				;;

			horizontal)
				mode="-v"
				;;

			*)
				error "Invalid mode: $mode"
				exit
				;;
		esac

		tmux join-pane -t "$window_name" "$mode"
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
		if ! figlet -c hey &>/dev/null; then
			error "You have a weird version of figlet installed (no -c and -f support)."
			exit
		fi

		tmux display-popup -T "$(make_popup_border 'Message')" \
			-b heavy -S fg=white,bg=terminal -w "80%" -h "80%" -E "$HOME/.local/scripts/lol.sh 'WAKE UP!'"
		;;

	"Wezterm: toggle background")
		file="$HOME/.config/wezterm/wezterm.lua"
		line=$(grep -i "config.window_background_image\s*=" "$file")
		if [[ "$line" =~ ^--.*$ ]]; then
			universal_sed "s/--\s*config.window_background_image\s*=/config.window_background_image =/" "$file"
		else
			universal_sed "s/\s*config.window_background_image\s*=/-- config.window_background_image =/" "$file"
		fi
		;;

	"Wezterm: choose background")
		walls=$(find "$WALLPAPERS" -type f | sed "s|${WALLPAPERS}/||g")
		input " Choose background " " 󰸉 " "$walls"
		selection=$(read_input)
		universal_sed "s|^.*config.window_background_image\s*=.*$|config.window_background_image = string.format(\"%s/.local/walls/$selection\", os.getenv(\"HOME\"))|g" "$HOME/.config/wezterm/wezterm.lua"
		;;

	"Alacritty: toggle opacity")
		opacity=""
		config_file="$HOME/.config/alacritty/alacritty.toml"
		linux_config_file="$HOME/.config/alacritty/alacritty_linux.toml"

		if grep -iq "opacity[[:space:]]*=[[:space:]]1" "$config_file"; then
			opacity="0.85"
		else
			opacity="1"
		fi

		if uname | grep -iq darwin; then
			sed -i '' "s/opacity.*$/opacity = $opacity/" "$config_file"
			sed -i '' "s/opacity.*$/opacity = $opacity/" "$linux_config_file"
		else
			sed -i "s/opacity.*$/opacity = $opacity/" "$config_file"
			sed -i "s/opacity.*$/opacity = $opacity/" "$linux_config_file"
		fi
		;;

	"Food: add entry")
		"$HOME/.local/scripts/tmux/food.sh" add
		;;

	"Food: total today")
		"$HOME/.local/scripts/tmux/food.sh" total
		;;

	"Food: add custom entry")
		"$HOME/.local/scripts/tmux/food.sh" custom
		;;

	"Food: reset today's entries")
		"$HOME/.local/scripts/tmux/food.sh" reset
		;;

	"Food: report")
		"$HOME/.local/scripts/tmux/food.sh" report
		;;

	"Food: delete entry")
		"$HOME/.local/scripts/tmux/food.sh" delete
		;;

	"Food: add recipe")
		"$HOME/.local/scripts/tmux/food.sh" recipe
		;;

	"Clipboard: push")
		"$HOME/.local/scripts/tmux/clipboard.sh" push
		;;

	"Clipboard: pop")
		"$HOME/.local/scripts/tmux/clipboard.sh" pop
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
				modify_alacritty_nvim_and_wezterm kanagawa-dragon
				;;

			"Kanagawa Wave")
				tmux set -g @components_active_background1 yellow
				tmux set -g @components_active_background2 orange
				tmux set -g @components_active_background3 blue
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "kanagawa-wave"
				modify_alacritty_nvim_and_wezterm kanagawa-wave
				;;

			"Everforest")
				tmux set -g @components_active_background1 green
				tmux set -g @components_active_background2 red
				tmux set -g @components_active_background3 yellow
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "everforest"
				modify_alacritty_nvim_and_wezterm everforest
				;;

			"Gruvbox")
				tmux set -g @components_active_background1 orange
				tmux set -g @components_active_background2 red
				tmux set -g @components_active_background3 blue
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "gruvbox-material"
				modify_alacritty_nvim_and_wezterm gruvbox-material
				;;

			"Catppuccin")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "catppuccin"
				modify_alacritty_nvim_and_wezterm catppuccin
				;;

			"Rosé Pine")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "rose-pine"
				modify_alacritty_nvim_and_wezterm rose-pine
				;;

			"Yoru")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "yoru"
				modify_alacritty_nvim_and_wezterm yoru
				;;

			"Dracula")
				tmux set -g @components_active_background1 red
				tmux set -g @components_active_background2 blue
				tmux set -g @components_active_background3 yellow
				tmux set -g @components_active_background4 magenta
				send_keys_to_nvim "dracula"
				modify_alacritty_nvim_and_wezterm dracula
				;;
		esac
		;;
esac

"$HOME/.local/scripts/tmux/toggle_pane_borders.sh"
