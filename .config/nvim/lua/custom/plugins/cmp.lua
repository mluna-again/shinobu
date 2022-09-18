return {
  override_options = function ()
    local cmp = require("cmp")
    return {
      mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = true })
      }
    }
  end
}
