return {
	'hoob3rt/lualine.nvim',
	config = function()
		require('lualine').setup {
			options = {
				component_separators = '',
				section_separators = { left = '', right = '' },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
			},
			sections = {
				lualine_a = {
					{ 'mode', separator = { left = '' }, right_padding = 2, icon = '', color = { gui = 'bold' } },
				},
				lualine_b = { { 'filetype', icon_only = true }, 'filename' },
				lualine_c = { { 'branch',  icon = '' } },
				lualine_x = { 'diagnostics' },
				lualine_y = { { 'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")', icon = ' ' } },
				lualine_z = { { 'progress', icon = '' } },
			},
			inactive_sections = {
				lualine_a = { 'filename' },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { 'location' },
			},
			tabline = {},
			extensions = {},
		}
	end
}
