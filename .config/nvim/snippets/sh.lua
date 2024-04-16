return {
	s("shebang", {
		t("#! /usr/bin/env "),
		i(1, "bash"),
	}),

	s("bash", {
		t("#! /usr/bin/env bash"),
	}),

	s("ignore_question_mark", {
		t("# shellcheck disable=SC2181"),
	}),

	s("debug", {
		t('printf "%s" "$'),
		i(1),
		t('"'),
	}),

	s("helpers", {
		t({
			[[: # bash 5+ required]],
			[[# shellcheck disable=SC2120]],
			[[die() { [ -n "$*" ] && tostderr "$*"; exit 1; }]],
			[[info() { printf "%s\n" "$*"; }]],
			[[tostderr() { tput setaf 1 && printf "%s@%s: %s\n" "$0" "${BASH_LINENO[-2]}" "$*" >&2; tput sgr0; }]],
			[[assert_installed() { command -v "$1" &>/dev/null || die "$1 is not installed."; }]],
			[[assert_not_empty() { [ -z "${!1}" ] && die "$1 is empty when it shouldn't be."; }]],
			[[broken_pipe() { grep -vq "^[0 ]*$" <<< "${PIPESTATUS[*]}"; }]],
			[[termheight() { tput lines; }]],
			[[termwidth() { tput cols; }]],
		}),
	}),

	s("tmux_helpers", {
		t({
			[[istmux() { [ -n "$TMUX" ]; }]],
			[[talert() { tmux display -d 0 "#[bg=#{@color_info},fill=#{@color_info},fg=black] 󰭺 Message: $*"; }]],
			[[terror() { tmux display -d 0 "#[bg=#{@color_error},fill=#{@color_error},fg=black]  Message: $*"; }]],
			[[tsuccess() { tmux display -d 0 "#[bg=#{@color_success},fill=#{@color_success},fg=black]  Message: $*"; }]],
		}),
	}),

	s("opts", {
		t({
			[[while getopts "hs:p:" arg; do]],
			[[	case "$arg" in]],
			[[		p)]],
			[[			value="${OPTARG}"]],
			[[			;;]],
			[[		s)]],
			[[			value="${OPTARG}"]],
			[[			;;]],
			[[		h | *)]],
			[[			usage]],
			[[			exit 1]],
			[[  		;;]],
			[[	esac]],
			[[done]],
		}),
	}),
}, {}
