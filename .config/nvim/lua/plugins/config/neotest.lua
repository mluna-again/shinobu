-- lord forgive me
local state = {
	possible_states = {},
	current_notification = nil,
	running_type = nil,
	current_buffer = nil
}
state.possible_states.individual = 1
state.possible_states.buffer = 2
state.possible_states.suite = 3

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"jfpedroza/neotest-elixir",
		"nvim-neotest/neotest-go",
		"rcarriga/nvim-notify",
		"akinsho/toggleterm.nvim",
		"vim-test/vim-test",
	},
	event = "User AlphaClosed",
	config = function()
		require("neotest").setup({
			consumers = {
				notify = function(client)
					client.listeners.run = function(_, _, _)
						require("notify").dismiss()
						if state.running_type == state.possible_states.individual then
							return
						end

						local record = require("notify")("Tests started...", vim.log.levels.INFO, {
							title = "Neotest",
							render = "compact",
							timeout = 5000,
							keep = function()
								return true
							end
						})

						state.current_notification = record
					end

					client.listeners.results = function(adapter_id, _, partial)
						if (state.running_type == state.possible_states.individual) and partial then
							return
						end

						if (state.running_type == state.possible_states.individual) and not partial then
							require("neotest").output.open({ last_run = true, enter = true })
							return
						end

						local buffer = nil
						if state.running_type == state.possible_states.buffer then
							buffer = state.current_buffer
						end

						local status = require("neotest").state.status_counts(adapter_id, { buffer = buffer })
						local running = status.running
						local errCount = status.failed

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
						local record = require("notify")(message, type, {
							title = "Neotest",
							render = "compact",
							replace = state.current_notification,
							timeout = timeout,
							keep = function()
								return partial
							end
						})

						state.current_notification = record
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
				open_on_run = "short",
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
				c = {
					function()
						require("notify").dismiss()
					end,
					"Remove old notifications",
					noremap = true,
					silent = true,
				},
				i = {
					function()
						require("neotest").output.open({ last_run = true })
					end,
					"Open output of last test ran",
					noremap = true,
					silent = true,
				},
				n = {
					function()
						require("neotest").jump.next({ status = "failed" })
					end,
					"Jump to next failed test",
					noremap = true,
					silent = true,
				},
				p = {
					function()
						require("neotest").jump.prev({ status = "failed" })
					end,
					"Jump to previous failed test",
					noremap = true,
					silent = true,
				},
				r = {
					function()
						state.running_type = state.possible_states.individual
						require("neotest").run.run()
					end,
					"Run test under cursor",
					noremap = true,
					silent = true,
				},
				R = {
					function()
						state.current_buffer = vim.api.nvim_get_current_buf()
						state.running_type = state.possible_states.buffer
						require("neotest").run.run(vim.fn.expand("%"))
					end,
					"Run test file",
					noremap = true,
					silent = true,
				},
				T = {
					function()
						vim.ui.input({ prompt = "Run all tests? [yN] " }, function(input)
							if not (input == "y") then
								vim.notify("Not running")
								return
							end
							state.running_type = state.possible_states.suite
							require("neotest").run.run({ suite = true })
						end)
					end,
					"Run test suite",
					noremap = true,
					silent = true,
				},
				o = {
					function()
						require("neotest").summary.toggle({ enter = true })
						vim.cmd("wincmd w")
					end,
					"Toggle summary panel",
					noremap = true,
					silent = true,
				}
			},
		}, { prefix = "<Leader>" })

		-- change summary background color
		vim.api.nvim_create_autocmd("WinEnter", {
			pattern = "*",
			callback = function()
				if not (vim.bo.filetype == "neotest-summary") then
					return
				end
				vim.wo.winhighlight = "Normal:NeotestSummary"
			end
		})
		vim.api.nvim_create_user_command("RunTest", function()
			vim.cmd("TestNearest")
		end, {})
	end,
}
