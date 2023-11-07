return {
	"norcalli/nvim-colorizer.lua",
	ft = {
		"css",
		"scss"
	},
	lazy = true,
	config = function()
		vim.cmd("set termguicolors")
		require("colorizer").setup({
			"!toggleterm",
		})
	end,
}
