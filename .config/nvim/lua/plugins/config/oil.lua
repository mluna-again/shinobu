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
					winblend = 0,
				},
				padding = 6
			},
			buf_options = {
				buflisted = false,
				bufhidden = "hide",
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "oil", "oil_preview" },
			callback = function()
				if vim.bo.filetype == "oil" then
					vim.wo.winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder"
					return
				end

				if vim.bo.filetype == "oil_preview" then
					vim.wo.winhighlight = "Normal:OilPreviewBackground,FloatBorder:OilPreviewBorder,FloatTitle:OilBorder"
					return
				end
			end
		})
	end
}
