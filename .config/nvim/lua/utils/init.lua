-- ╭──────────────────────────────────────────────────────────╮
-- │                        HTTP REST                         │
-- ╰──────────────────────────────────────────────────────────╯
-- bruh
vim.cmd([[
command Http :vert new | set ft=http | nmap <buffer> tt :bd! | read !sh #
autocmd! BufEnter *.http set ft=sh | nmap <buffer> <C-h> :Http<CR>
]])
