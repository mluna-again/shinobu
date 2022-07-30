-- ╭──────────────────────────────────────────────────────────╮
-- │                        HTTP REST                         │
-- ╰──────────────────────────────────────────────────────────╯
-- bruh
vim.cmd([[
autocmd! BufEnter *.http set ft=sh
command Http :vert new | set ft=json | nmap <buffer> tt :bd! | read !sh #
]])
