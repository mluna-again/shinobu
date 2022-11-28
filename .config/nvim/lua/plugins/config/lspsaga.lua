require 'core.maps'

return {
	"glepnir/lspsaga.nvim",
	branch = "main",
	config = function()
		local saga = require("lspsaga")

		saga.init_lsp_saga({
			-- "single" | "double" | "rounded" | "bold" | "plus"
			border_style = "single",
			-- when cursor in saga window you config these to move
			move_in_saga = { prev = 'k' ,next = 'j'},
			-- Error, Warn, Info, Hint
			-- use emoji like
			-- { "🙀", "😿", "😾", "😺" }
			-- or
			-- { "😡", "😥", "😤", "😐" }
			-- and diagnostic_header can be a function type
			-- must return a string and when diagnostic_header
			-- is function type it will have a param `entry`
			-- entry is a table type has these filed
			-- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
			diagnostic_header = { " ", " ", " ", "ﴞ " },
			-- show diagnostic source
			show_diagnostic_source = true,
			-- add bracket or something with diagnostic source, just have 2 elements
			diagnostic_source_bracket = {},
			-- use emoji lightbulb in default
			code_action_icon = "",
			-- code_action_icon = "💡",
			-- if true can press number to execute the codeaction in codeaction window
			code_action_num_shortcut = true,
			-- same as nvim-lightbulb but async
			code_action_lightbulb = {
				enable = true,
				sign = true,
				sign_priority = 20,
				virtual_text = true,
			},
			-- separator in finder
			-- preview lines of lsp_finder and definition preview
			max_preview_lines = 10,
			finder_action_keys = {
				open = "<CR>",
				vsplit = "v",
				split = "s",
				tabe = "t",
				quit = "<Esc>",
				scroll_down = "<C-n>",
				scroll_up = "<C-p>", -- quit can be a table
			},
			code_action_keys = {
				quit = "<Esc>",
				exec = "<CR>",
				scroll_down = "<C-n>",
				scroll_up = "<C-p>",
			},
			rename_action_quit = "<Esc>",
			definition_preview_icon = "  ",
			-- if you don't use nvim-lspconfig you must pass your server name and
			-- the related filetypes into this table
			-- like server_filetype_map = { metals = { "sbt", "scala" } }
			server_filetype_map = {},
		})

		local action = require("lspsaga.action")
		vim.keymap.set("n", "<C-n>", function()
			action.smart_scroll_with_saga(1)
		end, { silent = true })
		vim.keymap.set("n", "<C-p>", function()
			action.smart_scroll_with_saga(-1)
		end, { silent = true })

		nmap("<Leader>lf", "<cmd>lua require('lspsaga.finder').lsp_finder()<CR>")
		nmap("<Leader>ld", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>")
		nmap("<Leader>lr", "<cmd>lua require('lspsaga.rename').lsp_rename()<CR>")
		nmap("<Leader>la", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>")
	end
}
