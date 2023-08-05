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
					Normal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

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
					TelescopePromptTitle = { bg = theme.syn.identifier, fg = theme.ui.bg_dim },
					TelescopePreviewTitle = { bg = theme.syn.identifier, fg = theme.ui.bg_dim },
					TelescopeResultsTitle = { bg = theme.syn.statement, fg = theme.ui.bg_dim },

					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },


					NormalFloat = { bg = theme.ui.bg_gutter },
					FloatBorder = { bg = theme.ui.bg_gutter, fg = theme.ui.bg_gutter },
					FloatTitle = { bg = theme.ui.bg_gutter },
					MsgArea = { bg = theme.ui.bg },

					NeoTreeNormal = { bg = theme.ui.bg_m1 },
					NeoTreeNormalNC = { bg = theme.ui.bg_m1 },
					NeoTreeFloatBorder = { bg = theme.ui.bg_gutter, fg = theme.ui.bg_gutter },
					NeoTreeTabActive = { bg = theme.ui.bg, fg = theme.syn.identifier },
					NeoTreeTabInactive = { bg = theme.ui.bg, fg = theme.syn.parameter },
					NeoTreeTabSeparatorActive = { fg = theme.ui.bg_gutter },
					NeoTreeTabSeparatorInactive = { fg = theme.ui.bg_gutter },
					NeoTreeVertSplit = { fg = theme.ui.bg_gutter, bg = theme.ui.bg_gutter },

					BufferLineBufferModified = { fg = theme.ui.bg, bg = theme.syn.identifier },
					BufferLineBufferModifiedVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineBufferSelected = { fg = theme.ui.bg, bg = theme.syn.identifier },
					BufferLineBufferVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineModified = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineModifiedVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineModifiedSelected = { fg = theme.ui.bg, bg = theme.syn.identifier },
					BufferLineSelected = { fg = theme.ui.bg, bg = theme.syn.identifier },
					BufferLineVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLine = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineDuplicate = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineDuplicateVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineDuplicateSelected = { fg = theme.ui.bg, bg = theme.syn.identifier },
					BufferLineBackground = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineSeparator = { fg = theme.ui.bg_gutter, bg = theme.ui.bg_gutter },
					BufferLineSeparatorVisible = { fg = theme.ui.bg_gutter, bg = theme.ui.bg_gutter },
					BufferLineSeparatorSelected = { fg = theme.ui.bg_gutter, bg = theme.ui.bg_gutter },
					BufferLineIndicator = { fg = theme.ui.bg, bg = theme.ui.bg },
					BufferLineIndicatorSelected = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
					BufferLineIndicatorVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineTruncMarker = { fg = theme.syn.identifier, bg = theme.ui.bg_gutter },

					NeotestFile = { fg = theme.syn.parameter },
					NeotestDir = { fg = theme.ui.fg },
					NeotestNamespace = { fg = theme.ui.fg },
					NeotestFailed = { fg = theme.syn.identifier },
					NeotestPassed = { fg = theme.syn.string },
					NeotestRunning = { fg = theme.syn.identifier },
					NeotestAdapterName = { fg = theme.syn.type },
					NeotestIndent = { fg = theme.ui.bg_gutter },
					NeotestExpandMarker = { fg = theme.ui.bg_gutter },
					NeotestUnknown = { fg = theme.syn.constant },
					NeotestSkipped = { fg = theme.syn.type },
					NeotestSummary = { bg = theme.ui.bg_m1 },

					NotifyINFOBody = { bg = theme.ui.bg_gutter, fg = theme.ui.fg },
					NotifyINFOBorder = { bg = theme.ui.bg_gutter, fg = theme.ui.bg_gutter },
					NotifyINFOTitle = { bg = theme.ui.bg_gutter, fg = theme.ui.fg },
					NotifyINFOIcon = { bg = theme.ui.bg_gutter, fg = theme.ui.fg },

					NotifyDEBUGBody = { bg = theme.syn.string, fg = theme.ui.bg_gutter },
					NotifyDEBUGBorder = { bg = theme.syn.string, fg = theme.syn.string },
					NotifyDEBUGTitle = { bg = theme.syn.string, fg = theme.ui.bg_gutter },
					NotifyDEBUGIcon = { bg = theme.syn.string, fg = theme.ui.bg_gutter },

					NotifyERRORBody = { bg = theme.syn.special2, fg = theme.ui.fg },
					NotifyERRORBorder = { bg = theme.syn.special2, fg = theme.syn.special2 },
					NotifyERRORTitle = { bg = theme.syn.special2, fg = theme.ui.fg },
					NotifyERRORIcon = { bg = theme.syn.special2, fg = theme.ui.fg },
					ErrorMsg = { fg = theme.ui.fg },

					NotifyTRACEBody = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },
					NotifyTRACEBorder = { bg = theme.syn.identifier, fg = theme.syn.identifier },
					NotifyTRACETitle = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },
					NotifyTRACEIcon = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },

					NotifyWARNBody = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },
					NotifyWARNBorder = { bg = theme.syn.identifier, fg = theme.syn.identifier },
					NotifyWARNTitle = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },
					NotifyWARNIcon = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },

					MiniTrailspace = { bg = theme.syn.identifier },

					LspSignatureActiveParameter = { fg = theme.syn.identifier },

					OilBackground = { bg = theme.ui.bg_m1 },
					OilBorder = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },
					OilPreviewBackground = { bg = theme.ui.bg_gutter },
					OilPreviewBorder = { bg = theme.ui.bg_gutter, fg = theme.ui.bg_gutter },

					NoicePopup = { bg = theme.ui.bg_gutter, fg = theme.syn.identifier },
					NoicePopupmenu = { bg = theme.ui.bg_gutter, fg = theme.syn.identifier },
					NoicePopupmenuSelected = { bg = theme.ui.bg_gutter, fg = theme.syn.identifier },
					NoiceCmdlinePopup = { bg = theme.ui.bg_gutter },
					NoiceCmdlinePopupBorder = { fg = theme.ui.bg_gutter },
					NoiceCmdlinePopupTitle = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
					NoiceCmdlinePopupIcon = { fg = theme.ui.fg },
					NoiceMissingMenu = { fg = theme.ui.fg, bg = theme.ui.bg_m1 },
					NoiceMissingMenuBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
					NoiceScrollbar = { fg = theme.ui.bg, bg = theme.ui.bg },

					DiagnosticError = { fg = theme.syn.special2 },
					DiagnosticWarn = { fg = theme.syn.constant },
					DiagnosticInfo = { fg = theme.diag.info },
					DiagnosticHint = { fg = theme.syn.identifier },

					AlphaPluginCount = { fg = theme.syn.identifier },
					AlphaFooter = { fg = theme.diag.info },
					AlphaButton = { fg = theme.syn.identifier },
					AlphaButtonKey = { fg = theme.syn.identifier, bg = theme.ui.bg_gutter },
					AlphaBanner = { fg = theme.syn.identifier },

					CmpItemAbbrMatchFuzzy = { fg = theme.syn.identifier },
					CmpItemKindText = { bg = theme.syn.parameter, fg = theme.ui.bg_gutter },
					CmpItemKindMethod = { bg = theme.syn.constant, fg = theme.ui.bg_gutter },
					CmpItemKindFunction = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },
					CmpItemKindConstructor = { bg = theme.syn.statement, fg = theme.ui.bg_gutter },
					CmpItemKindField = { bg = theme.diag.info, fg = theme.ui.bg_gutter },
					CmpItemKindModule = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },
					CmpItemKindVariable = { bg = theme.syn.string, fg = theme.ui.bg_gutter },
					CmpItemKindConstant = { bg = theme.ui.fg, fg = theme.ui.bg_gutter },
					CmpItemKindClass = { bg = theme.syn.statement, fg = theme.ui.bg_gutter },
					CmpItemKindStruct = { bg = theme.syn.statement, fg = theme.ui.bg_gutter },
					CmpItemKindInterface = { bg = theme.syn.special1, fg = theme.ui.bg_gutter },
					CmpItemKindValue = { bg = theme.syn.string, fg = theme.ui.bg_gutter },
					CmpItemKindKeyword = { bg = theme.syn.number, fg = theme.ui.bg_gutter },
					CmpItemKindSnippet = { bg = theme.syn.type, fg = theme.ui.bg_gutter },
					CmpItemKindFile = { bg = theme.syn.parameter, fg = theme.ui.bg_gutter },
					CmpItemKindFolder = { bg = theme.syn.parameter, fg = theme.ui.bg_gutter },
					CmpItemKindEnum = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },
					CmpItemKindEnumMember = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },
					CmpItemKindProperty = { bg = theme.ui.bg_m1, fg = theme.syn.identifier },

					LightspeedShortcut = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },
					LightspeedLabel = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },
					LightspeedOneCharMatch = { bg = theme.syn.identifier, fg = theme.ui.bg_gutter },

					WinSeparator = { fg = theme.ui.bg_m1, bg = theme.ui.bg },

					FzfLuaNormal = { bg = theme.ui.bg_m1 },
					FzfLuaBufName = { bg = theme.ui.bg_m1, fg = theme.ui.fg },
					FzfLuaSearch = { bg = theme.ui.bg_m1 },
					FzfLuaBorder = { bg = theme.ui.bg_gutter, fg = theme.ui.bg_gutter },
					FzfLuaPreviewBorder = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },
					FzfLuaPreviewTitle = { bg = theme.syn.special2, fg = theme.ui.bg_m1 },
				}
			end,
		})
	end,
}
