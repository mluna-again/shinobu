local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "tsserver" }

local home = os.getenv("HOME")

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

-- elixirls needs special treatment -_-
lspconfig["elixirls"].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { string.format("%s/.local/share/nvim/mason/packages/elixir-ls/language_server.sh", home) }
}
