require("core.maps")

return {
  'goolord/alpha-nvim',
  config = function()
    local alpha = require'alpha'
    require'alpha.term'

    dashboard = require'alpha.themes.dashboard'

    dashboard.section.buttons.val = {
      dashboard.button("SPC c n", "  New file", ":enew<CR>"),
      dashboard.button("SPC f f", "󰱼  Find file", ":Telescope find_files<CR>"),
      dashboard.button("SPC f o", "  Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("SPC f w", "  Find word", ":Telescope live_grep<CR>"),
      dashboard.button("SPC s l", "  Load last session", ":source Session.vim<CR>"),
      dashboard.button("q", "󰜎  Quit Neovim", ":q<CR>"),
    }

    dashboard.section.terminal.command = "cat ~/.local/banners/lucky"
    dashboard.section.terminal.width = 60
    dashboard.section.terminal.height = 20
    dashboard.section.terminal.opts.position = "center"


    dashboard.config.layout = {
      dashboard.section.terminal,
      { type = "padding", val = 5 },
      dashboard.section.buttons,
      dashboard.section.footer,
    }

    alpha.setup(dashboard.config)

    nmap("<Leader>sl", ":source Session.vim<CR>")
    nmap("<Leader>ss", ":Obsession<CR>")
    nmap("<Leader>fo", ":Telescope oldfiles<CR>")
    nmap("<Leader>fw", ":Telescope live_grep<CR>")
    nmap("<Leader>ff", ":Telescope find_files<CR>")
    nmap("<Leader>cn", ":enew<CR>")
    nmap("<Leader>fn", ":NeoTreeReveal<CR>")

    vim.cmd([[
    augroup DashboardTweaks
    autocmd!
    autocmd FileType dashboard set noruler
    autocmd FileType dashboard nmap <buffer> q :quit<CR>
    augroup END
    ]])
  end
}
