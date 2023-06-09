require("core.maps")

local function greetings()
	local time = tonumber(os.date("%H"))

	if time >= 0 and time < 6 then
		return "go to sleep"
	end

	if time >= 6 and time < 12 then
		return "good morning"
	end

	if time >= 12 and time < 18 then
		return "have a nice day :)"
	end

	if time >= 18 and time < 21 then
		return "what a day, huh?"
	end

	return "good night"
	-- return "insufficient data for meaningful answer."
end

return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		require("alpha.term")

		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.buttons.val = {
			dashboard.button("SPC c n", "  New file", ":enew<CR>"),
			dashboard.button("SPC f f", "󰱼  Find file", ":Telescope find_files<CR>"),
			dashboard.button("SPC f o", "  Recent files", ":lua require('telescope.builtin').oldfiles({prompt_title='History'})<CR>"),
			dashboard.button("SPC f w", "  Find word", ":lua require('telescope.builtin').live_grep({prompt_title='Search expression'})<CR>"),
			dashboard.button("SPC s l", "  Load last session", ":source Session.vim<CR>"),
			dashboard.button("q", "󰜎  Quit Neovim", ":q<CR>"),
		}

		local width = vim.fn.winwidth(0)
		dashboard.section.terminal.command = "sh -c '~/.local/banners/center.sh lucky 40'"
		dashboard.section.terminal.width = width
		dashboard.section.terminal.height = 20
		dashboard.section.terminal.opts.position = "center"

		dashboard.section.footer.val = greetings()

		dashboard.config.layout = {
			dashboard.section.terminal,
			{ type = "padding", val = 5 },
			dashboard.section.buttons,
			dashboard.section.footer,
		}

		alpha.setup(dashboard.config)

		vim.cmd([[
    augroup DashboardTweaks
    autocmd!
    autocmd FileType dashboard set noruler
    autocmd FileType dashboard nmap <buffer> q :quit<CR>
    augroup END
    ]])
	end,
}
