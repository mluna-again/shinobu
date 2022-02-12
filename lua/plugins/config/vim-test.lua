require('core.maps')

nmap("<Leader>r", ":TestNearest<CR>")
nmap("<Leader>R", ":TestFile<CR>")
nmap("<Leader>T", ":TestSuite<CR>")

vim.cmd([[
let test#strategy = "floaterm"
]])

return {
'vim-test/vim-test'
}
