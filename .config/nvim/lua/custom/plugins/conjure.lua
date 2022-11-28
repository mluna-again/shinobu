return {
  config = function ()
    vim.cmd([[
      autocmd BufNewFile conjure-log-* lua vim.diagnostic.disable(0)
    ]])
  end
}
