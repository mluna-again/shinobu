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
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          { 'mode', separator = { left = '', right = '' }, right_padding = 2 }
        },
	lualine_b = {
	  {'branch', 'diff', separator = { right = ''}},
	},
        lualine_c = {{ 'filename', full_path = true }},
	lualine_x = {
	  {'encoding', 'location', 'filetype', separator = { left = '' }},
	},
	lualine_y = {
	  {'progress', separator = { left = '' }},
	},
        lualine_z = {
          { 'location', separator = { right = '', left = '' }, left_padding = 2 },
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
