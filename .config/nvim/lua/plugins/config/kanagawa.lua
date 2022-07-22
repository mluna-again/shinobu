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
		augroup end
		]])
		vim.cmd("colorscheme kanagawa")
	end
}
