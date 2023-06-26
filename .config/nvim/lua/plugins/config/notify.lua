return {
	"rcarriga/nvim-notify",
	config = function ()
		vim.opt.termguicolors = true
		local notify = require("notify")
		notify.setup({
			stages = "slide",
			timeout = 2500,
		})
	end
}