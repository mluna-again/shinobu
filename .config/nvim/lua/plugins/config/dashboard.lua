require("core.maps")

return {
	"glepnir/dashboard-nvim",
	config = function()
		require("dashboard").setup({
			theme = "doom", --  theme is doom and hyper default is hyper
			disable_move = false, --  defualt is false disable move keymap for hyper
			shortcut_type = "letter", --  shorcut type 'letter' or 'number'
			hide = {
				statusline = true, -- hide statusline default is true
				tabline = true, -- hide the tabline
				winbar = true, -- hide winbar
			},
			preview = {
			  command = "chafa --center on",
			  file_path = "~/.local/banners/rice.png",
			  file_height = 15,
			  file_width = 80
			},
			config = {
				-- header = {
				-- 	"",
				-- 	"",
				-- 	"█████████████████████████████████████████████████████",
				-- 	"██████████████▀▀▀▀▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▀▀▀▜███████████████",
				-- 	"█████████▛▀▔                           ▔▀▜███████████",
				-- 	"███████▀▔                                  ▀█████████",
				-- 	"█████▛                                       ▜███████",
				-- 	"████▛                                         ███████",
				-- 	"████▍               ▂                         ▝██████",
				-- 	"██▛▘             ╼▆███▄▁        ▐▇━╴           ▔▜████",
				-- 	"█▛            ▕▙▃   ▔███▇▅▄▃▃▃▃▄▎   ▄▖           ▜███",
				-- 	"█▏             ▜█▍ ▐█████████████▉ ▕█▉           ▐███",
				-- 	"█▏             ▐█▇▇██████▜██▛▜████▇██▉           ▐███",
				-- 	"█▙             ▝████████▙▃▂▂▃▟███████▊          ▄████",
				-- 	"███▄▄▇▄▁        ▔▔▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▘▔▁▔     ▂▄██▅▇█████",
				-- 	"████████▇▍ ▃▖ ▗▃██▇▇▆▆▆▅▖  ▄▅▆▆▆▇▇██▍ ▄ ▝████████████",
				-- 	"████████▀ ▟█▎ █████████▀    ▜███████▊ ▜▙▖▝███████████",
				-- 	"███████▘▗▟█▉ ▐████████▙      ▟███████ ▐██▖ ▜█████████",
				-- 	"██████▘ ▜██▌ ▟█████████▇▖  ▗█████████▎▕██▛╸ █████████",
				-- 	"██████▋ ▂▃    ▔▔▔▔▔▀▀▀▀▀▀▘▝▀▀▀▀▀▔▔▔▔    ▃▄ ▝█████████",
				-- 	"██████▙▃▁▁▂                            ▗▂▂▃▟█████████",
				-- 	"██████████▍                            ▐█████████████",
				-- 	"██████████▄▂                          ▂▟█████████████",
				-- 	"█████████████▇▊ ╶╴  ▁▂▂▂▂▂▂▂▂▂▁  ╶  ▇████████████████",
				-- 	"██████████████▉     ▐█████████▊     ▟████████████████",
				-- 	"██████████████▛▘    ▕█████████▌     ▀████████████████",
				-- 	"█████████████▙▃▂▂▂▂▃▃█████████▙▃▂▂▂▂▃▃███████████████",
				-- 	"█████████████████████████████████████████████████████",
				-- 	"",
				-- }, --your header
				center = {
					{
						icon = "  ",
						icon_hl = "group",
						desc = "New File",
						desc_hl = "group",
						key = "SPC c n",
						key_hl = "group",
						action = "enew",
						surroundings = ""
					},
					{
						icon = "  ",
						icon_hl = "group",
						desc = "Find File",
						desc_hl = "group",
						key = "SPC f f",
						key_hl = "group",
						action = "Telescope find_files",
						surroundings = ""
					},
					{
						icon = "  ",
						icon_hl = "group",
						desc = "Recent Files",
						desc_hl = "group",
						key = "SPC f o",
						key_hl = "group",
						action = "Telescope oldfiles",
						surroundings = ""
					},
					{
						icon = "  ",
						icon_hl = "group",
						desc = "Find Word",
						desc_hl = "group",
						key = "SPC f w",
						key_hl = "group",
						action = "Telescope live_grep",
						surroundings = ""
					},
					{
						icon = "  ",
						icon_hl = "group",
						desc = "Load Last Session",
						desc_hl = "group",
						key = "SPC s l",
						key_hl = "group",
						action = "SessionLoad",
						surroundings = ""
					},
					{
						icon = "  ",
						icon_hl = "group",
						desc = "Quit Neovim",
						desc_hl = "group",
						key = "q",
						key_hl = "group",
						action = "quit",
						surroundings = ""
					}
				},
				footer = {},
			},
		})

		nmap("<Leader>sl", ":source Session.vim<CR>")
		nmap("<Leader>ss", ":Obsession<CR>")
		nmap("<Leader>fo", ":Telescope oldfiles<CR>")
		nmap("<Leader>fw", ":Telescope live_grep<CR>")
		nmap("<Leader>ff", ":Telescope find_files<CR>")
		nmap("<Leader>cn", ":enew<CR>")
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
