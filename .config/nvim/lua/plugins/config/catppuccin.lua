return {
	"catppuccin/nvim",
	name = "catppuccin",
	event = "VeryLazy",
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
		})
	end,
}
