return {
	"rebelot/kanagawa.nvim",
	config = function ()
		vim.cmd([[
		augroup Kanawaga
			autocmd!
		  autocmd ColorScheme * hi TelescopePromptBorder guibg=#16161D guifg=#16161D
		  autocmd ColorScheme * hi TelescopePromptCounter guibg=#16161D guifg=#C8C093
		  autocmd ColorScheme * hi TelescopePromptNormal guibg=#16161D guifg=#C8C093
		  autocmd ColorScheme * hi TelescopePromptTitle guibg=#C34043 guifg=#16161D

		  autocmd ColorScheme * hi TelescopePreviewBorder guibg=#16161D guifg=#16161D
		  autocmd ColorScheme * hi TelescopePreviewNormal guibg=#16161D guifg=#C8C093
		  autocmd ColorScheme * hi TelescopePreviewTitle guibg=#957FB8 guifg=#16161D

		  autocmd ColorScheme * hi TelescopeResultsBorder guibg=#16161D guifg=#16161D
		  autocmd ColorScheme * hi TelescopeResultsNormal guibg=#16161D guifg=#C8C093
		  autocmd ColorScheme * hi TelescopeResultsTitle guibg=#6A9589 guifg=#16161D

			autocmd ColorScheme * hi Floaterm guibg=#16161D
			autocmd ColorScheme * hi FloatermBorder guibg=#16161D guifg=#16161D
			
			autocmd ColorScheme * hi VertSplit guibg=#16161D
			autocmd ColorScheme * hi NvimTreeNormal guibg=#16161D
			autocmd ColorScheme * hi NvimTreeNormalNC guibg=#16161D
			autocmd ColorScheme * hi NvimTreeEndOfBuffer guibg=#16161D guifg=#16161D
		augroup end
		]])
		vim.cmd("colorscheme kanagawa")
	end
}
