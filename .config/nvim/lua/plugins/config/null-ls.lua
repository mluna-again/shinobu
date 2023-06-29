return {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = {
		"rcarriga/nvim-notify",
	},
	event = "VeryLazy",
	config = function()
		local null = require("null-ls")

		null.setup({
			sources = {
				null.builtins.formatting.goimports,
				null.builtins.diagnostics.shellcheck,
				null.builtins.formatting.jq,
			}
		})

		local function format()
			vim.lsp.buf.format({ async = false })
		end

		vim.api.nvim_create_user_command("Format", format, { range = true })
	end
}
