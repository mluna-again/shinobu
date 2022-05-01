local cmp = require('cmp')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup{
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		['<Tab>'] = function(fallback)
			if not cmp.select_next_item() then
				if vim.bo.buftype ~= 'prompt' and has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end
		end,

		['<S-Tab>'] = function(fallback)
			if not cmp.select_prev_item() then
				if vim.bo.buftype ~= 'prompt' and has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end
		end,
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'ultisnips' }, -- For ultisnips users.
	}, {
		{ name = 'buffer' },
	})
}
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require('lspconfig').elixirls.setup{
	capabilities = capabilities,
	cmd = { string.format("%s/.local/bin/elixir-ls/language_server.sh", os.getenv("HOME")) }
}

return {
	'hrsh7th/nvim-cmp'
}
