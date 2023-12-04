return {
	s("log", {
		t({
			"require Logger",
			'Logger.debug("-----------------", ansi_color: :yellow)',
			"Logger.debug(inspect(",
		}),
		i(1),
		t({
			"), ansi_color: :yellow)",
			'Logger.debug("-----------------", ansi_color: :yellow)',
		}),
		i(2)
	}),

	s("pry", {
		t({
			"require IEx",
			"IEx.pry"
		})
	})
}, {}
