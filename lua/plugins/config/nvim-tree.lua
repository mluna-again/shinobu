vim.o.termguicolors = true
vim.g.nvim_tree_side = "right"
vim.g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    deleted = "",
    ignored = "◌",
    renamed = "➜",
    staged = "✓",
    unmerged = "",
    unstaged = "✗",
    untracked = "★",
  },
  folder = {
    default = "",
    empty = "",
    empty_open = "",
    open = "",
    symlink = "",
    symlink_open = "",
  },
}

return {
  'kyazdani42/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup{
      filters = {
        dotfiles = false,
        custom = {
          ".git",
          ".cache",
        },
      },
      disable_netrw = true,
      hijack_netrw = true,
      ignore_ft_on_setup = {
        "dashboard",
        "startify",
        "alpha",
      },
      open_on_tab = false,
      hijack_cursor = true,
      update_cwd = true,
      update_focused_file = {
        enable = false,
        update_cwd = true,
        ignore_list = {},
      },
      diagnostics = {
        enable = false,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      view = {
        width = 25,
        height = 30,
        side = "left",
        hide_root_folder = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
				mappings = {
					list = {
						key = "X",
						action = "preview"
					}
				}
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 500,
      },
    }
  end
}
