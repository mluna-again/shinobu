-- ╭──────────────────────────────────────────────────────────╮
-- │                        HTTP REST                         │
-- ╰──────────────────────────────────────────────────────────╯
-- bruh
vim.cmd([[
command Http :vert new | set ft=json | nmap <buffer> tt :bd! | read !sh #
]])
