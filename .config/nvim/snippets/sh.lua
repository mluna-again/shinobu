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
			[[# shellcheck disable=SC2120]],
			[[die() { [ -n "$*" ] && tostderr "$*"; exit 1; }]],
			[[tostderr() { printf "%s\n" "$*" >&2; }]],
		})
	})
}, {}
