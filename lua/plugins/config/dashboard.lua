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
		local g = vim.g

		g.dashboard_disable_at_vimenter = 0
		g.dashboard_disable_statusline = 1
		g.dashboard_default_executive = "telescope"
		g.dashboard_custom_header = read_banner()
		-- g.dashboard_preview_command = "chafa --center on"
		-- g.dashboard_preview_file = "/home/mluna/.config/nvim/banners/rice.png"
		g.dashboard_preview_file_height = 15
		g.dashboard_preview_file_width = 40

		g.dashboard_custom_section = {
			a = { description = { "  Find File                 SPC f f" }, command = "Telescope find_files" },
			b = { description = { "  Recents                   SPC f h" }, command = "Telescope oldfiles" },
			c = { description = { "  Find Word                 SPC f a" }, command = "Telescope live_grep" },
			d = { description = { "洛 New File                  SPC c n" }, command = "DashboardNewFile" },
			f = { description = { "  Load Last Session         SPC s l" }, command = "SessionLoad" },
		}

		g.dashboard_custom_footer = {
			"いい元気だね、何かいいことでもあったのかい？",
		}


		nmap("<Leader>sl", ":source Session.vim<CR>")
		nmap("<Leader>ss", ":Obsession<CR>")
		nmap("<Leader>fh", ":DashboardFindHistory<CR>")
		nmap("<Leader>ff", ":DashboardFindFile<CR>")
		nmap("<Leader>fa", ":DashboardFindWord<CR>")
		nmap("<Leader>cn", ":DashboardNewFile<CR>")
		nmap("<Leader>fn", ":NvimTreeFindFileToggle<CR>")
		nmap("<Leader>FF", ":Telescope buffers<CR>")

		vim.cmd([[
		au! FileType dashboard set noruler
		au! VimEnter * hi DashboardHeader guifg=white
		]])
	end
}
