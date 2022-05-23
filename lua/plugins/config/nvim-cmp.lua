return {
	'hrsh7th/nvim-cmp',
	config = function()
		require("nvim-lsp-installer").setup({
			ensure_installed = { "elixirls", "tsserver", "sumneko_lua" }, -- ensure these servers are always installed
			automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
			ui = {
				icons = {
					server_installed = "✓",
					server_pending = "➜",
					server_uninstalled = "✗"
				}
			},
			install_root_dir = string.format("%s/.local/bin", os.getenv("HOME"))
		})
		local kind_icons = {
			Text = "",
			Method = "",
			Function = "",
			Constructor = "",
			Field = "",
			Variable = "",
			Class = "ﴯ",
			Interface = "",
			Module = "",
			Property = "ﰠ",
			Unit = "",
			Value = "",
			Enum = "",
			Keyword = "",
			Snippet = "",
			Color = "",
			File = "",
			Reference = "",
			Folder = "",
			EnumMember = "",
			Constant = "",
			Struct = "",
			Event = "",
			Operator = "",
			TypeParameter = ""
		}

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
			view = {
				entries = { name = 'custom' }
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
				['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
			}),
			formatting = {
				format = function(entry, vim_item)
					-- Kind icons
					vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
					-- Source
					vim_item.menu = ({
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						luasnip = "[LuaSnip]",
					})[entry.source.name]
					return vim_item
				end
			}
		}
		local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
		require('lspconfig').elixirls.setup{
			capabilities = capabilities
		}
		require('lspconfig').tsserver.setup{
			capabilities = capabilities
		}
		require('lspconfig').sumneko_lua.setup{
			capabilities = capabilities
		}
		require('lspconfig').cssls.setup{
			capabilities = capabilities
		}
	end
}
