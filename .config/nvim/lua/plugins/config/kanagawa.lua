return {
	"rebelot/kanagawa.nvim",
	config = function ()
		require("kanagawa").setup({
		})

		vim.cmd("colorscheme kanagawa")
	end
}
