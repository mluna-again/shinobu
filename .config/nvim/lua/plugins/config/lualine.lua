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

local function prettyMode(mode)
	local icons = {}
	-- icons["NORMAL"] = "󱌢 Normal"
	-- icons["INSERT"] = "󰙏 Insert"
	-- icons["COMMAND"] = " Command"
	-- icons["V-LINE"] = "󰆾 V-Line"
	-- icons["V-BLOCK"] = "󰆾 V-Block"
	-- icons["TERMINAL"] = " Terminal"

	icons["NORMAL"] = "N"
	icons["INSERT"] = "I"
	icons["COMMAND"] = "C"
	icons["V-LINE"] = "V-L"
	icons["V-BLOCK"] = "V-B"
	icons["TERMINAL"] = "T"
	return icons[mode] or mode
end

local function prettyProgress(progress)
	if progress == "Top" then
		return "Top"
	end

	if progress == "Bot" then
		return "Bot"
	end

	local progress_num = string.gsub(progress, "%%", "")
	local num = tonumber(progress_num)

	if num < 20 then
		return "▁▁▁ " .. progress_num .. "%%"
	end

	if num < 30 then
		return "▂▂▂ " .. progress_num .. "%%"
	end

	if num < 40 then
		return "▃▃▃ " .. progress_num .. "%%"
	end

	if num < 50 then
		return "▄▄▄ " .. progress_num .. "%%"
	end

	if num < 60 then
		return "▅▅▅ " .. progress_num .. "%%"
	end

	if num < 70 then
		return "▆▆▆ " .. progress_num .. "%%"
	end

	if num < 80 then
		return "▇▇▇ " .. progress_num .. "%%"
	end

	return "███ " .. progress_num .. "%%"
end

return {
	"hoob3rt/lualine.nvim",
	dependencies = {
		"rebelot/kanagawa.nvim",
	},
	config = function()
		local kanagawa = require("kanagawa.colors").setup({ theme = "dragon" }).palette
		local colors = {
			black = kanagawa.dragonBlack4,
			white = kanagawa.dragonWhite,
			red = kanagawa.dragonYellow,
			green = kanagawa.dragonGreen,
			blue = kanagawa.dragonBlue,
			yellow = kanagawa.dragonRed,
			gray = kanagawa.dragonGray,
			darkgray = kanagawa.dragonBlack2,
			lightgray = kanagawa.dragonBlack5,
			inactivegray = kanagawa.dragonBlack6,
			background = kanagawa.dragonBlack3,
		}
		local theme = {
			normal = {
				a = { bg = colors.red, fg = colors.black, gui = "bold" },
				b = { bg = colors.lightgray, fg = colors.white },
				c = { bg = colors.black, fg = colors.gray },
			},
			insert = {
				a = { bg = colors.green, fg = colors.black, gui = "bold" },
				b = { bg = colors.lightgray, fg = colors.white },
				c = { bg = colors.black, fg = colors.white },
			},
			visual = {
				a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
				b = { bg = colors.lightgray, fg = colors.white },
				c = { bg = colors.black, fg = colors.black },
			},
			replace = {
				a = { bg = colors.blue, fg = colors.black, gui = "bold" },
				b = { bg = colors.lightgray, fg = colors.white },
				c = { bg = colors.black, fg = colors.white },
			},
			command = {
				a = { bg = colors.white, fg = colors.black, gui = "bold" },
				b = { bg = colors.lightgray, fg = colors.white },
				c = { bg = colors.black, fg = colors.black },
			},
			inactive = {
				a = { bg = colors.background, fg = colors.white },
				b = { bg = colors.background, fg = colors.white },
				c = { bg = colors.background, fg = colors.white },
			},
		}


		require("lualine").setup({
			options = {
				theme = theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "alpha" },
					winbar = { "alpha" },
				},
			},
			sections = {
				lualine_a = {
					{
						"mode",
						separator = { left = "" },
						right_padding = 2,
						fmt = prettyMode,
						color = { gui = "bold" },
					},
				},
				lualine_b = {
					{
						"filename",
						cond = shouldShowFilename,
						symbols = {
							modified = "",
						},
						color = { gui = "bold" },
					},
				},
				lualine_c = { { "branch", icon = "" } },
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
				lualine_y = { { 'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")', icon = "" } },
				lualine_z = { { "progress", fmt = prettyProgress } },
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
