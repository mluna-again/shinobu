return {
	"sindrets/diffview.nvim",
	lazy = true,
	cmd = {
		"DiffviewClose",
		"DiffviewFileHistory",
		"DiffviewFocusFiles",
		"DiffviewLog",
		"DiffviewOpen",
		"DiffviewRefresh",
		"DiffviewToggleFiles"
	},
	config = function()
		vim.opt.fillchars:append { diff = "╱" }
		require("diffview").setup({
			hooks = {
				diff_buf_read = function()
					vim.opt_local.foldenable = false
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
