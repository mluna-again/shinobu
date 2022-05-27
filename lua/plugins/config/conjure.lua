require("core.maps")

return {
	'Olical/conjure',
	config = function ()
		nmap("<leader>cer", ":ConjureEvalRootForm<CR>")
		nmap("<leader>cee", ":ConjureEvalCurrentForm<CR>")
		nmap("<leader>clv", ":ConjureLogVSplit<CR>")
	end
}
