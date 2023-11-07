-- local hls = {
-- 	Text = "CmpItemKindText",
-- 	Method = "CmpItemKindMethod",
-- 	Function = "CmpItemKindFunction",
-- 	Constructor = "CmpItemKindConstructor",
-- 	Field = "CmpItemKindField",
-- 	Variable = "CmpItemKindVariable",
-- 	Class = "CmpItemKindClass",
-- 	Interface = "CmpItemKindInterface",
-- 	Value = "CmpItemKindValue",
-- 	Keyword = "CmpItemKindKeyword",
-- 	Snippet = "CmpItemKindSnippet",
-- 	File = "CmpItemKindFile",
-- 	Folder = "CmpItemKindFolder",
-- }

local normalized = {
	Property      = "Property   ",
	Constructor   = "Constructor",
	Text          = "Text       ",
	Method        = "Method     ",
	Function      = "Function   ",
	Field         = "Field      ",
	Variable      = "Variable   ",
	Class         = "Class      ",
	Struct        = "Struct     ",
	Interface     = "Interface  ",
	Value         = "Value      ",
	Keyword       = "Keyword    ",
	Snippet       = "Snippet    ",
	File          = "File       ",
	Folder        = "Folder     ",
	Module        = "Module     ",
	Enum          = "Enum       ",
	EnumMember    = "Enum       ",
	Unit          = "Unit       ",
	Color         = "Color      ",
	Reference     = "Reference  ",
	Constant      = "Constant   ",
	Event         = "Event      ",
	Operator      = "Operator   ",
	TypeParameter = "Type       ",
}

return {
	"williamboman/mason-lspconfig.nvim",
	event = "BufWritePost",
	dependencies = {
		"williamboman/mason.nvim",
		"rmagatti/goto-preview",
		"hrsh7th/nvim-cmp",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-emoji",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"quangnguyen30192/cmp-nvim-ultisnips",
	},
	config = function()
		require("mason-lspconfig").setup({
			automatic_installation = false,
		})

		local kind_icons = {
			Text = "",
			Method = "",
			Function = "󰊕",
			Constructor = "",
			Field = "",
			Variable = "󰫧",
			Class = "",
			Interface = "",
			Module = "",
			Property = "",
			Unit = "",
			Value = "",
			Enum = "",
			Keyword = "",
			Snippet = "",
			Color = "",
			File = "",
			Reference = "",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰘧",
			Struct = "",
			Event = "",
			Operator = "",
			TypeParameter = "",
		}

		local cmp = require("cmp")

		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			},
			view = {
				entries = { name = "custom" },
			},
			window = {
				completion = nil,
				documentation = nil,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<Tab>"] = function(fallback)
					if not cmp.select_next_item() then
						if vim.bo.buftype ~= "prompt" and has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end
				end,

				["<S-Tab>"] = function(fallback)
					if not cmp.select_prev_item() then
						if vim.bo.buftype ~= "prompt" and has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end
				end,
			}),
			sources = cmp.config.sources({
				{
					name = "path",
					priority = 1,
				},
				{
					name = "emoji",
					priority = 2,
				},
				{
					name = "buffer",
					priority = 3,
				},
				{
					name = "ultisnips",
					priority = 4,
				},
				{
					name = "nvim_lsp",
					priority = 5,
				},
				{
					name = "vim-dadbod-completion",
					priority = 6
				}
			}),
			formatting = {
				format = function(entry, item)
					item.kind = string.format(' %s %s ', kind_icons[item.kind], normalized[item.kind])
					return item
				end,
			},
		})

		-- disable for some filetypes
		cmp.setup.filetype({ 'oil', 'oil_preview' }, {
			sources = {}
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
			"zls",
			"gleam",
			"csharp_ls",
			"svelte"
			-- "lua_ls",
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
