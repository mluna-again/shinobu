return {
	"akinsho/bufferline.nvim",
	event = "TabEnter",
	dependencies = "kanagawa.nvim",
	config = function()
		require("bufferline").setup({
			options = {
				mode = "tabs",
				offsets = { { filetype = "neo-tree", text = "" } },
				indicator = {
					style = 'none'
				},
				offsets = {},
				show_buffer_icons = false,
				show_close_icon = false,
				modified_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 14,
				max_prefix_length = 13,
				-- tab_size = 0,
				show_tab_indicators = true,
				enforce_regular_tabs = false,
				view = "multiwindow",
				show_buffer_close_icons = false,
				separator_style = {"", ""},
				always_show_bufferline = false,
				diagnostics = false,
			},
			highlights = {},
		})
	end,
}
