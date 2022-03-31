vim.cmd([[
function Transparent()
	hi Normal guibg=NONE
	hi NonText guibg=NONE guifg=BLACK
	hi BufferlineFill guibg=NONE
	augroup DarkCherryVim
		autocmd!
	augroup END
endfunction

function Solid()
	hi Normal guibg=#191716
	hi NonText guibg=#191716
	hi BufferlineFill guibg=#191716
endfunction
]])
