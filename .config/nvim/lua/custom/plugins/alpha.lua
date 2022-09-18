local function button(sc, txt, keybind)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

  local opts = {
    position = "center",
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 36,
    align_shortcut = "right",
    hl = "AlphaButtons",
  }

  if keybind then
    opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
  end

  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true) or ""
      vim.api.nvim_feedkeys(key, "normal", false)
    end,
    opts = opts,
  }
end

return {
  headerPaddingTop = { type = "padding", val = 2 },
  header = {
    val = {
      "┌────────────────────────────────────┐",
      "│         ▂▄▅▇████████████▆▅▃        │",
      "│      ▁▅▇███▝▘▘       ▝▝▝▘███▅▁     │",
      "│     ▄██▘▘       ▝▘██       ▝██▖    │",
      "│    ▇█▘       ╴               ▝█▆▅▖ │",
      "│ ▗███▘▝▅▇▇▅▆▆▋╶    ▝▝▘▁        ▝██▇▍│",
      "│ █▃█┙▗▆██████▉        ▘         ▚██▋│",
      "│ █▂▉ ╍████████╴                 ▝█┻▉│",
      "│▗█▚▊  ┻███▋╏╲▘                   █▆▘│",
      "│  ▗▏    ▘▊╸                      ▍  │",
      "│  ▝▎ ▁▃▁         ▃▃▄▃            ▍  │",
      "│   ▊ ▝█▘       ▗█████▊          ╱▏  │",
      "│   ▝▖         ▗███████▌        ╻    │",
      "│    ▝▖       ▗█████████▆            │",
      "│     █▆▃   ▂▃█████▌█████▇▇▄─▁▅▅▆    │",
      "│ ▁╶▅▅██▇█▇▅███████▌███████▇█▇██▉ ▂  │",
      "│██▆▁▌▝▝██▇████████▊████████▇▇█┛▘▂█▄▆│",
      "│████▉▇▅▂▂▁▇███████▊████████▃▃▅▆████▊│",
      "│▝████▖████████████▌███████████████▚▉│",
      "│┣████▇████████████ ▝█████████████▋█▊│",
      "│██▅█████████████▋    ▂█████████████▊│",
      "│████████████████▇    ██████████████▉│",
      "│████████████████▘    ▝█████████████▉│",
      "│███████████████▘      ▝████████████▉│",
      "│██████████▇██▘          ▝██████████▉│",
      "│████████████▋            ▝█████████▉│",
      "└────────────────────────────────────┘",
    }
  },
  buttons = {
    val = {
      button("SPC f f", "  Find File  ", ":Telescope find_files<CR>"),
      button("SPC f o", "  Recent Files  ", ":Telescope oldfiles<CR>"),
      button("SPC f w", "  Find Word  ", ":Telescope live_grep<CR>"),
      button("SPC s l", "勒 Reload Last Session  ", ":source Session.vim<CR>"),
      button("SPC t h", "  Themes  ", ":Telescope themes<CR>"),
      button("q", "ﴘ  Quit Neovim", ":exit<CR>"),
    }
  }
}
