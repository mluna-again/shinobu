return {
	s("rcomp", {
		t("const "),
		i(1),
		t(" = ("),
		i(2),
		t({
			") => {",
			"",
		}),
		t("\t"),
		i(3),
		t({
			"",
			"}",
			"",
			"export default "
		}),
		d(4, function(args)
			return sn(nil, {
				i(1, args[1])
			})
		end,
		{1}
		)
	})
}, {}
