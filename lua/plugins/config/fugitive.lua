require('core.maps')

return {
	'tpope/vim-fugitive',
	config = function ()
		nmap("<leader>gd", ":Gvdiffsplit!<CR>")
		nmap("gdh", ":diffget //2<CR>")
		nmap("gdl", ":diffget //3<CR>")
	end
}
