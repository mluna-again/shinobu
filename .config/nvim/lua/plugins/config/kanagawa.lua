return {
	"rebelot/kanagawa.nvim",
	config = function()
		vim.cmd([[
		augroup Kanawaga
		autocmd!
		autocmd ColorScheme * hi Normal guibg=NONE
		autocmd ColorScheme * hi Folded guibg=NONE ctermbg=NONE
		autocmd ColorScheme * hi link CmpItemAbbrMatchFuzzy Aqua
		autocmd ColorScheme * hi link CmpItemKindText Fg
		autocmd ColorScheme * hi link CmpItemKindMethod Purple
		autocmd ColorScheme * hi link CmpItemKindFunction Purple
		autocmd ColorScheme * hi link CmpItemKindConstructor Green
		autocmd ColorScheme * hi link CmpItemKindField Aqua
		autocmd ColorScheme * hi link CmpItemKindVariable Blue
		autocmd ColorScheme * hi link CmpItemKindClass Green
		autocmd ColorScheme * hi link CmpItemKindInterface Green
		autocmd ColorScheme * hi link CmpItemKindValue Orange
		autocmd ColorScheme * hi link CmpItemKindKeyword Keyword
		autocmd ColorScheme * hi link CmpItemKindSnippet Red
		autocmd ColorScheme * hi link CmpItemKindFile Orange
		autocmd ColorScheme * hi link CmpItemKindFolder Orange

		autocmd ColorScheme * hi NeotestFocused gui=none

		set fillchars+=vert:\ 
		set fillchars+=eob:\ 
		augroup end
		]])

		require("kanagawa").setup({
			theme = "dragon",
			colors = {
				theme = {
					all = {
						ui = {
							bg_gutter = "none",
						},
					},
				},
			},
			overrides = function(colors)
				local theme = colors.theme
				return {
					-- Save an hlgroup with dark background and dimmed foreground
					-- so that you can use it where your still want darker windows.
					-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

					-- Popular plugins that open floats will link to NormalFloat by default;
					-- set their background accordingly if you wish to keep them dark and borderless
					LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					TelescopeTitle = { fg = theme.ui.special, bold = true },
					TelescopePromptNormal = { bg = theme.ui.bg_p1 },
					TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
					TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
					TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
					TelescopePreviewNormal = { bg = theme.ui.bg_dim },
					TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },
					TelescopePromptTitle = { bg = colors.palette.dragonRed, fg = theme.ui.bg_dim },
					TelescopePreviewTitle = { bg = colors.palette.dragonYellow, fg = theme.ui.bg_dim },
					TelescopeResultsTitle = { bg = colors.palette.dragonViolet, fg = theme.ui.bg_dim },
					NormalFloat = { bg = colors.palette.dragonBlack4 },
					FloatBorder = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },
					FloatTitle = { bg = colors.palette.dragonBlack4 },
					MsgArea = { bg = colors.palette.dragonBlack3 },
					NeoTreeNormal = { bg = colors.palette.dragonBlack2 },
					NeoTreeNormalNC = { bg = colors.palette.dragonBlack2 },
					NeoTreeFloatBorder = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },
					NeoTreeTabActive = { bg = colors.palette.dragonBlack3, fg = colors.palette.dragonRed },
					NeoTreeTabInactive = { bg = colors.palette.dragonBlack3, fg = colors.palette.dragonGray },
					NeoTreeTabSeparatorActive = { fg = colors.palette.dragonBlack4 },
					NeoTreeTabSeparatorInactive = { fg = colors.palette.dragonBlack4 },
					BufferLineBufferModified = { bg = colors.palette.dragonBlack3, fg = colors.palette.dragonRed },
					BufferLineBufferSelected = { bg = colors.palette.dragonBlack3, fg = colors.palette.dragonRed },
					BufferLineBufferVisible = { bg = colors.palette.dragonBlack3, fg = colors.palette.dragonRed },
					BufferLineModified = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonRed },
					BufferLineSelected = { bg = colors.palette.dragonBlack3, fg = colors.palette.dragonRed },
					BufferLineVisible = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonRed },
					BufferLineDuplicate = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonWhite },
					BufferLineDuplicateVisible = { bg = colors.palette.dragonBlack3, fg = colors.palette.dragonRed },
					BufferLineDuplicateSelected = { bg = colors.palette.dragonBlack3, fg = colors.palette.dragonRed },
					BufferLineFill = { bg = colors.palette.dragonBlack1 },
					BufferLineBackground = { bg = colors.palette.dragonBlack4 },
					BufferLineSeparator = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },
					BufferLineSeparatorVisible = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },
					BufferLineSeparatorSelected = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },
					BufferLineIndicator = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },
					BufferLineIndicatorSelected = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },
					BufferLineIndicatorVisible = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },
					NeotestFile = { fg = colors.palette.dragonGray },
					NeotestDir = { fg = colors.palette.dragonWhite },
					NeotestNamespace = { fg = colors.palette.dragonWhite },
					NeotestFailed = { fg = colors.palette.peachRed },
					NeotestPassed = { fg = colors.palette.autumnGreen },
					NeotestRunning = { fg = colors.palette.dragonYellow },
					NeotestAdapterName = { fg = colors.palette.dragonAqua },
					NeotestIndent = { fg = colors.palette.dragonBlack4 },
					NeotestExpandMarker = { fg = colors.palette.dragonBlack4 },
					NeotestUnknown = { fg = colors.palette.dragonOrange },
					NeotestSkipped = { fg = colors.palette.dragonAqua },
					NeotestSummary = { bg = colors.palette.dragonBlack2 },

					NotifyINFOBody = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonWhite },
					NotifyINFOBorder = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },
					NotifyINFOTitle = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonWhite },

					NotifyDEBUGBody = { bg = colors.palette.dragonGreen, fg = colors.palette.dragonBlack4 },
					NotifyDEBUGBorder = { bg = colors.palette.dragonGreen, fg = colors.palette.dragonGreen },
					NotifyDEBUGTitle = { bg = colors.palette.dragonGreen, fg = colors.palette.dragonBlack4 },

					NotifyERRORBody = { bg = colors.palette.peachRed, fg = colors.palette.dragonBlack4 },
					NotifyERRORBorder = { bg = colors.palette.peachRed, fg = colors.palette.peachRed },
					NotifyERRORTitle = { bg = colors.palette.peachRed, fg = colors.palette.dragonBlack4 },
					MiniTrailspace = { bg = colors.palette.peachRed },

					LspSignatureActiveParameter = { fg = colors.palette.peachRed }
				}
			end,
		})
	end,
}
