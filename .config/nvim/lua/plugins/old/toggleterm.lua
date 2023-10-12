require("core.maps")

return {
	"akinsho/toggleterm.nvim",
	event = "VeryLazy",
	config = function()
		require("toggleterm").setup({
			-- size can be a number or function which is passed the current terminal
			size = function(term)
				if term.direction == "horizontal" then
					-- i don't even understand this number, but multiplying it by 0.6 seems to do the trick?
					local h = vim.api.nvim_win_get_height(0)
					return h * 0.6
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.5
				end
			end,
			highlights = {
				Normal = {
					link = "ToggleTermNormal"
				}
			},
			open_mapping = [[<A-m>]],
			shade_terminals = false,
			hide_numbers = true, -- hide the number column in toggleterm buffers
			start_in_insert = true,
			direction = "horizontal",
			close_on_exit = true, -- close the terminal window when the process exits
			auto_scroll = true, -- automatically scroll to the bottom on terminal output
		})

		local wk = require("which-key")
		wk.register({
			t = {
				name = "Testing/Terminal",
				v = { ":ToggleTerm direction=vertical<CR>", "Vertical terminal", noremap = true, silent = true },
				s = { ":ToggleTerm direction=horizontal<CR>", "Horizontal terminal", noremap = true, silent = true },
				t = { ":ToggleTerm<CR>", "Toggle main terminal", noremap = true, silent = true },
			}
		}, {prefix = "<Leader>"})
		tmap("<Leader>ww", "<C-\\><C-n><C-w><C-w>")
	end,
}
