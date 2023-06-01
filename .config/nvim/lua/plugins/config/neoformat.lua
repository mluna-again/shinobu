vim.cmd([[
augroup fmt
  autocmd!
  autocmd BufWritePre *.go undojoin | Neoformat
  autocmd BufWritePre *.rust undojoin | Neoformat
augroup END
]])

return {
	"sbdchd/neoformat",
	event = "User AlphaClosed",
}
