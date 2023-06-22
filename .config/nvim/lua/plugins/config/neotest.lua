local notification = {}

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"jfpedroza/neotest-elixir",
		"nvim-neotest/neotest-go",
		"rcarriga/nvim-notify"
	},
	event = "User AlphaClosed",
	config = function()
		require("neotest").setup({
			consumers = {
				notify = function(client)
					client.listeners.run = function (_, _, _)
						local record = require("notify")("Tests started...", vim.log.levels.INFO, {
							title = "Neotest",
							render = "simple",
						})

						notification[1] = record
					end

					client.listeners.results = function (adapter_id, _, partial)
						local state = require("neotest").state.status_counts(adapter_id)
						local running = state.running
						local errCount = state.failed

						local message = ""
						local type = vim.log.levels.INFO


						if not partial then
							message = string.format("Tests done. %s error(s) found.", errCount)
						else
							message = string.format("%d test(s) remaining.", running)
						end

						if not partial and (errCount > 0) then
							type = vim.log.levels.ERROR
						elseif not partial then
							type = vim.log.levels.DEBUG
						end

						local record = require("notify")(message, type, {
							title = "Neotest",
							render = "simple",
							replace = notification[1]
						})

						notification[1] = record
					end
					return {}
				end
			},
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
