vim.cmd("set relativenumber")
vim.cmd("set clipboard=")
vim.cmd("command Close :bufdo bd | Alpha")
vim.cmd("command CLose :bufdo bd | Alpha")
vim.cmd("command CLOse :bufdo bd | Alpha")
vim.cmd([[
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]])
vim.g.loaded_matchit = nil
