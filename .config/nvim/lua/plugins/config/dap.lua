return {
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "leoluz/nvim-dap-go", "folke/which-key.nvim" },
	config = function()
		require("dapui").setup()
		require("dap-go").setup()

		-- auto open/close dapui
		local dap, dapui = require("dap"), require("dapui")
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		local wk = require("which-key")
		-- mappings
		wk.register({
			d = {
				b = { ":lua require'dap'.toggle_breakpoint()<CR>", "Toggle breakpoint", noremap = true, silent = true },
				c = { ":lua require'dap'.continue()<CR>", "Continue/Start debugging", noremap = true, silent = true },
				n = { ":lua require'dap'.step_over()<CR>", "Step over", noremap = true, silent = true },
				p = { ":lua require'dap'.step_into()<CR>", "Step into", noremap = true, silent = true },
				r = { ":lua require'dap'.repl()<CR>", "REPL", noremap = true, silent = true },
			},
		}, {
			prefix = "<Leader>",
		})
	end,
}
