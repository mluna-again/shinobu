return {
	'hoob3rt/lualine.nvim',
	config = function()
		local colors = {
			white= "#7d4140",
			black= "#191716",
		}

		require('lualine').setup{
			options = {
				icons_enabled = true,
				theme = {
					normal = {
						a = { fg = colors.black, bg = colors.white },
						b = { fg = colors.black, bg = colors.white },
						c = { fg = colors.black, bg = colors.white },
						x = { fg = colors.black, bg = colors.white },
						y = { fg = colors.black, bg = colors.white },
						z = { fg = colors.black, bg = colors.white },
					},
				},
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
