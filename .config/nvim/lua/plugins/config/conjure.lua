require("core.maps")

return {
	"Olical/conjure",
	commit = "d2e69a13b32e8574decfe81ea275292234eba6ea",
	lazy = true,
	ft = "clojure",
	config = function()
		nmap("<leader>cl", ":ConjureEvalRootForm<CR>")
		nmap("<leader>ce", ":ConjureEvalCurrentForm<CR>")
		nmap("<leader>cp", ":ConjureEvalBuf<CR>")

		vim.cmd([[
		let g:conjure#client_on_load = v:false
		autocmd BufNewFile conjure-log-* lua vim.diagnostic.disable(0)
		]])
	end,
}
