return {
	"rcarriga/nvim-notify",
	dependencies = {
		"folke/which-key.nvim",
	},
	event = "VeryLazy",
	config = function ()
		vim.opt.termguicolors = true
		local notify = require("notify")
		notify.setup({
			stages = "slide",
			timeout = 2500,
			render = "compact",
			level = vim.log.levels.WARN,
			max_width = 80,
			min_width = 80
		})

		local wk = require("which-key")
		wk.register({
			N = {
				function()
					require('telescope').extensions.notify.notify()
				end,
				"Open notifications",
				silent = true
			}
		}, {
			prefix = "<Leader>"
		})
	end
}
