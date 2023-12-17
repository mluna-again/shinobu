require("core.maps")

local function get_nvim_version()
  local ver = vim.version()

  local major = ver["major"]
  local minor = ver["minor"]
  local patch = ver["patch"]

  local formatted = string.format("v%s.%s.%s", major, minor, patch)
	if ver["api_prerelease"] then
		local type = ver["prerelease"]
		local build = ver["build"]
		formatted = string.format("%s-%s-%s", formatted, type, build)
	end

	return formatted
end

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
			"programming is rather thankless. u see your works become replaced by superior",
			"             ones in a year. unable to run at all in a few more.",
		},
		{
			"debugging is twice as hard as writing the code in the first place. therefore, if you write the code",
			"          as cleverly as possible, you are, by definition, not smart enough to debug it.",
		},
		"rust is overrated, come at me",
		"insufficient data for meaningful answer",
		"it is what it is",
		"in the face of ambiguity, refuse the temptation to guess",
		"in the face of ambiguity, refuse the temptation to guess",
		"in the face of ambiguity, refuse the temptation to guess",
		"in the face of ambiguity, refuse the temptation to guess",
		"in the face of ambiguity, refuse the temptation to guess",
		"let it crash",
		"let it crash",
		"let it crash",
		"let it crash",
		"too bad she won't live, but then again, who does?",
		"i've seen things you people wouldn't believe...",
		"they didn't suffer",
		"is this all there is?",
		"there is no such thing as that rose-colored life",
		"unix is my ide",
		"explicit is better than implicit. clear code is better than concise code",
		{
			"        The only truly secure system is one that is powered off, cast in a block of",
			"concrete and sealed in a lead-lined room with armed guards — and even then I have my doubts.",
		},
		"there is no quote today",
		"Happ33##n0T++-b$rthdy11"
	}

	math.randomseed(os.time())
	local index = tonumber(math.random(1, #options))

	return options[index]
end

local function mkButton(key, desc, action)
	local button = require("alpha.themes.dashboard").button

	local btn = button(key, desc, action)
	btn.opts.hl = "AlphaButton"
	btn.opts.hl_shortcut = "AlphaButtonKey"
	btn.opts.cursor = 0

	return btn
end

return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")

		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.buttons.val = {
			mkButton("    i    ", "New file", ":enew|startinsert<CR>"),
			-- mkButton(" SPC f f ", "Find file", ":FzfLua files<CR>"),
			mkButton(" SPC f f ", "Find file", ":Telescope find_files<CR>"),
			mkButton(
				" SPC f o ",
				"Recent files",
				":lua require('telescope.builtin').oldfiles({prompt_title='History'})<CR>"
			),
			mkButton(
				" SPC f w ",
				"Find word",
				":lua require('telescope.builtin').live_grep({prompt_title='Search expression'})<CR>"
			),
			mkButton(" SPC s l ", "Load last session", ":silent SessionLoad<CR>"),
			mkButton("    q    ", "Quit Neovim", ":q<CR>"),
		}

		local plugins_count = require("lazy").stats().count
		local banner = {
			type = "text",
			val = {
				"                                            ██████████                                  ",
				"                                      ░░  ██░░░░░░░░░░██                                ",
				"                                        ██░░░░░░░░░░░░░░██                              ",
				"                                        ██░░░░░░░░████░░██████████                      ",
				"                            ██          ██░░░░░░░░████░░██▒▒▒▒▒▒██                      ",
				"                          ██░░██        ██░░░░░░░░░░░░░░██▒▒▒▒▒▒██                      ",
				"                          ██░░░░██      ██░░░░░░░░░░░░░░████████                        ",
				"                        ██░░░░░░░░██      ██░░░░░░░░░░░░██                              ",
				"                        ██░░░░░░░░████████████░░░░░░░░██                                ",
				"                        ██░░░░░░░░██░░░░░░░░░░░░░░░░░░░░██                              ",
				"                        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██                            ",
				"                        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██                            ",
				"                        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██                            ",
				"                        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██                            ",
				"                        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██                            ",
				"                        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██                              ",
				"                          ██░░░░░░░░░░░░░░░░░░░░░░░░░░██                                ",
				"                            ██████░░░░░░░░░░░░░░░░████                                  ",
				"                                  ████████████████                                      ",
				"                                                                                        ",
				"                                                                                        ",
			},
			opts = {
				position = "center",
				hl = "AlphaBanner",
			},
		}

		dashboard.section.footer.opts.position = "center"
		dashboard.section.footer.opts.hl = "AlphaFooter"
		dashboard.section.footer.val = greetings()

		dashboard.config.layout = {
			{
				type = "padding",
				val = 2,
			},
			banner,
			{
				type = "padding",
				val = 3,
			},
			dashboard.section.buttons,
			{
				type = "padding",
				val = 1,
			},
			dashboard.section.footer,
			{
				type = "padding",
				val = 1,
			},
			{
				type = "text",
				val = "",
				opts = {
					position = "center",
					hl = "AlphaPluginCount",
				},
			},
			{
				type = "padding",
				val = 1,
			},
			{
				type = "text",
				val = get_nvim_version(),
				opts = {
					position = "center",
					hl = "AlphaNvimVersion",
				},
			},
		}

		alpha.setup(dashboard.config)

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			callback = function()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				dashboard.config.layout[8].val = string.format("%d plugins loaded in %dms", stats.count, ms)
				pcall(vim.cmd.AlphaRedraw)
			end,
		})

		vim.cmd([[
		augroup DashboardTweaks
		autocmd!
		autocmd FileType alpha set noruler
		augroup END
		]])
	end,
}
