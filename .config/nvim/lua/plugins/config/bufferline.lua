return {
	'akinsho/bufferline.nvim',
	config = function()
		require("bufferline").setup{
			options = {
				offsets = { { filetype = "NvimTree", text = "File explorer", padding = 1 } },
				show_close_icon = false,
				buffer_close_icon = "",
				modified_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 14,
				max_prefix_length = 13,
				tab_size = 20,
				show_tab_indicators = true,
				enforce_regular_tabs = false,
				view = "multiwindow",
				show_buffer_close_icons = true,
				separator_style = "thin",
				always_show_bufferline = false,
				diagnostics = false,
			},
		}
		vim.cmd("hi BufferLineHintSelected guifg=fg guibg=fg")
	end
}
