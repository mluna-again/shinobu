return {
	"stevearc/oil.nvim",
	opts = {},
	cmd = "Oil",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local oil = require("oil")

		require("oil").setup({
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-v>"] = {
					callback = function()
						oil.select({ vertical = true })
						oil.close()
					end,
					desc = "Vertical Split",
					mode = "n",
				},
				["<C-s>"] = {
					callback = function()
						oil.select({ horizontal = true })
						oil.close()
					end,
					desc = "Horizontal Split",
					mode = "n",
				},
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["<C-c>"] = "actions.close",
				["<Esc>"] = "actions.close",
				["q"] = "actions.close",
				["<C-l>"] = "actions.refresh",
				["<BS>"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["g."] = "actions.toggle_hidden",
			},
			view_options = {
				show_hidden = true,
			},
			float = {
				border = "rounded",
				win_options = {
					winblend = 0,
					winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder,LineNr:OilBackground",
				},
				padding = 6,
			},
			buf_options = {
				buflisted = false,
				bufhidden = "hide",
			},
			preview = {
				win_options = {
					winblend = 0,
					winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder,LineNr:OilBackground",
				},
			},
			win_options = {
				winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder,LineNr:OilBackground",
			},
			skip_confirm_for_simple_edits = true,
		})
	end,
}
