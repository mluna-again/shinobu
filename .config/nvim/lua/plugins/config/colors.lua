return {
	"norcalli/nvim-colorizer.lua",
	event = "VeryLazy",
	config = function()
		vim.cmd("set termguicolors")
		require("colorizer").setup({
			"!toggleterm",
		})
	end,
}
