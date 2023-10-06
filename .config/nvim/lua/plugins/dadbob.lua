return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		"folke/which-key.nvim",
		{ "tpope/vim-dadbod", lazy = false },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = false },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_env_variable_url = "DATABASE_URL"
		vim.g.db_ui_auto_execute_table_helpers = 1
		vim.g.db_ui_execute_on_save = 0
	end,
	config = function()
		local wk = require("which-key")

		wk.register({
			q = {
				name = "SQL",
				r = {
					"<Plug>(DBUI_ExecuteQuery)",
					"Run SQL query (dadbod)",
					silent = true,
				},
				s = {
					"<Plug>(DBUI_SaveQuery)",
					"Save SQL query (dadbod)",
					silent = true,
				},
			},
		}, {
			prefix = "<Leader>",
		})

		vim.cmd([[
			autocmd FileType dbout setlocal nofoldenable
			autocmd FileType sql setlocal nofoldenable
		]])
	end,
}
