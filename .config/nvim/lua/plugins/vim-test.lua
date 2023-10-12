vim.cmd([[
let g:test#strategy = "neovim"
let g:test#neovim#start_normal = 1
]])
return {
	"vim-test/vim-test",
	dependencies = {
		"folke/which-key.nvim",
	},
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")

		wk.register({
			t = {
				r = {
					"<cmd>TestNearest<CR>",
					"Run test under cursor",
					silent = true,
					noremap = true,
				},
				R = {
					"<cmd>TestFile<CR>",
					"Run tests in current file",
					silent = true,
					noremap = true,
				},
				T = {
					"<cmd>TestSuite<CR>",
					"Run all tests in current project",
					silent = true,
					noremap = true,
				},
				name = "Testing",
			},
		}, { prefix = "<Leader>" })
	end,
}
