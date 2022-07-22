require('core.maps')

function read_banner()
	local BANNER = "darkness2"
	local file = io.lines(string.format("%s/.local/ascii/%s", os.getenv("HOME"), BANNER))
	local lines = {}
	table.insert(lines, "")
	for line in file do
		table.insert(lines, line)
	end
	table.insert(lines, "")
	return lines
end

return {
	'glepnir/dashboard-nvim',
	config = function()
		local db = require('dashboard')
		db.custom_header = read_banner()
		db.custom_center = {
		}
		db.custom_footer = { "いい元気だね、何かいいことでもあったのかい？" }
		-- db.preview_file_path = string.format("%s/.config/nvim/banners/rice.png", os.getenv("HOME"))
		-- db.preview_file_height = 15
		-- db.preview_file_width = 40
		-- db.preview_command = "chafa --center on"
		db.hide_statusline = 1
		db.hide_tabline = 1
		-- db.session_directory

		db.custom_center = {
			{ icon = " ", desc = "New File                  SPC c n", action = "DashboardNewFile" },
			{ icon = " ", desc = "Find File                 SPC f f", action = "Telescope find_files" },
			{ icon = "ﲊ ", desc = "Recents                   SPC f h", action = "Telescope oldfiles" },
			{ icon = " ", desc = "Find Word                 SPC f a", action = "Telescope live_grep" },
			{ icon = "勒", desc = "Load Last Session         SPC s l", action = "SessionLoad" },
		}

		nmap("<Leader>sl", ":source Session.vim<CR>")
		nmap("<Leader>ss", ":Obsession<CR>")
		nmap("<Leader>fh", ":Telescope oldfiles<CR>")
		nmap("<Leader>fa", ":Telescope live_grep<CR>")
		nmap("<Leader>ff", ":Telescope find_files<CR>")
		nmap("<Leader>cn", ":DashboardNewFile<CR>")
		nmap("<Leader>fn", ":NvimTreeFindFileToggle<CR>")
		nmap("<Leader>FF", ":Telescope buffers<CR>")
		
		vim.cmd("autocmd! FileType dashboard set noruler")
	end
}
