local function shouldShowFilename()
	local badFiletypes =
	{ "toggleterm", "dashboard", "NvimTree", "neo-tree", "neo-tree-popup", "Trouble", "DiffviewFilePanel" }
	local ft = vim.bo.filetype
	for _, filetype in pairs(badFiletypes) do
		if ft == filetype then
			return false
		end
	end
	return true
end

return {
	"hoob3rt/lualine.nvim",
	dependencies = {
		"rebelot/kanagawa.nvim",
	},
	config = function()
		local theme = {
			normal = {
				a = "StatusLineNormalNormal",
				b = "StatusLineNormalNormal",
				c = "StatusLineNormalNormal",
			},
			insert = {
				a = "StatusLineNormalNormal",
				b = "StatusLineNormalNormal",
				c = "StatusLineNormalNormal",
			},
			visual = {
				a = "StatusLineNormalNormal",
				b = "StatusLineNormalNormal",
				c = "StatusLineNormalNormal",
			},
			replace = {
				a = "StatusLineNormalNormal",
				b = "StatusLineNormalNormal",
				c = "StatusLineNormalNormal",
			},
			command = {
				a = "StatusLineNormalNormal",
				b = "StatusLineNormalNormal",
				c = "StatusLineNormalNormal",
			},
			inactive = {
				a = "StatusLineNormalNormal",
				b = "StatusLineNormalNormal",
				c = "StatusLineNormalNormal",
			},
		}


		require("lualine").setup({
			options = {
				theme = theme,
				globalstatus = true,
				component_separators = "",
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "alpha", "TelescopePrompt" },
					winbar = { "alpha", "TelescopePrompt" },
				},
			},
			sections = {
				lualine_a = {
					{
						"mode",
						separator = { left = "" },
						right_padding = 2,
						color = { gui = "bold" },
						icon = { " ", color = "StatusLineModeIcon" },
					},
				},
				lualine_b = {
					{
						"filename",
						cond = shouldShowFilename,
						icons_enabled = true,
						symbols = {
							modified = "",
						},
						color = { gui = "bold" },
						icon = { " ", color = "StatusLineFileIcon" }
					},
				},
				lualine_c = { { "branch", icon = { " ", color = "StatusLineBranchIcon" } } },
				lualine_x = { {
					"diagnostics",
					diagnostics_color = {
						-- Same values as the general color option can be used here.
						error = 'DiagnosticError', -- Changes diagnostics' error color.
						warn  = 'DiagnosticWarn',  -- Changes diagnostics' warn color.
						info  = 'DiagnosticInfo',  -- Changes diagnostics' info color.
						hint  = 'DiagnosticHint',  -- Changes diagnostics' hint color.
					},
					symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
				} },
				lualine_y = { { 'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")', icon = { " ", color = "StatusLineFolderIcon" } } },
				lualine_z = { { "progress", icon = { "󰗈 ", color = "StatusLineProgressIcon" } } },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
