return {
	"sindrets/diffview.nvim",
	event = "VeryLazy",
	config = function()
		vim.opt.fillchars:append { diff = "╱" }
		require("diffview").setup({
			view = {
				merge_tool = {
					layout = "diff3_mixed",
					disable_diagnostics = true
				}
			}
		})
	end,
}
