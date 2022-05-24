require('core.maps')

return {
	'tpope/vim-fugitive',
	config = function ()
		nmap("<leader>gd", ":Gvdiffsplit!<CR>")
		nmap("<leader>gt", ":Git mergetool<CR>")
		nmap("gdj", ":diffget //2<CR>")
		nmap("gdk", ":diffget //3<CR>")
	end
}
