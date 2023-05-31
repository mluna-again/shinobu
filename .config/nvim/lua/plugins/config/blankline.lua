return {
	"lukas-reineke/indent-blankline.nvim",
	config = function()
		vim.opt.list = true

		require("indent_blankline").setup({
			show_end_of_line = false,
			show_trailing_blankline_indent = false,
			filetype_exclude = {
				"dashboard",
				"dockerfile",
				"json",
				"WhichKey",
				"packer",
				"glowpreview",
				"",
				"TelescopePrompt",
				"TelescopeResults",
			},
		})
	end,
}
