return {
	s("self", {
		t("my $self = shift;")
	}),

	s("arg", {
		t("my $"),
		i(1),
		t(" = shift;")
	}),

	s("retself", {
		t("return $self;")
	}),

	s("warnings", {
		t({
			"use strict;",
			"use warnings;"
		})
	})
}, {}
