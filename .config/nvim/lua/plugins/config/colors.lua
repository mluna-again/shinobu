return {
	"norcalli/nvim-colorizer.lua",
	event = "User AlphaClosed",
	config = function()
		vim.cmd("set termguicolors")
		require("colorizer").setup({
			"!toggleterm",
		})
	end,
}
