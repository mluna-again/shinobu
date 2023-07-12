return {

	"rebelot/kanagawa.nvim",
	config = function()
		vim.cmd([[
		augroup Kanawaga
		autocmd!
		autocmd ColorScheme * hi Normal guibg=NONE
		autocmd ColorScheme * hi Folded guibg=NONE ctermbg=NONE
		autocmd ColorScheme * hi NeotestFocused gui=none

		set fillchars+=vert:\ 
		set fillchars+=eob:\ 
		augroup end
		]])

		require("kanagawa").setup({
			theme = "dragon",
			keywordStyle = { italic = false },
			commentStyle = { italic = false },
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
					TelescopePromptTitle = { bg = colors.palette.dragonYellow, fg = theme.ui.bg_dim },
					TelescopePreviewTitle = { bg = colors.palette.dragonYellow, fg = theme.ui.bg_dim },
					TelescopeResultsTitle = { bg = colors.palette.dragonViolet, fg = theme.ui.bg_dim },

					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },


					NormalFloat = { bg = colors.palette.dragonBlack4 },
					FloatBorder = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },
					FloatTitle = { bg = colors.palette.dragonBlack4 },
					MsgArea = { bg = colors.palette.dragonBlack3 },

					NeoTreeNormal = { bg = colors.palette.dragonBlack2 },
					NeoTreeNormalNC = { bg = colors.palette.dragonBlack2 },
					NeoTreeFloatBorder = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },
					NeoTreeTabActive = { bg = colors.palette.dragonBlack3, fg = colors.palette.dragonYellow },
					NeoTreeTabInactive = { bg = colors.palette.dragonBlack3, fg = colors.palette.dragonGray },
					NeoTreeTabSeparatorActive = { fg = colors.palette.dragonBlack4 },
					NeoTreeTabSeparatorInactive = { fg = colors.palette.dragonBlack4 },
					NeoTreeVertSplit = { fg = colors.palette.dragonBlack4, bg = colors.palette.dragonBlack4 },

					BufferLineBufferModified = { fg = colors.palette.dragonBlack3, bg = colors.palette.dragonYellow },
					BufferLineBufferModifiedVisible = { fg = colors.palette.dragonGray, bg = colors.palette.dragonBlack4 },
					BufferLineBufferSelected = { fg = colors.palette.dragonBlack3, bg = colors.palette.dragonYellow },
					BufferLineBufferVisible = { fg = colors.palette.dragonGray, bg = colors.palette.dragonBlack4 },
					BufferLineModified = { fg = colors.palette.dragonGray, bg = colors.palette.dragonBlack4 },
					BufferLineModifiedVisible = { fg = colors.palette.dragonGray, bg = colors.palette.dragonBlack4 },
					BufferLineModifiedSelected = { fg = colors.palette.dragonBlack3, bg = colors.palette.dragonYellow },
					BufferLineSelected = { fg = colors.palette.dragonBlack3, bg = colors.palette.dragonYellow },
					BufferLineVisible = { fg = colors.palette.dragonGray, bg = colors.palette.dragonBlack4 },
					BufferLine = { fg = colors.palette.dragonGray, bg = colors.palette.dragonBlack4 },
					BufferLineDuplicate = { fg = colors.palette.dragonGray, bg = colors.palette.dragonBlack4 },
					BufferLineDuplicateVisible = { fg = colors.palette.dragonGray, bg = colors.palette.dragonBlack4 },
					BufferLineDuplicateSelected = { fg = colors.palette.dragonBlack3, bg = colors.palette.dragonYellow },
					BufferLineFill = { fg = colors.palette.dragonBlack1 },
					BufferLineBackground = { fg = colors.palette.dragonGray, bg = colors.palette.dragonBlack4 },
					BufferLineSeparator = { fg = colors.palette.dragonBlack4, bg = colors.palette.dragonBlack4 },
					BufferLineSeparatorVisible = { fg = colors.palette.dragonBlack4, bg = colors.palette.dragonBlack4 },
					BufferLineSeparatorSelected = { fg = colors.palette.dragonBlack4, bg = colors.palette.dragonBlack4 },
					BufferLineIndicator = { fg = colors.palette.dragonBlack3, bg = colors.palette.dragonBlack3 },
					BufferLineIndicatorSelected = { fg = colors.palette.dragonBlack4, bg = colors.palette.dragonYellow },
					BufferLineIndicatorVisible = { fg = colors.palette.dragonGray, bg = colors.palette.dragonBlack4 },
					BufferLineTruncMarker = { fg = colors.palette.dragonGray, bg = colors.palette.dragonBlack4 },

					NeotestFile = { fg = colors.palette.dragonGray },
					NeotestDir = { fg = colors.palette.dragonWhite },
					NeotestNamespace = { fg = colors.palette.dragonWhite },
					NeotestFailed = { fg = colors.palette.dragonYellow },
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
					NotifyINFOIcon = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonWhite },

					NotifyDEBUGBody = { bg = colors.palette.dragonGreen, fg = colors.palette.dragonBlack4 },
					NotifyDEBUGBorder = { bg = colors.palette.dragonGreen, fg = colors.palette.dragonGreen },
					NotifyDEBUGTitle = { bg = colors.palette.dragonGreen, fg = colors.palette.dragonBlack4 },
					NotifyDEBUGIcon = { bg = colors.palette.dragonGreen, fg = colors.palette.dragonBlack4 },

					NotifyERRORBody = { bg = colors.palette.dragonRed, fg = colors.palette.dragonBlack4 },
					NotifyERRORBorder = { bg = colors.palette.dragonRed, fg = colors.palette.dragonRed },
					NotifyERRORTitle = { bg = colors.palette.dragonRed, fg = colors.palette.dragonBlack4 },
					NotifyERRORIcon = { bg = colors.palette.dragonRed, fg = colors.palette.dragonBlack4 },
					ErrorMsg = { fg = colors.palette.dragonBlack4 },

					NotifyTRACEBody = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },
					NotifyTRACEBorder = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonYellow },
					NotifyTRACETitle = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },
					NotifyTRACEIcon = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },

					NotifyWARNBody = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },
					NotifyWARNBorder = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonYellow },
					NotifyWARNTitle = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },
					NotifyWARNIcon = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },

					MiniTrailspace = { bg = colors.palette.dragonYellow },

					LspSignatureActiveParameter = { fg = colors.palette.dragonYellow },

					OilBackground = { bg = colors.palette.dragonBlack2 },
					OilBorder = { bg = colors.palette.dragonBlack2, fg = colors.palette.dragonBlack2 },
					OilPreviewBackground = { bg = colors.palette.dragonBlack4 },
					OilPreviewBorder = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonBlack4 },

					NoicePopup = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonYellow },
					NoicePopupmenu = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonYellow },
					NoicePopupmenuSelected = { bg = colors.palette.dragonBlack4, fg = colors.palette.dragonYellow },
					NoiceCmdlinePopup = { bg = colors.palette.dragonBlack4 },
					NoiceCmdlinePopupBorder = { fg = colors.palette.dragonBlack4 },
					NoiceCmdlinePopupTitle = { fg = colors.palette.dragonBlack4, bg = colors.palette.dragonYellow },
					NoiceCmdlinePopupIcon = { fg = colors.palette.dragonWhite },
					NoiceMissingMenu = { fg = colors.palette.dragonWhite, bg = colors.palette.dragonBlack2 },
					NoiceMissingMenuBorder = { fg = colors.palette.dragonBlack2, bg = colors.palette.dragonBlack2 },
					NoiceScrollbar = { fg = colors.palette.dragonBlack3, bg = colors.palette.dragonBlack3 },

					DiagnosticError = { fg = colors.palette.dragonRed },
					DiagnosticWarn = { fg = colors.palette.dragonOrange },
					DiagnosticInfo = { fg = colors.palette.dragonBlue },
					DiagnosticHint = { fg = colors.palette.dragonYellow },

					AlphaPluginCount = { fg = colors.palette.dragonYellow },
					AlphaFooter = { fg = colors.palette.dragonBlue },
					AlphaButton = { fg = colors.palette.dragonYellow },
					AlphaButtonKey = { fg = colors.palette.dragonYellow, bg = colors.palette.dragonBlack4 },
					AlphaBanner = { fg = colors.palette.dragonYellow },

					CmpItemAbbrMatchFuzzy = { fg = colors.palette.dragonYellow },
					CmpItemKindText = { bg = colors.palette.dragonGray, fg = colors.palette.dragonBlack4 },
					CmpItemKindMethod = { bg = colors.palette.dragonOrange, fg = colors.palette.dragonBlack4 },
					CmpItemKindFunction = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },
					CmpItemKindConstructor = { bg = colors.palette.dragonViolet, fg = colors.palette.dragonBlack4 },
					CmpItemKindField = { bg = colors.palette.dragonBlue, fg = colors.palette.dragonBlack4 },
					CmpItemKindModule = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },
					CmpItemKindVariable = { bg = colors.palette.dragonGreen, fg = colors.palette.dragonBlack4 },
					CmpItemKindConstant = { bg = colors.palette.dragonWhite, fg = colors.palette.dragonBlack4 },
					CmpItemKindClass = { bg = colors.palette.dragonViolet, fg = colors.palette.dragonBlack4 },
					CmpItemKindStruct = { bg = colors.palette.dragonViolet, fg = colors.palette.dragonBlack4 },
					CmpItemKindInterface = { bg = colors.palette.dragonTeal, fg = colors.palette.dragonBlack4 },
					CmpItemKindValue = { bg = colors.palette.dragonGreen, fg = colors.palette.dragonBlack4 },
					CmpItemKindKeyword = { bg = colors.palette.dragonPink, fg = colors.palette.dragonBlack4 },
					CmpItemKindSnippet = { bg = colors.palette.dragonAqua, fg = colors.palette.dragonBlack4 },
					CmpItemKindFile = { bg = colors.palette.dragonGray, fg = colors.palette.dragonBlack4 },
					CmpItemKindFolder = { bg = colors.palette.dragonGray, fg = colors.palette.dragonBlack4 },
					CmpItemKindEnum = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },
					CmpItemKindEnumMember = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },
					CmpItemKindProperty = { bg = colors.palette.dragonBlack2, fg = colors.palette.dragonYellow },

					LightspeedShortcut = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },
					LightspeedLabel = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },
					LightspeedOneCharMatch = { bg = colors.palette.dragonYellow, fg = colors.palette.dragonBlack4 },

					WinSeparator = { fg = colors.palette.dragonBlack2, bg = colors.palette.dragonBlack3 },
				}
			end,
		})
	end,
}
