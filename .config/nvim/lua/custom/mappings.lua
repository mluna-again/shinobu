local M = {}

M.general = {
  i = {
    ["jj"] = { "<ESC>", "enter NORMAL mode" }
  },
  n = {
    ["<C-Left>"] = { ":verticla resize -2<CR>", "resize window" },
    ["<C-Right>"] = { ":verticla resize +2<CR>", "resize window" },
    ["<C-Up>"] = { ":resize +2<CR>", "resize window" },
    ["<C-Down>"] = { ":resize -2<CR>", "resize window" },
    ["SS"] = { ":w<CR>", "save with autocmds" },
    ["ss"] = { ":noautocmd w<CR>", "save without autocmds" },
    ["gt"] = { ":BufferLineCycleNext<CR>", "cycle through buffers" },
    ["gr"] = { ":BufferLineCyclePrev<CR>", "cycle through buffers" },
    ["gT"] = { ":BufferLineMoveNext<CR>", "move buffers" },
    ["gR"] = { ":BufferLineMovePrev<CR>", "move buffers" },
    ["TT"] = { ":only<CR>", "close all but current buffers" },
    ["tt"] = { ":Bdelete<CR>", "close all buffers" },
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
    ["/"] = { ":Telescope current_buffer_fuzzy_find<CR>", "fuzzy find in buffer" },
    ["ñ"] = { ":Commentary<CR>", "comments text" },
  },
  v = {
    ["ñ"] = { ":Commentary<CR>", "comments text" },
  }
}

return M
