local customformatters = {}
customformatters.csharpier = {
	exe = "dotnet",
	args = {
		"csharpier",
	},
	stdin = true,
}

return {
	"mhartington/formatter.nvim",
	cmd = {
		"Format",
		"FormatLock",
		"FormatWrite",
		"FormatWriteLock"
	},
	config = function()
		local util = require("formatter.util")
		local formatters = require("formatter.filetypes")

		-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
		require("formatter").setup({
			-- Enable or disable logging
			logging = true,
			-- Set the log level
			log_level = vim.log.levels.WARN,
			-- All formatter configurations are opt-in
			filetype = {
				lua = {
					formatters.lua.stylua,
				},
				go = {
					formatters.go.goimports,
				},
				elixir = {
					formatters.elixir.mixformat,
				},
				ruby = {
					formatters.ruby.rubocop,
				},
				javascriptreact = {
					formatters.javascriptreact.prettier,
				},
				javascript = {
					formatters.javascript.prettier,
				},
				typescriptreact = {
					formatters.typescriptreact.prettier,
				},
				typescript = {
					formatters.typescript.prettier,
				},
				json = {
					formatters.json.jq,
				},
				zig = {
					formatters.zig.zigfmt,
				},
				css = {
					formatters.css.prettier,
				},
				html = {
					formatters.html.prettier,
				},
				vue = {
					formatters.vue.prettier,
				},
				sh = {
					formatters.sh.shfmt,
				},
				sql = {
					formatters.sql.pgformat,
				},
				rust = {
					formatters.rust.rustfmt,
				},
				cs = {
					customformatters.csharpier,
				},
				python = {
					formatters.python.black,
				},
			},
		})

		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*.go",
			callback = function()
				vim.cmd("FormatWriteLock")
			end,
		})
	end,
}
