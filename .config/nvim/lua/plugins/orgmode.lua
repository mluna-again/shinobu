return {
  'nvim-orgmode/orgmode',
  dependencies = { "folke/which-key.nvim" },
  ft = { 'org' },
  config = function()
    require('orgmode').setup({
      -- org_agenda_files = '~/orgfiles/**/*',
      -- org_default_notes_file = '~/orgfiles/refile.org',
      org_todo_keywords = { "TODO", "DOING", "|", "DONE" },
      org_startup_folded = "showeverything",
      mappings = {
        org = {
          org_toggle_checkbox = "<leader>oo",
          org_timestamp_up = "<leader>o>",
          org_timestamp_down = "<leader>o<",
          org_open_at_point = "<leader>o<cr>",
        }
      }
    })

    local wk = require("which-key")
    wk.register({
      name = "Orgmode"
    }, { prefix = "<leader>o" })
  end,
}
