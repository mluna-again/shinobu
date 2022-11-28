require('core.maps')

nmap("<Leader>tm", ":TableModeToggle<CR>")

return {
	'dhruvasagar/vim-table-mode',
	config = function ()
		vim.g.table_mode_corner = '|'
	end
}
