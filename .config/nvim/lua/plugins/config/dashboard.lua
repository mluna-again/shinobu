require('core.maps')


return {
	'glepnir/dashboard-nvim',
	commit = 'f7d623457d6621b25a1292b24e366fae40cb79ab',
	config = function()
		local db = require('dashboard')
		db.custom_header = {
			"█████████████████████████████████████████████████████",
			"██████████████▀▀▀▀▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▀▀▀▜███████████████",
			"█████████▛▀▔                           ▔▀▜███████████",
			"███████▀▔                                  ▀█████████",
			"█████▛                                       ▜███████",
			"████▛                                         ███████",
			"████▍               ▂                         ▝██████",
			"██▛▘             ╼▆███▄▁        ▐▇━╴           ▔▜████",
			"█▛            ▕▙▃   ▔███▇▅▄▃▃▃▃▄▎   ▄▖           ▜███",
			"█▏             ▜█▍ ▐█████████████▉ ▕█▉           ▐███",
			"█▏             ▐█▇▇██████▜██▛▜████▇██▉           ▐███",
			"█▙             ▝████████▙▃▂▂▃▟███████▊          ▄████",
			"███▄▄▇▄▁        ▔▔▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▘▔▁▔     ▂▄██▅▇█████",
			"████████▇▍ ▃▖ ▗▃██▇▇▆▆▆▅▖  ▄▅▆▆▆▇▇██▍ ▄ ▝████████████",
			"████████▀ ▟█▎ █████████▀    ▜███████▊ ▜▙▖▝███████████",
			"███████▘▗▟█▉ ▐████████▙      ▟███████ ▐██▖ ▜█████████",
			"██████▘ ▜██▌ ▟█████████▇▖  ▗█████████▎▕██▛╸ █████████",
			"██████▋ ▂▃    ▔▔▔▔▔▀▀▀▀▀▀▘▝▀▀▀▀▀▔▔▔▔    ▃▄ ▝█████████",
			"██████▙▃▁▁▂                            ▗▂▂▃▟█████████",
			"██████████▍                            ▐█████████████",
			"██████████▄▂                          ▂▟█████████████",
			"█████████████▇▊ ╶╴  ▁▂▂▂▂▂▂▂▂▂▁  ╶  ▇████████████████",
			"██████████████▉     ▐█████████▊     ▟████████████████",
			"██████████████▛▘    ▕█████████▌     ▀████████████████",
			"█████████████▙▃▂▂▂▂▃▃█████████▙▃▂▂▂▂▃▃███████████████",
			"█████████████████████████████████████████████████████",
			""
		}

		db.custom_center = {}
		db.custom_footer = {}
		db.hide_statusline = 1
		db.hide_tabline = 1

		db.custom_center = {
			{ icon = "  ", desc = "New file                       SPC c n", action = "DashboardNewFile" },
			{ icon = "  ", desc = "Find file                      SPC f f", action = "Telescope find_files" },
			{ icon = "  ", desc = "Recent files                   SPC f o", action = "Telescope oldfiles" },
			{ icon = "  ", desc = "Find word                      SPC f w", action = "Telescope live_grep" },
			{ icon = "  ", desc = "Load last session              SPC s l", action = "SessionLoad" },
			{ icon = "  ", desc = "Quit Neovim                          q", action = "quit" },
		}

		nmap("<Leader>sl", ":source Session.vim<CR>")
		nmap("<Leader>ss", ":Obsession<CR>")
		nmap("<Leader>fo", ":Telescope oldfiles<CR>")
		nmap("<Leader>fw", ":Telescope live_grep<CR>")
		nmap("<Leader>ff", ":Telescope find_files<CR>")
		nmap("<Leader>cn", ":DashboardNewFile<CR>")
		nmap("<Leader>fn", ":NvimTreeFindFileToggle<CR>")

		vim.cmd([[
		augroup DashboardTweaks
		autocmd!
		autocmd FileType dashboard set noruler
		autocmd FileType dashboard nmap <buffer> q :quit<CR>
		augroup END
		]])
	end
}
