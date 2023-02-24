local background = "#16161D"
local function shouldShowFilename()
	local badFiletypes = { "toggleterm", "dashboard", "NvimTree" }
	local ft = vim.bo.filetype
	for _, filetype in pairs(badFiletypes) do
		if string.find(ft, filetype) then
			return false
		end
	end
	return true
end

local function prettyMode(mode)
  local icons = {}
  icons["NORMAL"] = "󱌢 NORMAL"
  icons["INSERT"] = "󰙏 INSERT"
  icons["COMMAND"] = " COMMAND"
  icons["V-LINE"] = "󰆾 V-LINE"
  icons["V-BLOCK"] = "󰆾 V-BLOCK"
  return icons[mode] or mode
end

local function prettyProgress(progress)
  if progress == "Top" then
    return ""
  end

  if progress == "Bot" then
    return ""
  end

  local progress_num = string.gsub(progress, "%%", "")
  local num = tonumber(progress_num)

  if num < 20 then
    return ""
  end

  if num < 30 then
    return ""
  end

  if num < 40 then
    return ""
  end

  if num < 50 then
    return ""
  end

  if num < 60 then
    return ""
  end

  if num < 70 then
    return ""
  end

  if num < 80 then
    return ""
  end

  if num < 90 then
    return ""
  end

  return ""
end

return {
	"hoob3rt/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				component_separators = "",
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
			},
			sections = {
				lualine_a = {
					{ "mode", separator = { left = "" }, right_padding = 2, fmt = prettyMode, color = { gui = "bold" } },
				},
				lualine_b = {
					{ "filetype", icon_only = true, cond = shouldShowFilename },
					{ "filename", cond = shouldShowFilename },
				},
				lualine_c = { { "branch", icon = "", color = { bg = background } } },
				lualine_x = { { "diagnostics", color = { bg = background } } },
				lualine_y = { { 'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")', icon = " " } },
				lualine_z = { { "progress", fmt = prettyProgress } },
			},
		})

		-- lualine won't create this highlight group if not inside a git repo so i just do it manually
		vim.cmd("autocmd! BufEnter * hi lualine_c_normal guibg=" .. background)
	end,
}
