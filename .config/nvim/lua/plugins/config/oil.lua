return {
	"stevearc/oil.nvim",
	opts = {},
	event = "VeryLazy",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	config = function()
		require("oil").setup({
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-s>"] = "actions.select_vsplit",
				["<C-h>"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["<C-c>"] = "actions.close",
				["q"] = "actions.close",
				["<C-l>"] = "actions.refresh",
				["<BS>"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["g."] = "actions.toggle_hidden",
			},
			view_options = {
				show_hidden = true
			},
			float = {
				border = "none",
				win_options = {
					winblend = 0,
					winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder",
				},
				padding = 6
			},
			buf_options = {
				buflisted = false,
				bufhidden = "hide",
			},
			preview = {
				win_options = {
					winblend = 0,
					winhighlight = "Normal:OilPreviewBackground,FloatBorder:OilPreviewBorder,FloatTitle:OilBorder"
				}
			},
			win_options = {
				winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder"
			},
      skip_confirm_for_simple_edits = true,
		})
	end
}
