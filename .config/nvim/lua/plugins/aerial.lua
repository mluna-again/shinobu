return {
	"stevearc/aerial.nvim",
	cmd = {
		"AerialToggle",
		"AerialOpen",
		"AerialClose",
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"folke/which-key.nvim",
	},
	init = function()
		local wk = require("which-key")

		wk.register({
			l = {
				name = "Lsp",
				s = {
					"<cmd>AerialToggle<CR>",
					"Toggle symbols",
				},
			},
		}, {
			prefix = "<leader>",
		})
	end,
	opts = {
		keymaps = {
			["{"] = false,
			["}"] = false,
			["N"] = "actions.prev",
			["n"] = "actions.next",
		},
		layout = {
			min_width = 0.25
		}
	},
}
