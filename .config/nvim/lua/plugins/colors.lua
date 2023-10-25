return {
	"norcalli/nvim-colorizer.lua",
	event = "InsertEnter",
	config = function()
		vim.cmd("set termguicolors")
		require("colorizer").setup({
			"!toggleterm",
		})
	end,
}
