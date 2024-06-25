#! /usr/bin/env bash

: # bash 5+ required
# shellcheck disable=SC2120
die() { [ -n "$*" ] && terror "$*"; exit 1; }
info() { printf "%s\n" "$*"; }
tostderr() { tput setaf 1 && printf "%s@%s: %s\n" "$0" "${BASH_LINENO[-2]}" "$*" >&2; tput sgr0; }
assert_installed() { command -v "$1" &>/dev/null || die "$1 is not installed."; }
broken_pipe() { grep -vq "^[0 ]*$" <<< "${PIPESTATUS[*]}"; }

istmux() { [ -n "$TMUX" ]; }
talert() { tmux display -d 0 "#[bg=#{@color_info},fill=#{@color_info},fg=black] 󰭺 Message: $*"; }
terror() { tmux display -d 0 "#[bg=#{@color_error},fill=#{@color_error},fg=black]  Message: $*"; }
tsuccess() { tmux display -d 0 "#[bg=#{@color_success},fill=#{@color_success},fg=black]  Message: $*"; }

if ! istmux; then
	tostderr "No TMUX detected."
fi

if uname | grep -iq linux; then
	assert_installed xclip
fi

if uname | grep -iq darwin; then
	assert_installed pbcopy
fi

declare OUTFILE="$HOME/.cache/.cornucopia" \
	DB="$HOME/.cache/.clipboard"

read_result() {
	tail -1 "$OUTFILE"
}

case "$1" in
	push)
		tmux display-popup -w 65 -h 11 -y 15 -E "$(
			cat - <<EOF
		echo "\n" |
			mshift \
			-title " Save snippet " \
			-icon " 󰉜 " \
			-width 65 \
			-height 9 \
			-output "$OUTFILE" \
			-mode create
EOF
		)"
		content="$(read_result)"
		[ -z "$content" ] && exit
		echo "$content" >> "$DB"
		;;

	pop)
		content=$(tail -1 "$DB")
		if [ -z "$content" ]; then
			talert "No content to pop."
			exit
		fi
		if uname | grep -iq darwin; then
			echo "$content" | pbcopy
			if broken_pipe; then
				terror "Something went wrong while copying to clipboard."
			fi
		else
			echo "$content" | xclip -selection clipboard
			if broken_pipe; then
				terror "Something went wrong while copying to clipboard."
			fi
		fi

		tail_=$(head -n -1 "$DB")

		if [ -z "$tail_" ]; then
			: > "$DB"
			exit
		fi
		echo "$tail_" > "$DB"
		;;

	*)
		die "Invalid action: $1"
		;;
esac
