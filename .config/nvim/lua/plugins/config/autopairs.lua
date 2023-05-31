return {
	"windwp/nvim-autopairs",
	event = "User AlphaClosed",
	config = function()
		require("nvim-autopairs").setup({
      disable_filetype = { "clojure" }
    })
	end
}
