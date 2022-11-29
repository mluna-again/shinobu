return {
	'hoob3rt/lualine.nvim',
	config = function()
		local function shouldShowFilename()
			local badFiletypes = { 'toggleterm', 'dashboard', 'NvimTree' }
			local ft = vim.bo.filetype
			for _, filetype in pairs(badFiletypes) do
				if string.find(ft, filetype) then
					return false
				end
			end
			return true
		end

		require('lualine').setup {
			options = {
				component_separators = '',
				section_separators = { left = '', right = '' },
				disabled_filetypes = {
					statusline = {},
					winbar = {}
				},
			},
			sections = {
				lualine_a = {
					{ 'mode', separator = { left = '' }, right_padding = 2, icon = '', color = { gui = 'bold' } },
				},
				lualine_b = { { 'filetype', icon_only = true, cond = shouldShowFilename }, { 'filename', cond = shouldShowFilename }
			},
			lualine_c = { { 'branch',  icon = '' } },
			lualine_x = { 'diagnostics' },
			lualine_y = { { 'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")', icon = ' ' } },
			lualine_z = { { 'progress', icon = '' } },
		}
	}
end
}
