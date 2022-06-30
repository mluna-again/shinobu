require('core.maps')

function read_banner()
	local BANNER = "darkness2"
	local file = io.lines(string.format("%s/.config/nvim/ascii/%s", os.getenv("HOME"), BANNER))
	local lines = {}
	for line in file do
		table.insert(lines, line)
	end
	return lines
end

return {
	'glepnir/dashboard-nvim',
	config = function()
		-- g.dashboard_disable_at_vimenter = 0
		-- g.dashboard_disable_statusline = 1
		-- g.dashboard_preview_command = "chafa --center on"
		-- g.dashboard_preview_file = "/home/mluna/.config/nvim/banners/rice.png"
		-- g.dashboard_preview_file_height = 15
		-- g.dashboard_preview_file_width = 40

		local db = require('dashboard')
		db.custom_header = read_banner()
		db.custom_center = {
		}
		db.custom_footer = { "いい元気だね、何かいいことでもあったのかい？" }
		-- db.preview_file_Path
		-- db.preview_file_height
		-- db.preview_file_width
		-- db.preview_command
		db.hide_statusline = 1
		db.hide_tabline = 1
		-- db.session_directory

		db.custom_center = {
			{ desc = "Find File                 SPC f f", action = "Telescope find_files" },
			{ desc = "Recents                   SPC f h", action = "Telescope oldfiles" },
			{ desc = "Find Word                 SPC f a", action = "Telescope live_grep" },
			{ desc = "New File                  SPC c n", action = "DashboardNewFile" },
			{ desc = "Load Last Session         SPC s l", action = "SessionLoad" },
		}

		nmap("<Leader>sl", ":source Session.vim<CR>")
		nmap("<Leader>ss", ":Obsession<CR>")
		nmap("<Leader>fh", ":Telescope oldfiles<CR>")
		nmap("<Leader>fa", ":Telescope live_grep<CR>")
		nmap("<Leader>ff", ":Telescope find_files<CR>")
		nmap("<Leader>cn", ":DashboardNewFile<CR>")
		nmap("<Leader>fn", ":NvimTreeFindFileToggle<CR>")
		nmap("<Leader>FF", ":Telescope buffers<CR>")

		vim.cmd([[
		au! FileType dashboard set noruler
		au! VimEnter * hi DashboardHeader guifg=white
		]])
	end
}
