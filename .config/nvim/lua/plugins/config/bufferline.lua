return {
	'akinsho/bufferline.nvim',
	dependencies = 'kanagawa.nvim',
	config = function()
		require("bufferline").setup{
			options = {
				offsets = { { filetype = "NvimTree", text = "File Explorer" } },
				show_close_icon = false,
				modified_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 14,
				max_prefix_length = 13,
				tab_size = 20,
				show_tab_indicators = true,
				enforce_regular_tabs = false,
				view = "multiwindow",
				show_buffer_close_icons = false,
				separator_style = "thin",
				always_show_bufferline = false,
				diagnostics = false
			},
			highlights = {
				indicator_selected = {
					bg = "#16161D",
					fg = "#16161D"
				},
				modified_selected = {
					bg = "#16161D",
					fg = "#FFA066"
				},
				modified_visible = {
					bg = "#16161D",
					fg = "#FFA066"
				},
				modified = {
					bg = "#16161D",
					fg = "#FFA066"
				},
				pick = {
					bg = "#16161D",
					fg = "#16161D"
				},
				pick_visible = {
					bg = "#16161D",
					fg = "#16161D"
				},
				pick_selected = {
					bg = "#16161D",
					fg = "#16161D"
				},
				separator = {
					bg = "#16161D",
					fg = "#16161D"
				},
				separator_visible = {
					bg = "#16161D",
					fg = "#16161D"
				},
				separator_selected = {
					bg = "#16161D",
					fg = "#16161D"
				},
				fill = {
					bg = "#16161D"
				},
				background = {
					bg = "#16161D"
				},
				buffer = {
					fg = "#DCD7BA",
					bg = "#16161D"
				},
				buffer_selected = {
					fg = "#DCD7BA",
					bg = "#16161D"
				},
				buffer_visible = {
					fg = "#717C7C",
					bg = "#16161D"
				}
			}
		}
	end
}
