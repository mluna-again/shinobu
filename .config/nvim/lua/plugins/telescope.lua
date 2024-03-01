return {
	"nvim-telescope/telescope.nvim",
	lazy = true,
	cmd = {
		"Telescope"
	},
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
		"LukasPietzschmann/telescope-tabs",
	},
	config = function()
		local action_state = require("telescope.actions.state")
		local actions = require("telescope.actions")

		-- or create your custom action
		local quick_close_esc = function(prompt_bufnr)
			local query = action_state.get_current_line()
			local mode = vim.api.nvim_get_mode().mode

			if query == "" then
				actions.close(prompt_bufnr)
				return
			end

			if mode == "n" then
				actions.close(prompt_bufnr)
				return
			end

			vim.api.nvim_input("<C-c>")
		end

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
						["<Esc>"] = quick_close_esc,
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
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "ignore_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
			},
		})

		require("telescope").load_extension("fzf")
	end,
}
