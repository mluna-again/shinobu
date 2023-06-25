return {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = {
		"rcarriga/nvim-notify",
	},
	event = "User AlphaClosed",
	config = function()
		local null = require("null-ls")

		null.setup({
			sources = {}
		})

		local function format()
			vim.lsp.buf.format({ async = false })
		end

		vim.api.nvim_create_user_command("Format", format, { range = true })

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = format
		})
	end
}
