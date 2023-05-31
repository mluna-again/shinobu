return {
	"kyazdani42/nvim-web-devicons",
	config = function()
		require("nvim-web-devicons").setup({
			override = {
				lisp = {
					icon = "󰚀",
					color = "#bef5b2",
					name = "lisp",
				},
				cshtml = {
					icon = "",
					color = "#953dab",
					name = "razor",
				},
				rb = {
					icon = "",
					color = "#a91401",
					name = "ruby",
				},
				go = {
					icon = "",
					color = "#86D4DE",
					name = "go",
				},
			},
		})
	end,
}
