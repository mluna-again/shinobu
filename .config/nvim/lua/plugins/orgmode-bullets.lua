return {
	"lukas-reineke/headlines.nvim",
	dependencies = "nvim-treesitter/nvim-treesitter",
	lazy = true,
	ft = { "org" },
	config = function()
		require("headlines").setup({
			org = {
				bullets = { "󰴈", "", "󰫢", "" },
				headline_highlights = { "OrgHeadline" },
				bullet_highlights = {
					"@org.headline.level1",
					"@org.headline.level2",
					"@org.headline.level3",
					"@org.headline.level4",
					"@org.headline.level5",
					"@org.headline.level6",
					"@org.headline.level7",
					"@org.headline.level8",
				},
				codeblock_highlight = "OrgCodeBlock",
				dash_highlight = "OrgDash",
				dash_string = "-",
				quote_highlight = "Quote",
				quote_string = "┃",
				fat_headlines = true,
				fat_headline_upper_string = "",
				fat_headline_lower_string = "",
			},
		})
	end,
}
