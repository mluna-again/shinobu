require('core.maps')

return {
	'tpope/vim-fugitive',
	config = function ()
		nmap("<leader>gd", ":Gvdiffsplit!<CR>")
		nmap("gdr", ":diffget //2<CR>")
		nmap("gdt", ":diffget //2<CR>")
	end
}
