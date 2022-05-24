return {
	'lukas-reineke/indent-blankline.nvim',
	config = function()
		vim.opt.list = true
		vim.opt.listchars:append("eol:↴")

		require("indent_blankline").setup {
			show_end_of_line = true,
			filetype_exclude = {'dashboard', 'dockerfile', 'json', 'WhichKey', 'packer', 'glowpreview', ''},
			show_trailing_blankline_indent = false
		}
	end
}
