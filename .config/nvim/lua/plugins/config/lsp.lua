return {
	"williamboman/mason-lspconfig.nvim",
	event = "VeryLazy",
	dependencies = {
		"folke/neodev.nvim",
		"williamboman/mason.nvim",
		"rmagatti/goto-preview",
		"folke/which-key.nvim",
	},
	config = function()
		require("mason-lspconfig").setup({
			automatic_installation = false,
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		local servers = {
			"elixirls",
			"tsserver",
			"cssls",
			"solargraph",
			"rust_analyzer",
			"clojure_lsp",
			"gopls",
			"metals",
			"golangci_lint_ls",
			"volar",
			"lua_ls",
		}

		for _, server in pairs(servers) do
			require("lspconfig")[server].setup({
				capabilities = capabilities,
			})
		end

		local wk = require("which-key")
		wk.register({
			l = {
				name = "Lsp",
				u = {
					function()
						require('telescope.builtin').lsp_references()
					end,
					"References",
					noremap = true,
					silent = true
				},
				h = {
					function()
						vim.lsp.buf.hover()
					end,
					"Hover",
					noremap = true,
					silent = true
				},
				r = {
					function()
						vim.lsp.buf.rename()
					end,
					"Rename",
					noremap = true,
					silent = true
				},
				f = {
					function()
						require("goto-preview").goto_preview_definition()
					end,
					"Definition preview",
					noremap = true,
					silent = true
				},
				F = {
					function()
						vim.lsp.buf.definition()
					end,
					"Go to definition",
					noremap = true,
					silent = true
				},
				d = {
					function()
						vim.diagnostic.open_float()
					end,
					"Diagnostics",
					noremap = true,
					silent = true
				},
				R = {
					function()
						vim.cmd("LspRestart")
					end,
					"Restart server",
					noremap = true,
					silent = true
				},
			}
		}, { prefix = "<Leader>" })
	end,
}
