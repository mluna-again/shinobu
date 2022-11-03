return {
  ["folke/which-key.nvim"] = {
    disable = false
  },
  ["goolord/alpha-nvim"] = {
    disable = false,
    override_options = require("custom.plugins.alpha")
  },
  ["neovim/nvim-lspconfig"] = {
    config = function ()
      require("plugins.configs.lspconfig")
      require("custom.plugins.lspconfig")
    end
  },
  ["williamboman/mason.nvim"] = {
    override_options = {
      ensure_installed = { "elixir-ls", "typescript-language-server", "solargraph", "css-lsp", "gopls" }
    }
  },
  ["sbdchd/neoformat"] = {},
  ["tpope/vim-obsession"] = {},
  ["hrsh7th/nvim-cmp"] = require("custom.plugins.cmp"),
  ["karb94/neoscroll.nvim"] = require("custom.plugins.neoscroll"),
  ["nvim-telescope/telescope.nvim"] = require("custom.plugins.telescope"),
  ["ggandor/lightspeed.nvim"] = {},
  ["mattn/emmet-vim"] = require("custom.plugins.emmet"),
  ["vim-test/vim-test"] = require("custom.plugins.vim-test"),
  ["rhysd/git-messenger.vim"] = {},
  ["sindrets/winshift.nvim"] = {}
}
