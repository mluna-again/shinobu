return {
	"rebelot/kanagawa.nvim",
	config = function ()
		vim.cmd("colorscheme kanagawa")
		-- vim.cmd([[
		-- augroup Kanawaga
		-- 	autocmd!
		--   autocmd ColorScheme * hi TelescopePromptBorder guibg=#C8C093 guifg=#C8C093
		--   autocmd ColorScheme * hi TelescopePromptCounter guibg=#C8C093 guifg=#C8C093
		-- augroup end
		-- ]])
	end
}
