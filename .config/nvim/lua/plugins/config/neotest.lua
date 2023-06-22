return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"jfpedroza/neotest-elixir",
	},
	event = "User AlphaClosed",
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-elixir"),
			},
		})

		local wk = require("which-key")
		wk.register({
			r = {
				function()
					require("neotest").run.run()
				end,
				"Run test under cursor",
				noremap = true,
				silent = true,
			},
			R = {
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				"Run test file",
				noremap = true,
				silent = true,
			},
			T = {
				function()
					require("neotest").run.run({ suite = true })
				end,
				"Run test file",
				noremap = true,
				silent = true,
			},
		}, { prefix = "<Leader>" })
	end,
}
