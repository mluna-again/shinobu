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
  use(require('plugins.config.bufferline'))
  use('elixir-editors/vim-elixir')
  use('sbdchd/neoformat')
  use('tpope/vim-endwise')
  use('junegunn/goyo.vim')
  use('vim-test/vim-test')
  use(require('plugins.config.floaterm'))
  use('tpope/vim-obsession')
  use('Yggdroot/indentLine')
  use('junegunn/fzf.vim')
  use('junegunn/fzf')
  use('kyazdani42/nvim-web-devicons')
  use(require('plugins.config.nvim-tree'))
  use('tpope/vim-commentary')
  use('jiangmiao/auto-pairs')
  use('SirVer/ultisnips')
  use('alvan/vim-closetag')
  use('karb94/neoscroll.nvim')
  use(require('plugins.config.tags'))
  use('neovim/nvim-lspconfig')
                           
  if packer_bootstrap then
    require('packer').sync()
  end
end)
