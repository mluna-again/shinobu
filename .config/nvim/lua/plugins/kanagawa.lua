return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		vim.opt.fillchars = {
			horiz = "━",
			horizup = "┻",
			horizdown = "┳",
			vert = "┃",
			vertleft = "┫",
			vertright = "┣",
			verthoriz = "╋",
			eob = " "
		}
		-- vim.opt.fillchars = {
		-- 	horiz = " ",
		-- 	horizup = " ",
		-- 	horizdown = " ",
		-- 	vert = " ",
		-- 	vertleft = " ",
		-- 	vertright = " ",
		-- 	verthoriz = " ",
		-- 	eob = " "
		-- }

		-- vim.cmd([[
		-- 	augroup CursorLine
		-- 	au!
		-- 	au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
		-- 	au WinLeave * setlocal nocursorline
		-- 	augroup END
		-- ]])

		local colors_override = {
			theme = {
				all = {
					ui = {
						bg = "none"
					}
				}
			}
		}

		if vim.g.neovide then
			colors_override = {}
		end

		require("kanagawa").setup({
			theme = "dragon",
			keywordStyle = { italic = false },
			commentStyle = { italic = false },
			colors = colors_override,
			overrides = function(colors)
				local theme = colors.theme
				return {
					-- Save an hlgroup with dark background and dimmed foreground
					-- so that you can use it where your still want darker windows.
					-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark

					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					Normal = { fg = theme.ui.fg_dim, bg = theme.ui.bg },

					Input1 = { bg = theme.ui.bg_p1 },
					Input1Border = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
					Input2 = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
					Input2Border = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
					Input3 = { bg = theme.ui.bg_dim },
					Input3Border = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

					-- Popular plugins that open floats will link to NormalFloat by default;
					-- set their background accordingly if you wish to keep them dark and borderless
					LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

					MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

					TelescopeTitle = { fg = theme.syn.regex, bold = true },
					TelescopePromptNormal = { bg = theme.ui.bg_p1 },
					TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
					TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
					TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
					TelescopePreviewNormal = { bg = theme.ui.bg_dim },
					TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
					TelescopePromptTitle = { bg = theme.syn.identifier, fg = theme.ui.bg_dim },
					TelescopePreviewTitle = { bg = theme.syn.regex, fg = theme.ui.bg_dim },
					TelescopeResultsTitle = { bg = theme.syn.statement, fg = theme.ui.bg_dim },
					TelescopeMatching = { fg = theme.syn.regex },

					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },

					Search = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
					IncSearch = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
					CurSearch = { fg = theme.ui.bg_gutter, bg = theme.syn.constant },
					Substitute = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
					Visual = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },

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

					BufferLineBufferModified = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
					BufferLineBufferModifiedVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineBufferSelected = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
					BufferLineBufferVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineModified = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineModifiedVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineModifiedSelected = { fg = theme.ui.bg, bg = theme.syn.identifier },
					BufferLineSelected = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
					BufferLineVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLine = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineDuplicate = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineDuplicateVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineDuplicateSelected = { fg = theme.ui.bg, bg = theme.syn.identifier },
					BufferLineBackground = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineSeparator = { fg = theme.ui.bg_gutter, bg = theme.ui.bg },
					BufferLineSeparatorVisible = { fg = theme.ui.bg_gutter, bg = theme.ui.bg },
					BufferLineSeparatorSelected = { fg = theme.ui.bg_gutter, bg = theme.ui.bg },
					BufferLineIndicator = { fg = theme.ui.bg, bg = theme.ui.bg },
					BufferLineIndicatorSelected = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
					BufferLineIndicatorVisible = { fg = theme.syn.parameter, bg = theme.ui.bg_gutter },
					BufferLineTruncMarker = { fg = theme.syn.identifier, bg = theme.ui.bg_gutter },
					BufferLineTab = { fg = theme.syn.identifier, bg = theme.ui.bg_gutter },
					BufferLineTabSelected = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
					BufferLineTabSeparator = { fg = theme.ui.bg_gutter, bg = theme.ui.bg_gutter },
					BufferLineTabSeparatorSelected = { fg = theme.syn.identifier, bg = theme.syn.identifier },
					BufferLineFill = { fg = theme.ui.fg, bg = theme.ui.bg },

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

					NotificationInfo = { bg = theme.ui.bg_gutter, fg = theme.ui.fg },
					NotificationWarning = { bg = theme.syn.string, fg = theme.ui.bg_gutter },
					NotificationError = { bg = theme.syn.special2, fg = theme.ui.fg },

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
					NoiceCmdlinePopupIcon = { fg = theme.ui.fg, bg = theme.ui.bg_gutter },
					NoiceMissingMenu = { fg = theme.ui.fg, bg = theme.ui.bg_m1 },
					NoiceMissingMenuBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
					NoiceCmdlineIconLua = { fg = theme.ui.fg, bg = theme.ui.bg_gutter },
					NoiceCmdlineIconHelp = { fg = theme.ui.fg, bg = theme.ui.bg_gutter },
					NoiceScrollbar = { fg = theme.ui.bg, bg = theme.ui.bg },
					NoiceVirtualText = { fg = theme.syn.identifier, bg = theme.ui.bg },

					DiagnosticError = { fg = theme.syn.special2, bg = theme.ui.bg },
					DiagnosticWarn = { fg = theme.syn.constant, bg = theme.ui.bg },
					DiagnosticInfo = { fg = theme.diag.info, bg = theme.ui.bg },
					DiagnosticHint = { fg = theme.syn.identifier, bg = theme.ui.bg },
					DiagnosticSignWarn = { fg = theme.syn.constant, bg = theme.ui.bg },
					DiagnosticSignError = { fg = theme.syn.special2, bg = theme.ui.bg },
					DiagnosticSignInfo = { fg = theme.diag.info, bg = theme.ui.bg },
					DiagnosticSignHint = { fg = theme.syn.identifier, bg = theme.ui.bg },
					DiagnosticFloatingError = { fg = theme.syn.special2, bg = theme.ui.bg_gutter },
					DiagnosticFloatingWarn = { fg = theme.syn.constant, bg = theme.ui.bg_gutter },
					DiagnosticFloatingInfo = { fg = theme.diag.info, bg = theme.ui.bg_gutter },
					DiagnosticFloatingHint = { fg = theme.syn.identifier, bg = theme.ui.bg_gutter },
					DiagnosticFloatingSignWarn = { fg = theme.syn.constant, bg = theme.ui.bg_gutter },
					DiagnosticFloatingSignError = { fg = theme.syn.special2, bg = theme.ui.bg_gutter },
					DiagnosticFloatingSignInfo = { fg = theme.diag.info, bg = theme.ui.bg_gutter },
					DiagnosticFloatingSignHint = { fg = theme.syn.identifier, bg = theme.ui.bg_gutter },

					AlphaPluginCount = { fg = theme.syn.identifier },
					AlphaNvimVersion = { fg = theme.syn.keyword },
					AlphaFooter = { fg = theme.syn.keyword },
					AlphaButton = { fg = theme.syn.identifier },
					AlphaButtonKey = { fg = theme.syn.identifier, bg = theme.ui.bg_gutter },
					AlphaBanner = { fg = theme.syn.identifier },

					CmpDocumentationBorder = { fg = theme.syn.identifier, bg = theme.ui.bg },
					CmpDocumentation = { fg = theme.syn.identifier, bg = theme.ui.bg },
					CmpCompletionBorder = { fg = theme.syn.identifier, bg = theme.ui.bg },
					CmpCompletion = { fg = theme.syn.identifier, bg = theme.ui.bg },
					-- CmpItemAbbrMatchFuzzy = { fg = theme.syn.identifier },
					-- CmpItemKindText = { fg = theme.syn.parameter, bg = theme.ui.bg },
					-- CmpItemKindMethod = { fg = theme.syn.constant, bg = theme.ui.bg },
					-- CmpItemKindFunction = { fg = theme.syn.identifier, bg = theme.ui.bg },
					-- CmpItemKindConstructor = { fg = theme.syn.statement, bg = theme.ui.bg },
					-- CmpItemKindField = { fg = theme.diag.info, bg = theme.ui.bg },
					-- CmpItemKindModule = { fg = theme.syn.identifier, bg = theme.ui.bg },
					-- CmpItemKindVariable = { fg = theme.syn.string, bg = theme.ui.bg },
					-- CmpItemKindConstant = { fg = theme.ui.fg, bg = theme.ui.bg },
					-- CmpItemKindClass = { fg = theme.syn.statement, bg = theme.ui.bg },
					-- CmpItemKindStruct = { fg = theme.syn.statement, bg = theme.ui.bg },
					-- CmpItemKindInterface = { fg = theme.syn.special1, bg = theme.ui.bg },
					-- CmpItemKindValue = { fg = theme.syn.string, bg = theme.ui.bg },
					-- CmpItemKindKeyword = { fg = theme.syn.number, bg = theme.ui.bg },
					-- CmpItemKindSnippet = { fg = theme.syn.type, bg = theme.ui.bg },
					-- CmpItemKindFile = { fg = theme.syn.parameter, bg = theme.ui.bg },
					-- CmpItemKindFolder = { fg = theme.syn.parameter, bg = theme.ui.bg },
					-- CmpItemKindEnum = { fg = theme.syn.identifier, bg = theme.ui.bg },
					-- CmpItemKindEnumMember = { fg = theme.syn.identifier, bg = theme.ui.bg },
					-- CmpItemKindProperty = { fg = theme.ui.bg_m1, bg = theme.syn.identifier },

					LeapLabelPrimary = { bg = theme.syn.identifier, fg = theme.ui.bg_m1 },
					LeapLabelSecondary = { bg = theme.syn.identifier, fg = theme.ui.bg_m1 },
					LeapLabelSelected = { bg = theme.syn.identifier, fg = theme.ui.bg_m1 },
					LeapMatch = { bg = theme.syn.identifier, fg = theme.ui.bg_m1 },

					WinSeparator = { fg = theme.ui.bg_gutter, bg = theme.ui.bg },

					FzfLuaNormal = { bg = theme.ui.bg_m1 },
					FzfLuaBufName = { bg = theme.ui.bg_m1, fg = theme.ui.fg },
					FzfLuaSearch = { bg = theme.ui.bg_m1 },
					FzfLuaBorder = { bg = theme.ui.bg_gutter, fg = theme.ui.bg_gutter },
					FzfLuaPreviewBorder = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },
					FzfLuaPreviewTitle = { bg = theme.syn.special2, fg = theme.ui.bg_m1 },

					CursorLine = { bg = theme.syn.bg, fg = theme.ui.fg },
					CursorLineNr = { bg = theme.syn.bg, fg = theme.syn.comment },

					MatchParen = { fg = theme.syn.regex },

					StatusLineFolderIcon = { bg = theme.syn.special2, fg = theme.ui.bg_m1 },
					StatusLineFileIcon = { bg = theme.syn.identifier, fg = theme.ui.bg_m1 },
					StatusLineModeIcon = { bg = theme.syn.regex, fg = theme.ui.bg_m1 },
					StatusLineBranchIcon = { bg = theme.syn.keyword, fg = theme.ui.bg_m1 },
					StatusLineProgressIcon = { bg = theme.syn.identifier, fg = theme.ui.bg_m1 },
					StatusLineNormalNormal = { bg = theme.ui.bg, fg = theme.ui.fg },
					StatusLineNormalMode = { bg = theme.syn.regex, fg = theme.ui.fg },
					StatusLineInsertMode = { bg = theme.syn.identifier, fg = theme.ui.fg },
					StatusLineVisualMode = { bg = theme.syn.special1, fg = theme.ui.bg },
					StatusLineReplaceMode = { bg = theme.syn.constant, fg = theme.ui.fg },
					StatusLineCommandMode = { bg = theme.syn.keyword, fg = theme.ui.fg },
					StatusLineInactiveMode = { bg = theme.syn.comment, fg = theme.ui.fg },

					LineNr = { fg = theme.syn.comment, bg = theme.ui.bg },
					SignColumn = { fg = theme.syn.comment, bg = theme.ui.bg },
					GitSignsAdd = { fg = theme.syn.green, bg = theme.ui.bg },
					GitSignsAddNr = { fg = theme.syn.green, bg = theme.ui.bg },
					GitSignsAddLn = { fg = theme.syn.green, bg = theme.ui.bg },
					GitSignsChange = { fg = theme.syn.identifier, bg = theme.ui.bg },
					GitSignsChangeNr = { fg = theme.syn.identifier, bg = theme.ui.bg },
					GitSignsChangeLn = { fg = theme.syn.identifier, bg = theme.ui.bg },
					GitSignsDelete = { fg = theme.syn.operator, bg = theme.ui.bg },
					GitSignsDeleteNr = { fg = theme.syn.operator, bg = theme.ui.bg },
					GitSignsDeleteLn = { fg = theme.syn.operator, bg = theme.ui.bg },

					ToggleTermNormal = { bg = theme.ui.bg_m2 },

					TroubleNormal = { bg = theme.ui.bg_m2 },

					BqfSign = { fg = theme.syn.identifier },
					BqfPreviewBorder = { bg = theme.ui.bg, fg = theme.syn.identifier },
					BqfPreviewSbar = { bg = theme.ui.bg, fg = theme.syn.identifier },
					BqfPreviewTitle = { bg = theme.ui.bg, fg = theme.syn.identifier },
					BqfPreviewThumb = { fg = theme.syn.identifier, bg = theme.syn.identifier },
					BqfPreviewBufLabel = { bg = theme.syn.identifier, fg = theme.ui.bg },
					BqfPreviewCursorLine = { bg = theme.ui.bg },

					Folded = { bg = theme.ui.bg },
					UfoFoldedEllipsis = { bg = theme.ui.bg_gutter },

					NeogitBranch = { fg = theme.syn.statement },
					NeogitPicking = { fg = theme.syn.statement },
					NeogitStashes = { fg = theme.syn.statement },
					NeogitTagName = { fg = theme.syn.statement },
					NeogitFilePath = { fg = theme.syn.statement },
					NeogitRebasing = { fg = theme.syn.statement },
					NeogitGraphBlue = { fg = theme.syn.statement },
					NeogitReverting = { fg = theme.syn.statement },
					NeogitBranchHead = { fg = theme.syn.statement },
					NeogitDiffHeader = { fg = theme.syn.statement },
					NeogitUnpushedTo = { fg = theme.syn.statement },
					NeogitGraphPurple = { fg = theme.syn.statement },
					NeogitUnmergedInto = { fg = theme.syn.statement },
					NeogitUnpulledFrom = { fg = theme.syn.statement },
					NeogitChangeRenamed = { fg = theme.syn.statement },
					NeogitGraphBoldBlue = { fg = theme.syn.statement },
					NeogitRecentcommits = { fg = theme.syn.statement },
					NeogitSectionHeader = { fg = theme.syn.statement },
					NeogitStagedchanges = { fg = theme.syn.statement },
					NeogitChangeModified = { fg = theme.syn.statement },
					NeogitPopupActionKey = { fg = theme.syn.statement },
					NeogitPopupConfigKey = { fg = theme.syn.statement },
					NeogitPopupSwitchKey = { fg = theme.syn.statement },
					NeogitUntrackedfiles = { fg = theme.syn.statement },
					NeogitGraphBoldPurple = { fg = theme.syn.statement },
					NeogitUnmergedchanges = { fg = theme.syn.statement },
					NeogitUnpulledchanges = { fg = theme.syn.statement },
					NeogitUnstagedchanges = { fg = theme.syn.statement },
					NeogitSignatureMissing = { fg = theme.syn.statement },
					NeogitChangeBothModified = { fg = theme.syn.statement },
					NeogitSignatureGoodUnknown = { fg = theme.syn.statement },
					NeogitSignatureGoodExpiredKey = { fg = theme.syn.statement },
					NeogitDiffAdd = { bg = theme.diff.add, fg = theme.ui.fg },
					NeogitDiffAddHighlight = { bg = theme.diff.add, fg = theme.ui.fg },
					NeogitDiffDelete = { bg = theme.diff.delete, fg = theme.ui.fg },
					NeogitDiffDeleteHighlight = { bg = theme.diff.delete, fg = theme.ui.fg },
					NeogitDiffHeader = { bg = theme.ui.bg, fg = theme.ui.fg },
					NeogitDiffHeaderHighlight = { bg = theme.ui.bg, fg = theme.ui.fg },
					NeogitRemote = { fg = theme.syn.number, bg = theme.ui.bg },
					NeogitDiffContext = { fg = theme.ui.fg, bg = theme.diff.change },
					NeogitDiffContextHighlight = { fg = theme.ui.fg, bg = theme.diff.change },
					NeogitCommitViewHeader = { fg = theme.syn.statement, bg = theme.ui.bg },

					DiffviewFilePanelTitle = { fg = theme.syn.statement },
					DiffviewFilePanelCounter = { fg = theme.syn.statement },
					DiffviewFilePrimary = { fg = theme.syn.identifier },
					DiffviewFileSecondary = { fg = theme.syn.operator },
				}
			end,
		})
	end,
}
