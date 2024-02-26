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
			[[info() { printf "%s\n" "$*"; }]],
			[[tostderr() { printf "%s\n" "$*" >&2; }]],
			[[# shellcheck disable=SC2120]],
			[[die() { [ -n "$*" ] && tostderr "$*"; exit 1; }]],
			[[assert_installed() { command -v "$1" &>/dev/null || die "$1 is not installed."; }]],
		})
	}),

	s("tmux_helpers", {
		t({
			[[istmux() { [ -n "$TMUX" ]; }]],
			[[talert() { tmux display -d 0 "#[bg=#{@color_info},fill=#{@color_info},fg=black] 󰭺 Message: $*"; }]],
			[[terror() { tmux display -d 0 "#[bg=#{@color_error},fill=#{@color_error},fg=black]  Message: $*"; }]],
			[[tsuccess() { tmux display -d 0 "#[bg=#{@color_success},fill=#{@color_success},fg=black]  Message: $*"; }]],
		})
	})
}, {}
