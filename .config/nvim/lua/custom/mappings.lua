local M = {}

M.general = {
  i = {
    ["jj"] = { "<ESC>", "enter NORMAL mode" }
  },
  n = {
    ["<C-Left>"] = { ":vertical resize -2<CR>", "resize window" },
    ["<C-Right>"] = { ":vertical resize +2<CR>", "resize window" },
    ["<C-Up>"] = { ":resize -2<CR>", "resize window" },
    ["<C-Down>"] = { ":resize +2<CR>", "resize window" },
    ["SS"] = { ":w<CR>", "save with autocmds" },
    ["ss"] = { ":noautocmd w<CR>", "save without autocmds" },
    ["gt"] = { ":lua require('nvchad_ui.tabufline').tabuflineNext()<CR>", "cycle through buffers", opts = { silent = true } },
    ["gr"] = { ":lua require('nvchad_ui.tabufline').tabuflinePrev()<CR>", "cycle through buffers", opts = { silent = true } },
    ["tt"] = { ":lua require('nvchad_ui.tabufline').close_buffer()<CR>", "close all buffers", opts = { silent = true } },
    ["TT"] = { ":only<CR>", "close all but current buffers" },
    ["dh"] = { ":noh<CR>", "remove highlights" },
    ["Y"] = { "y$", "yank until end of line" },
    ["''"] = { "``", "goes to previous mark or something" },
    ["<A-k>"] = { ":wincmd k<CR>", "next window down" },
    ["<A-j>"] = { ":wincmd j<CR>", "prev window up" },
    ["<A-h>"] = { ":wincmd h<CR>", "prev window left" },
    ["<A-l>"] = { ":wincmd l<CR>", "prev window left" },
    ["-"] = { "<C-e>", "scrolls one line down" },
    ["¿"] = { "<C-y>", "scrolls one line up" },
    ["<Space>"] = { "<Nop>", "idk what this does but i think i need it" },
    ["FF"] = { ":NvimTreeToggle<CR>", "toggles nvimtree" },
    ["<Leader>sl"] = { ":source Session.vim<CR>", "sources session file" },
    ["<Leader>ss"] = { ":Obsession<CR>", "saves session" },
    ["<Leader>ff"] = { ":Telescope oldfiles<CR>", "telescope old files" },
    ["<Leader>fw"] = { ":Telescope live_grep<CR>", "telescope live grep" },
    ["<Leader>fa"] = { ":Telescope find_files<CR>", "telescope find files" },
    ["<Leader>fn"] = { ":NvimTreeFindFileToggle<CR>", "toggle nvimtree on current file" },
    ["<A-m>"] = { ":lua require('nvterm.terminal').toggle('horizontal')<CR>", "toggle terminal", opts = { silent = true } },
    ["/"] = { ":Telescope current_buffer_fuzzy_find<CR>", "fuzzy find in buffer" },
    ["sx"] = { "<Plug>Lightspeed_s", "activate lightspeed" },
    ["Sx"] = { "<Plug>Lightspeed_S", "activate lightspeed backwards" },
    ["SX"] = { "<Plug>Lightspeed_S", "activate lightspeed backwards" },
    ["<Leader>r"] = { ":TestNearest<CR>", "runs the nearest test" },
    ["<Leader>R"] = { ":TestFile<CR>", "runs current test file" },
    ["<Leader>T"] = { ":TestSuite<CR>", "runs whole test suite" },
    --- LSP MAPPINGS ---
    ["<Leader>ls"] = { function ()
      vim.lsp.buf.signature_help()
    end, "lsp signature" },
    ["<Leader>lh"] = { function ()
      vim.lsp.buf.hover()
    end, "lsp documentation" },
    ["<Leader>lr"] = { function ()
      require("nvchad_ui.renamer").open()
    end, "lsp rename" },
    ["<Leader>lf"] = { function ()
        vim.lsp.buf.definition()
    end, "lsp go to definition" },
    ["<leader>ld"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "floating diagnostic",
    },
  },
  v = {
    ["ñ"] = { ":Commentary<CR>", "comments text" },
  },
  t = {
    ["<C-w><C-w>"] = { "<C-\\><C-n><C-w><C-w>" },
    ["<A-m>"] = { "<C-\\><C-n>:lua require('nvterm.terminal').toggle('horizontal')<CR>" }
  }
}

return M
