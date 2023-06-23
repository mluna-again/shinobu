-- lord forgive me
local possible_states = {}
possible_states.individual = 1
possible_states.buffer = 2
possible_states.suite = 3

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
						if _G.running_type == possible_states.individual then
							return
						end

						local record = require("notify")("Tests started...", vim.log.levels.INFO, {
							title = "Neotest",
							render = "compact",
							timeout = 5000
						})

						_G.current_notification = record
					end

					client.listeners.results = function (adapter_id, _, partial)
						if (_G.running_type == possible_states.individual) and partial then
							return
						end

						if (_G.running_type == possible_states.individual) and not partial then
							require("neotest").output.open({ last_run = true, enter = true })
							return
						end

						local buffer = nil
						if _G.running_type == possible_states.buffer then
							buffer = vim.api.nvim_get_current_buf()
						end

						local state = require("neotest").state.status_counts(adapter_id, { buffer = buffer })
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

						local timeout = 5000
						if not partial then
							timeout = 3000
						end
						local record = require("notify")(message, type, {
							title = "Neotest",
							render = "compact",
							replace = _G.current_notification,
							timeout = timeout
						})

						_G.current_notification = record
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
			output = {
				open_on_run = true,
				enabled = true
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
				i = {
					function ()
						require("neotest").output.open({ last_run = true })
					end,
					"Open output of last test ran",
					noremap = true,
					silent = true,
				},
				n = {
					function ()
						require("neotest").jump.next({ status = "failed" })
					end,
					"Jump to next failed test",
					noremap = true,
					silent = true,
				},
				p = {
					function ()
						require("neotest").jump.prev({ status = "failed" })
					end,
					"Jump to previous failed test",
					noremap = true,
					silent = true,
				},
				r = {
					function()
						_G.running_type = possible_states.individual
						require("neotest").run.run()
					end,
					"Run test under cursor",
					noremap = true,
					silent = true,
				},
				R = {
					function()
						_G.running_type = possible_states.buffer
						require("neotest").run.run(vim.fn.expand("%"))
					end,
					"Run test file",
					noremap = true,
					silent = true,
				},
				T = {
					function()
						_G.running_type = possible_states.suite
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
