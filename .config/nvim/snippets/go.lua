return {
	s("die", {
		t({ "os.Exit(1)", "return" }),
		i(1),
	}),

	s("edie", {
		t({
			"if err != nil {",
			"\tfmt.Println(err.Error())",
			"\tos.Exit(1)",
			"\treturn",
			"}",
		}),
		i(1),
	}),

	s("iferr", {
		t({
			"if err != nil {",
			"\treturn",
		}),
		i(1),
		t({
			"",
			"}",
		}),
	}),

	s("main", {
		t({
			"package main",
			"",
			"func main() {",
			"\t",
		}),
		i(1),
		t({
			"",
			"}",
		}),
	}),

	s("handler", {
		t("func "),
		i(1),
		t({
			"Handler(w http.ResponseWriter, r *http.Request) {",
			"\t",
		}),
		i(2),
		t({
			"",
			"}",
		}),
	}),

	s("logerr", {
		t('fmt.Fprintf(os.Stderr, "'),
		i(1),
		t({
			': \\n%v", err)',
		}),
	}),

	s("prettydate", {
		t({
			"t := time.Now()",
			't.Format("Monday 02, January 2006 at 03:04 pm")',
		})
	})
}, {}
