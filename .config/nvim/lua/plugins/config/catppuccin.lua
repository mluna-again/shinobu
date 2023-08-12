return {
	"catppuccin/nvim",
	name = "catppuccin",
  lazy = true,
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
