require("core.maps")

return {
	'Olical/conjure',
	config = function ()
		nmap("<leader>cl", ":ConjureEvalRootForm<CR>")
		nmap("<leader>ce", ":ConjureEvalCurrentForm<CR>")
		nmap("<leader>cp", ":ConjureEvalBuf<CR>")
	end
}
