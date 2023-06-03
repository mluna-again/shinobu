return {
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "leoluz/nvim-dap-go", "folke/which-key.nvim" },
	config = function()
		require("dapui").setup()
		require("dap-go").setup()

		local dap, dapui = require("dap"), require("dapui")
		local wk = require("which-key")
		-- mappings
		wk.register({
			d = {
				name = "Debugging",
				b = { ":lua require'dap'.toggle_breakpoint()<CR>", "Toggle breakpoint", noremap = true, silent = true },
				B = { ":lua require'dap'.clear_breakpoints()<CR>", "Clear breakpoints", noremap = true, silent = true },
				c = {
					function()
						dapui.open({ reset = true })
						dap.continue()
					end,
					"Continue/Start debugging",
					noremap = true,
					silent = true,
				},
				x = {
					function()
						dap.close()
						dapui.close()
					end,
					"Stop debugging",
					noremap = true,
					silent = true,
				},
				n = { ":lua require'dap'.step_over()<CR>", "Step over", noremap = true, silent = true },
				N = { ":lua require'dap'.step_into()<CR>", "Step into", noremap = true, silent = true },
				r = { ":lua require'dap'.repl()<CR>", "REPL", noremap = true, silent = true },
				R = { ":lua require'dapui'.open({ reset = true })<CR>", "Reset UI", noremap = true, silent = true },
			},
		}, {
			prefix = "<Leader>",
		})
	end,
}
