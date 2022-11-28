require("core.maps")

return {
	'Olical/conjure',
	config = function ()
		nmap("<leader>cer", ":ConjureEvalRootForm<CR>")
		nmap("<leader>cee", ":ConjureEvalCurrentForm<CR>")
		nmap("<leader>ceb", ":ConjureEvalBuf<CR>")
		nmap("<leader>clv", ":ConjureLogVSplit<CR><C-w>x")
		nmap("<leader>cls", ":ConjureLogSplit<CR>")
		nmap("<leader>clr", ":ConjureLogResetSof<CR>")
	end
}
