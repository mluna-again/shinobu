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
      ensure_installed = { "elixir-ls", "typescript-language-server", "solargraph", "css-lsp", "clojure-lsp" }
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
  ["sindrets/winshift.nvim"] = {},
  ["kyazdani42/nvim-web-devicons"] = require("custom.plugins.devicons"),
  ["folke/trouble.nvim"] = require("custom.plugins.trouble"),
  ["simrat39/symbols-outline.nvim"] = require("custom.plugins.symbols"),
  ["NTBBloodbath/rest.nvim"] = require("custom.plugins.rest"),
  ["nvim-zh/colorful-winsep.nvim"] = require("custom.plugins.winsep"),
  ["Pocco81/true-zen.nvim"] = require("custom.plugins.true-zen"),
  ["Olical/conjure"] = require("custom.plugins.conjure")
}
