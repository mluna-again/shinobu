return {
	"LukasPietzschmann/telescope-tabs",
	lazy = true,
	init = function()
		nmap("Ñ", ":lua require('telescope-tabs').go_to_previous()<CR>")
		nmap("ñ", ":lua require('telescope-tabs').list_tabs()<CR>")
	end,
	config = function()
		require("telescope-tabs").setup({})
	end,
}
