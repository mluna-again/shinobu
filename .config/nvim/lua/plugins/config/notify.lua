return {
	"rcarriga/nvim-notify",
	config = function ()
		vim.opt.termguicolors = true
		require("notify").setup()
	end
}
