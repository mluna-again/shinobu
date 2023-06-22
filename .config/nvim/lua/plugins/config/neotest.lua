return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"jfpedroza/neotest-elixir",
		"nvim-neotest/neotest-go",
	},
	event = "User AlphaClosed",
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-elixir"),
				require("neotest-go"),
			},
			quickfix = {
				enabled = false,
			},
			diagnostic = {
				enabled = false,
			},
			floating = {
				enabled = true,
				max_height = 0.9,
				max_width = 0.9
			},
			output_panel = {
				open = "botright split | resize 20"
			},
			icons = {
				running_animated = {
					"󱑊",
					"󱑀",
					"󱑁",
					"󱑂",
					"󱑃",
					"󱑄",
					"󱑅",
					"󱑆",
					"󱑇",
					"󱑉",
				},
				running = "󱑁",
				passed = "",
				failed = "",
				skipped = "",
				watching = "󰈈",
				unknown = "",
			},
			summary = {
				mappings = {
					jumpto = "<CR>",
					run = "r",
					watch = "=",
					expand_all = "e",
				},
				animated = true,
				open = "botright vsplit | vertical resize 60",
				expand_errors = false,
			},
		})

		local wk = require("which-key")
		wk.register({
			t = {
				name = "Testing/Terminal",
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
						require("neotest").summary.open({ enter = true })
					end,
					"Run test suite",
					noremap = true,
					silent = true,
				},
				o = {
					function ()
						require("neotest").summary.toggle({ enter = true })
					end,
					"Toggle summary panel",
					noremap = true,
					silent = true,
				}
			},
		}, { prefix = "<Leader>" })
	end,
}
