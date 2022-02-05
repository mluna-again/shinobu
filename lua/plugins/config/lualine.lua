return {
  'hoob3rt/lualine.nvim',
  config = function()
    local gruvbox = require('lualine.themes.gruvbox')
    gruvbox.command.a.bg = '#fb4934'
    require('lualine').setup{
      options = {
        icons_enabled = true,
        theme = gruvbox,
        disabled_filetypes = {},
        section_separators = { left = '', right = ''},
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          { 'mode', separator = { left = '' }, right_padding = 2 }
        },
        lualine_b = {'branch', 'diff'},
        lualine_c = {{ 'filename', full_path = true }},
        lualine_x = {'encoding', 'location', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {
          { 'location', separator = { right = '' }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = {}
    }
  end
}
