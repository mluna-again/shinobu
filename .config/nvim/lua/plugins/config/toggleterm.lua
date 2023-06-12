require("core.maps")

return {
	"akinsho/toggleterm.nvim",
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
			open_mapping = [[<A-m>]],
			shade_terminals = false,
			hide_numbers = true, -- hide the number column in toggleterm buffers
			start_in_insert = true,
			direction = "horizontal",
			close_on_exit = true, -- close the terminal window when the process exits
			auto_scroll = true, -- automatically scroll to the bottom on terminal output
		})

		local term = require("toggleterm.terminal").Terminal
		local lazygit = term:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
			on_open = function()
				vim.cmd("startinsert!")
			end,
			float_opts = {
				border = "solid",
			},
			highlights = {
				Normal = {
					link = "TelescopePromptNormal",
				},
				NormalFloat = {
					link = "TelescopePromptNormal",
				},
				FloatBorder = {
					link = "TelescopePromptNormal",
				},
			},
		})

		local function toggle_lazy()
			lazygit:toggle()
		end

		local spotify = term:new({
			cmd = "spotify_player",
			hidden = true,
			direction = "float",
			on_open = function()
				vim.cmd("startinsert!")
			end,
			float_opts = {
				border = "solid",
			},
			highlights = {
				Normal = {
					link = "TelescopePromptNormal",
				},
				NormalFloat = {
					link = "TelescopePromptNormal",
				},
				FloatBorder = {
					link = "TelescopePromptNormal",
				},
			},
		})

		local function toggle_spotify()
			spotify:toggle()
		end

		tmap("<Leader>ww", "<C-\\><C-n><C-w><C-w>")
		nmap("<Leader>tv", ":ToggleTerm direction=vertical<CR>")
		nmap("<Leader>ts", ":ToggleTerm direction=horizontal<CR>")
		nmap("<Leader>tl", "<cmd>lua _toggle_lazy()<CR>")

		vim.api.nvim_create_user_command("LG", function() toggle_lazy() end, {})
		vim.api.nvim_create_user_command("Spotify", function() toggle_spotify() end, {})
	end,
}
