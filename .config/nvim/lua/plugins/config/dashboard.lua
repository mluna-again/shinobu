require("core.maps")

local function greetings()
	local options = {
		"do you like the way it sounds?",
		"where did it go?",
		"are dreams real?",
		"do you like yellow?",
		"tomorrow will be sunny",
		"tonight will rain",
		"wof, wof, wof",
		"the sky is red",
		"do you remember?",
		"i miss my turtle",
		"i lost my turtle once",
		"try pressing alt-f4",
		"i don't know what else to put here",
		"cyberpunk 2077 wasn't that bad",
		"i like lisp",
		"perl is not that bad",
		"a strange game. the only winning move is not to play.",
		"when in doubt, leave it out.",
		"simplicity is prerequisite for reliability.",
		"the grass is always greener on the other side",
		"the cat ate my source code",
		{
			"",
			"programming is rather thankless. u see your works become replaced by superior",
			"             ones in a year. unable to run at all in a few more."
		},
		"rust is overrated, come at me",
		"insufficient data for meaningful answer",
		"it is what it is",
	}

	math.randomseed(os.time())
	local index = tonumber(math.random(1, #options))

	return options[index]
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

		dashboard.section.footer.opts.position = "center"
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
