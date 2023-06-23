return {
	"rcarriga/nvim-notify",
	config = function ()
		vim.opt.termguicolors = true
		require("notify").setup({
			stages = "slide",
			timeout = 2500,
		})
	end
}
