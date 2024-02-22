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
			[[try() { local o; { o=$("$@" 2>&1) && echo "$o"; } || die "$o"; }]],
			[[die() { awk "BEGIN { print \"@ $0:\" } { printf \"\t%s\n\", \$0 }" <<< "$*" >&2; exit 1; }]],
			[[tostderr() { echo "$*" >&2; }]],
		})
	})
}, {}
