return {
	"LukasPietzschmann/telescope-tabs",
	lazy = true,
	config = function()
		require("telescope-tabs").setup({})

		nmap("Ñ", ":lua require('telescope-tabs').go_to_previous()<CR>")
		nmap("ñ", ":lua require('telescope-tabs').list_tabs()<CR>")
	end,
}
