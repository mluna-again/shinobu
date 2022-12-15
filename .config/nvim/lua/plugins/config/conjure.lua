require("core.maps")

return {
	'Olical/conjure',
	config = function ()
		nmap("<leader>cl", ":ConjureEvalRootForm<CR>")
		nmap("<leader>ce", ":ConjureEvalCurrentForm<CR>")
		nmap("<leader>cp", ":ConjureEvalBuf<CR>")

		vim.cmd([[
		autocmd BufNewFile conjure-log-* lua vim.diagnostic.disable(0)
		]])
	end
}
