return {
	'williamboman/mason-lspconfig.nvim',
	config = function()
		require('mason-lspconfig').setup()

		local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

		local servers = {
			'elixirls',
			'tsserver',
			'cssls',
			'solargraph',
			'rust_analyzer',
			'clojure_lsp',
			'kotlin_language_server',
			'gopls',
			'metals'
		}

		for _, server in pairs(servers) do
			local s = require('lspconfig')[server]
			require('lspconfig')[server].setup{
				capabilities = capabilities
			}
		end

		nmap('<Leader>lh', ':lua vim.lsp.buf.hover()<CR>')
		nmap('<Leader>lr', ':lua vim.lsp.buf.rename()<CR>')
		nmap('<Leader>lf', ':lua vim.lsp.buf.definition()<CR>')
		nmap('<Leader>ld', ':lua vim.diagnostic.open_float()<CR>')
	end
}