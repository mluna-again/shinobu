return {
	"sindrets/diffview.nvim",
	event = "VeryLazy",
	dependencies = {
		"levouh/tint.nvim",
	},
	config = function()
		vim.opt.fillchars:append { diff = "╱" }
		require("diffview").setup({
			hooks = {
				diff_buf_read = function()
					vim.opt_local.foldenable = false
				end,
				view_enter = function ()
					require("tint").disable()
				end,
				view_leave = function ()
					require("tint").enable()
				end,
			},
			view = {
				merge_tool = {
					layout = "diff3_mixed",
					disable_diagnostics = true
				}
			}
		})
	end,
}
