return {
	"rose-pine/neovim",
	name = "rose-pine",
	event = "VeryLazy",
	config = function()
		require("rose-pine").setup({
			highlight_groups = {
				StatusLineFolderIcon = { bg = "love", fg = "base" },
				StatusLineFileIcon = { bg = "rose", fg = "base" },
				StatusLineModeIcon = { bg = "foam", fg = "base" },
				StatusLineBranchIcon = { bg = "pine", fg = "text" },
				StatusLineProgressIcon = { bg = "gold", fg = "base" },
				StatusLineNormalNormal = { bg = "base", fg = "text" },

				TelescopeTitle = { fg = "foam", bold = true },
				TelescopePromptNormal = { bg = "surface" },
				TelescopePromptBorder = { fg = "surface", bg = "surface" },
				TelescopeResultsNormal = { fg = "subtle", bg = "overlay" },
				TelescopeResultsBorder = { fg = "overlay", bg = "overlay" },
				TelescopePreviewNormal = { bg = "highlight_low" },
				TelescopePreviewBorder = { bg = "highlight_low", fg = "highlight_low" },
				TelescopePromptTitle = { bg = "love", fg = "base" },
				TelescopePreviewTitle = { bg = "foam", fg = "base" },
				TelescopeResultsTitle = { bg = "gold", fg = "base" },
				TelescopeMatching = { fg = "love" },

				NoicePopup = { bg = "highlight_low", fg = "love" },
				NoicePopupmenu = { bg = "highlight_low", fg = "love" },
				NoicePopupmenuSelected = { bg = "highlight_low", fg = "love" },
				NoiceCmdlinePopup = { bg = "highlight_low" },
				NoiceCmdlinePopupBorder = { fg = "highlight_low" },
				NoiceCmdlinePopupTitle = { fg = "highlight_low", bg = "love" },
				NoiceCmdlinePopupIcon = { fg = "text" },
				NoiceMissingMenu = { fg = "text", bg = "overlay" },
				NoiceMissingMenuBorder = { fg = "overlay", bg = "overlay" },
				NoiceScrollbar = { fg = "base", bg = "base" },

				Cursor = { fg = "text", bg = "base", inherit = false },
				CursorLine = { fg = "text", bg = "base", inherit = false },

				OilBackground = { bg = "highlight_low" },
				OilBorder = { bg = "highlight_low", fg = "highlight_low" },
				OilPreviewBackground = { bg = "base" },
				OilPreviewBorder = { bg = "base", fg = "base" },

				NotifyINFOBody = { bg = "highlight_low", fg = "text", inherit = false },
				NotifyINFOBorder = { bg = "highlight_low", fg = "highlight_low", inherit = false },
				NotifyINFOTitle = { bg = "highlight_low", fg = "text", inherit = false },
				NotifyINFOIcon = { bg = "highlight_low", fg = "text", inherit = false },

				NotifyDEBUGBody = { bg = "gold", fg = "text", inherit = false },
				NotifyDEBUGBorder = { bg = "gold", fg = "gold", inherit = false },
				NotifyDEBUGTitle = { bg = "gold", fg = "text", inherit = false },
				NotifyDEBUGIcon = { bg = "gold", fg = "text", inherit = false },

				NotifyERRORBody = { bg = "love", fg = "text", inherit = false },
				NotifyERRORBorder = { bg = "love", fg = "love", inherit = false },
				NotifyERRORTitle = { bg = "love", fg = "text", inherit = false },
				NotifyERRORIcon = { bg = "love", fg = "text", inherit = false },
				ErrorMsg = { fg = "text" },

				NotifyTRACEBody = { bg = "love", fg = "base", inherit = false },
				NotifyTRACEBorder = { bg = "love", fg = "love", inherit = false },
				NotifyTRACETitle = { bg = "love", fg = "base", inherit = false },
				NotifyTRACEIcon = { bg = "love", fg = "base", inherit = false },

				NotifyWARNBody = { bg = "love", fg = "base", inherit = false },
				NotifyWARNBorder = { bg = "love", fg = "love", inherit = false },
				NotifyWARNTitle = { bg = "love", fg = "base", inherit = false },
				NotifyWARNIcon = { bg = "love", fg = "base", inherit = false },

				NeoTreeNormal = { bg = "highlight_low" },
				NeoTreeNormalNC = { bg = "highlight_low" },
				NeoTreeFloatBorder = { bg = "base", fg = "base" },
				NeoTreeTabActive = { bg = "base", fg = "love" },
				NeoTreeTabInactive = { bg = "base", fg = "muted" },
				NeoTreeTabSeparatorActive = { fg = "base" },
				NeoTreeTabSeparatorInactive = { fg = "base" },
				NeoTreeVertSplit = { fg = "base", bg = "base" },
			},
		})
	end,
}
