local function shouldShowFilename()
	local badFiletypes = { "toggleterm", "dashboard", "NvimTree", "neo-tree", "neo-tree-popup", "Trouble", "DiffviewFilePanel" }
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
	icons["NORMAL"] = "󱌢 Normal"
	icons["INSERT"] = "󰙏 Insert"
	icons["COMMAND"] = " Command"
	icons["V-LINE"] = "󰆾 V-Line"
	icons["V-BLOCK"] = "󰆾 V-Block"
	icons["TERMINAL"] = " Terminal"
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
					statusline = { "alpha" },
					winbar = {},
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
					{ "filetype", icon_only = true, cond = shouldShowFilename },
					{ "filename", cond = shouldShowFilename, symbols = {
						modified = "",
					} },
				},
				lualine_c = { { "branch", icon = "" } },
				lualine_x = { { "diagnostics" } },
				lualine_y = { { 'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")', icon = " " } },
				lualine_z = { { "progress", fmt = prettyProgress } },
			},
		})
	end,
}
