require("core.maps")

return {
	'akinsho/toggleterm.nvim',
	config = function()
		require("toggleterm").setup({
			-- size can be a number or function which is passed the current terminal
			size = function(term)
				if term.direction == "horizontal" then
					return vim.api.nvim_buf_line_count(0) * 0.4
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.5
				end
			end,
			open_mapping = [[<A-m>]],
			shade_terminals = false,
			hide_numbers = true, -- hide the number column in toggleterm buffers
			start_in_insert = true,
			direction = 'horizontal',
			close_on_exit = true, -- close the terminal window when the process exits
			auto_scroll = true -- automatically scroll to the bottom on terminal output
		})

		tmap("<C-w><C-w>", "<C-\\><C-n><C-w><C-w>")
		nmap("<Leader>tv", ":ToggleTerm direction=vertical<CR>")
		nmap("<Leader>ts", ":ToggleTerm direction=horizontal<CR>")
	end
}
