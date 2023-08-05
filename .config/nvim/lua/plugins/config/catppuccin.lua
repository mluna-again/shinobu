return {
	"catppuccin/nvim",
	name = "catppuccin",
	event = "VeryLazy",
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			integrations = {
				noice = true,
				telescope = {
					enabled = true,
					style = "nvchad",
				},
			},
		})
	end,
}
