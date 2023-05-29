return {
	"rebelot/kanagawa.nvim",
	config = function ()
		-- vim.cmd([[
		-- augroup Kanawaga
		-- autocmd!
		-- autocmd ColorScheme * hi Normal guibg=NONE
		-- autocmd ColorScheme * hi TelescopePromptBorder guibg=#16161D guifg=#16161D
		-- autocmd ColorScheme * hi TelescopePromptCounter guibg=#16161D guifg=#C8C093
		-- autocmd ColorScheme * hi TelescopePromptNormal guibg=#16161D guifg=#C8C093
		-- autocmd ColorScheme * hi TelescopePromptTitle guibg=#C34043 guifg=#16161D
		--
		-- autocmd ColorScheme * hi TelescopePreviewBorder guibg=#16161D guifg=#16161D
		-- autocmd ColorScheme * hi TelescopePreviewNormal guibg=#16161D guifg=#C8C093
		-- autocmd ColorScheme * hi TelescopePreviewTitle guibg=#957FB8 guifg=#16161D
		--
		-- autocmd ColorScheme * hi TelescopeResultsBorder guibg=#16161D guifg=#16161D
		-- autocmd ColorScheme * hi TelescopeResultsNormal guibg=#16161D guifg=#C8C093
		-- autocmd ColorScheme * hi TelescopeResultsTitle guibg=#6A9589 guifg=#16161D
		--
		-- autocmd ColorScheme * hi FloatBorder guibg=#16161D guifg=#16161D
		--
		-- autocmd ColorScheme * hi NvimTreeNormal guibg=#16161D
		-- autocmd ColorScheme * hi NvimTreeNormalNC guibg=#16161D
		-- autocmd ColorScheme * hi NvimTreeEndOfBuffer guibg=#16161D guifg=#16161D
		-- autocmd ColorScheme * hi NvimTreeFolderIcon guifg=#E6C384
		--
		-- autocmd ColorScheme * hi DashboardHeader guibg=NONE guifg=#DCD7BA
		-- autocmd ColorScheme * hi DashboardCenter guibg=NONE guifg=#DCD7BA
		-- autocmd ColorScheme * hi DashboardShortCut guibg=NONE guifg=#DCD7BA
		-- autocmd ColorScheme * hi DashboardFooter guibg=NONE guifg=#DCD7BA
		--
		-- autocmd ColorScheme * hi Pmenu guibg=#16161D guifg=#C8C093
		-- autocmd ColorScheme * hi PmenuSel guifg=#16161D guibg=#957FB8
		--
		-- autocmd ColorScheme * hi link CmpItemAbbrMatchFuzzy Aqua
		-- autocmd ColorScheme * hi link CmpItemKindText Fg
		-- autocmd ColorScheme * hi link CmpItemKindMethod Purple
		-- autocmd ColorScheme * hi link CmpItemKindFunction Purple
		-- autocmd ColorScheme * hi link CmpItemKindConstructor Green
		-- autocmd ColorScheme * hi link CmpItemKindField Aqua
		-- autocmd ColorScheme * hi link CmpItemKindVariable Blue
		-- autocmd ColorScheme * hi link CmpItemKindClass Green
		-- autocmd ColorScheme * hi link CmpItemKindInterface Green
		-- autocmd ColorScheme * hi link CmpItemKindValue Orange
		-- autocmd ColorScheme * hi link CmpItemKindKeyword Keyword
		-- autocmd ColorScheme * hi link CmpItemKindSnippet Red
		-- autocmd ColorScheme * hi link CmpItemKindFile Orange
		-- autocmd ColorScheme * hi link CmpItemKindFolder Orange
		--
		-- autocmd ColorScheme * hi Folded guibg=NONE ctermbg=NONE
		--
		-- set fillchars+=vert:\ 
		-- set fillchars+=eob:\ 
		-- augroup end
		-- ]])

		require('kanagawa').setup({
			theme = "dragon",
			colors = {
				theme = {
					all = {
						ui = {
							bg_gutter = "none"
						}
					}
				}
			},
			overrides = function(colors)
				local theme = colors.theme
				return {
					NormalFloat = { bg = "none" },
					FloatBorder = { bg = "none" },
					FloatTitle = { bg = "none" },

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
					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  -- add `blend = vim.o.pumblend` to enable transparency
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },
				}
			end
		})
	end
}
