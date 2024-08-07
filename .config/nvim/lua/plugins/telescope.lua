return {
	"nvim-telescope/telescope.nvim",
	lazy = true,
	cmd = {
		"Telescope",
	},
	config = function()
		local action_state = require("telescope.actions.state")
		local actions = require("telescope.actions")

		-- vim.api.nvim_create_autocmd("BufEnter", {
		-- 	pattern = "*",
		-- 	callback = function()
		-- 		vim.opt.laststatus = 3
		-- 	end,
		-- })
		-- vim.api.nvim_create_autocmd("FileType", {
		-- 	pattern = "*",
		-- 	callback = function()
		-- 		if (vim.bo.filetype == "TelescopePrompt") or (vim.bo.filetype == "TelescopeResults") then
		-- 			vim.opt.laststatus = 0
		-- 		else
		-- 			vim.opt.laststatus = 3
		-- 		end
		-- 	end,
		-- })

		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<C-s>"] = "select_horizontal",
						["<C-v>"] = "select_vertical",
						-- ["<Esc>"] = actions.close
					},
				},
				path_display = { "truncate" },
				winblend = 0,
				borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
				color_devicons = true,
				use_less = true,
				prompt_prefix = "  ",
				selection_caret = "  ",
				entry_prefix = "  ",
				initial_mode = "insert",
				selection_strategy = "reset",
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = {
						mirror = false,
					},
					width = 0.87,
					height = 0.90,
					preview_cutoff = 120,
				},
			},
			pickers = {},
			extensions = {
				-- zoxide = {
				-- 	prompt_title = "Common files and directories",
				-- },
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "ignore_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
			},
		})
	end,
}
