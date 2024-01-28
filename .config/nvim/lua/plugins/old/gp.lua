return {
	"robitx/gp.nvim",
	lazy = true,
	cmd = {
		"GPChatToggle"
	},
	init = function()
		local wk = require("which-key")

		wk.register({
			c = {
				name = "GPT",
				o = {
					"<cmd>GPChatToggle<CR>",
					"Toggle chat"
				},
				s = {
					"<cmd>GPChatRespond<CR>",
					"Send query"
				},
				d = {
					"<cmd>GPChatDelete<CR>",
					"Delete chat"
				}
			}
		}, {
			prefix = "<Leader>"
		})
	end,
	config = function()
		local home = vim.fn.expand("$HOME")
		local file = home .. "/.cache/gp.gpg"
		if vim.fn.filereadable(file) == 0 then
			print("[gp.nvim] gp.gpg file not found (" .. file .. ")")
			return
		end

		require("gp").setup({
			openai_api_key = {
				"gpg",
				"-d",
				file,
			},
			agents = {
				{
					name = "ChatGPT4",
					chat = true,
					model = { model = "gpt-4-0125-preview" },
					system_prompt = "You are a general AI assistant.\n\n"
						.. "The user provided the additional info about how they would like you to respond:\n\n"
						.. "- If you're unsure don't guess and say you don't know instead.\n"
						.. "- Ask question if you need clarification to provide a better answer.\n"
				},
			},
			cmd_prefix = "GP",
			chat_topic_gen_model = "gpt-4-0125-preview",
			chat_user_prefix = "󰭻 :",
			chat_assistant_prefix = { "󱚣 :", "[{{agent}}]" },
			chat_confirm_delete = false,
			toggle_target = "popup",
			style_chat_finder_border = "none",
			style_chat_finder_margin_bottom = 2,
			style_chat_finder_margin_left = 2,
			style_chat_finder_margin_right = 2,
			style_chat_finder_margin_top = 2,
			style_chat_finder_preview_ratio = 0.5,
			style_popup_border = "none",
			style_popup_margin_bottom = 2,
			style_popup_margin_left = 4,
			style_popup_margin_right = 4,
			style_popup_margin_top = 1,
		})
	end,
}
