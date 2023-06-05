vim.api.nvim_create_autocmd({ "VimEnter" }, {
	pattern = "*",
	callback = function ()
		if not (vim.bo.filetype == "alpha") then
			vim.cmd("doautocmd User AlphaClosed | LspStart")
			return
		end
	end
})
