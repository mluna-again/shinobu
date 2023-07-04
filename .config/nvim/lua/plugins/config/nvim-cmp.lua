require("core.maps")

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
	"hrsh7th/nvim-cmp",
	event = "VeryLazy",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-emoji",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"quangnguyen30192/cmp-nvim-ultisnips",
		"neovim/nvim-lspconfig",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
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
			Value = "",
			Enum = "",
			Keyword = "",
			Snippet = "",
			Color = "",
			File = "",
			Reference = "",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "",
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
	end,
}
