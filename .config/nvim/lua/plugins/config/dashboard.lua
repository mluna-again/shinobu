require('core.maps')


return {
	'glepnir/dashboard-nvim',
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
			{ icon = "  ", desc = "New File                  SPC c n", action = "DashboardNewFile" },
			{ icon = "  ", desc = "Find File                 SPC f f", action = "Telescope find_files" },
			{ icon = "  ", desc = "Recents                   SPC f o", action = "Telescope oldfiles" },
			{ icon = "  ", desc = "Find Word                 SPC f w", action = "Telescope live_grep" },
			{ icon = "  ", desc = "Load Last Session         SPC s l", action = "SessionLoad" },
			{ icon = "  ", desc = "Quit Neovim                     q", action = "quit" },
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
