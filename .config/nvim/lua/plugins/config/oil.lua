return {
	"stevearc/oil.nvim",
	opts = {},
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
				win_options = {
					winblend = 0
				},
				padding = 6
			},
			buf_options = {
				buflisted = false,
				bufhidden = "hide",
			},
		})
	end
}
