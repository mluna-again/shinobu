local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  use(require('plugins.config.dashboard'))
  use('sbdchd/neoformat')
  use('nvim-telescope/telescope.nvim')
  use('nvim-lua/popup.nvim')
  use('nvim-lua/plenary.nvim')
  use('morhetz/gruvbox')
  use(require('plugins.config.lualine'))

  if packer_bootstrap then
    require('packer').sync()
  end
end)
