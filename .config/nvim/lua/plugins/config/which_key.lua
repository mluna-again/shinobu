return {
	"folke/which-key.nvim",
	event = "User AlphaClosed",
	config = function()
		require("which-key").setup({})
	end,
}
