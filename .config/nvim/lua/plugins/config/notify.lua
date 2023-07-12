return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	config = function ()
		vim.opt.termguicolors = true
		local notify = require("notify")
		notify.setup({
			stages = "slide",
			timeout = 2500,
			render = "compact",
			-- level = vim.log.levels.INFO,
			max_width = 80,
			min_width = 80
		})
	end
}
