return {
	"jackMort/ChatGPT.nvim",
	cmd = {
		"ChatGPT",
	},
	init = function()
		local wk = require("which-key")

		wk.register({
			c = {
				name = "GPT",
				o = {
					"<cmd>ChatGPT<CR>",
					"Toggle chat",
				},
			},
		}, {
			prefix = "<Leader>",
		})
	end,
	config = function()
		local home = vim.fn.expand("$HOME")
		local file = home .. "/.cache/gpt.gpg"
		if vim.fn.filereadable(file) == 0 then
			print("[gpt.nvim] gpt.gpg file not found (" .. file .. ")")
			return
		end

		require("chatgpt").setup({
			api_key_cmd = "gpg -d " .. file,
			openai_params = {
				model = "gpt-4-0125-preview"
			},
			settings_window = {
				setting_sign = "  ",
				border = {
					style = "rounded",
					text = {
						top = " Settings ",
					},
				},
				win_options = {
					winhighlight = "Normal:Input1,FloatBorder:Input1Border",
				},
			},
			help_window = {
				setting_sign = "  ",
				border = {
					style = "rounded",
					text = {
						top = " Help ",
					},
				},
				win_options = {
					winhighlight = "Normal:Input1,FloatBorder:Input1Border",
				},
			},
			popup_layout = {
				default = "center",
				center = {
					width = "80%",
					height = "80%",
				},
				right = {
					width = "30%",
					width_settings_open = "50%",
				},
			},
			popup_input = {
				prompt = "  ",
				border = {
					highlight = "Input3Border",
					style = "rounded",
					text = {
						top_align = "center",
						top = " Prompt ",
					},
				},
				win_options = {
					winhighlight = "Normal:Input3,FloatBorder:Input3Border",
				},
				submit = "<C-Enter>",
				submit_n = "<Enter>",
				max_visible_lines = 20,
			},
			popup_window = {
				border = {
					highlight = "Input2Border",
					style = "rounded",
					text = {
						top = " ChatGPT ",
					},
				},
				win_options = {
					wrap = true,
					linebreak = true,
					foldcolumn = "1",
					winhighlight = "Normal:Input2,FloatBorder:Input2Border",
				},
				buf_options = {
					filetype = "markdown",
				},
			},
			chat = {
				welcome_message = "Howdy",
				loading_text = "",
				question_sign = "󰭻 ",
				answer_sign = "󱚣 ",
				border_left_sign = "",
				border_right_sign = "",
				max_line_length = 120,
				sessions_window = {
					active_sign = "  ",
					inactive_sign = "  ",
					current_line_sign = "",
					border = {
						style = "rounded",
						text = {
							top = " Sessions ",
						},
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:Normal",
					},
				},
			},
		})
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
}
