-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/mluna/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/mluna/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/mluna/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/mluna/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/mluna/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["auto-pairs"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/auto-pairs",
    url = "https://github.com/jiangmiao/auto-pairs"
  },
  ["bufferline.nvim"] = {
    config = { "\27LJ\2\n�\4\0\0\6\0\v\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0004\4\3\0005\5\3\0>\5\1\4=\4\5\3=\3\a\2B\0\2\0016\0\b\0009\0\t\0'\2\n\0B\0\2\1K\0\1\0000hi BufferLineHintSelected guifg=fg guibg=fg\bcmd\bvim\foptions\1\0\0\foffsets\1\0\15\20max_name_length\3\14\22max_prefix_length\3\r\20show_close_icon\1\28show_buffer_close_icons\2\22buffer_close_icon\b\16diagnostics\1\25enforce_regular_tabs\1\18modified_icon\b\27always_show_bufferline\1\24show_tab_indicators\2\22left_trunc_marker\b\tview\16multiwindow\20separator_style\tthin\23right_trunc_marker\b\rtab_size\3\20\1\0\3\ttext\18File explorer\rfiletype\rNvimTree\fpadding\3\1\nsetup\15bufferline\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-ultisnips"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/cmp-nvim-ultisnips",
    url = "https://github.com/quangnguyen30192/cmp-nvim-ultisnips"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  conjure = {
    config = { "\27LJ\2\n�\1\0\0\4\0\a\0\r6\0\0\0'\2\1\0'\3\2\0B\0\3\0016\0\0\0'\2\3\0'\3\4\0B\0\3\0016\0\0\0'\2\5\0'\3\6\0B\0\3\1K\0\1\0\24:ConjureEvalBuf<CR>\15<leader>cp :ConjureEvalCurrentForm<CR>\15<leader>ce\29:ConjureEvalRootForm<CR>\15<leader>cl\tnmap\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/conjure",
    url = "https://github.com/Olical/conjure"
  },
  ["dashboard-nvim"] = {
    config = { "\27LJ\2\n�Q\0\0\5\0 \0<6\0\0\0'\2\1\0B\0\2\0025\1\3\0=\1\2\0004\1\0\0=\1\4\0004\1\0\0=\1\5\0)\1\1\0=\1\6\0)\1\1\0=\1\a\0004\1\a\0005\2\b\0>\2\1\0015\2\t\0>\2\2\0015\2\n\0>\2\3\0015\2\v\0>\2\4\0015\2\f\0>\2\5\0015\2\r\0>\2\6\1=\1\4\0006\1\14\0'\3\15\0'\4\16\0B\1\3\0016\1\14\0'\3\17\0'\4\18\0B\1\3\0016\1\14\0'\3\19\0'\4\20\0B\1\3\0016\1\14\0'\3\21\0'\4\22\0B\1\3\0016\1\14\0'\3\23\0'\4\24\0B\1\3\0016\1\14\0'\3\25\0'\4\26\0B\1\3\0016\1\14\0'\3\27\0'\4\28\0B\1\3\0016\1\29\0009\1\30\1'\3\31\0B\1\2\1K\0\1\0�\1\t\taugroup DashboardTweaks\n\t\tautocmd!\n\t\tautocmd FileType dashboard set noruler\n\t\tautocmd FileType dashboard nmap <buffer> q :quit<CR>\n\t\taugroup END\n\t\t\bcmd\bvim :NvimTreeFindFileToggle<CR>\15<Leader>fn\26:DashboardNewFile<CR>\15<Leader>cn\30:Telescope find_files<CR>\15<Leader>ff\29:Telescope live_grep<CR>\15<Leader>fw\28:Telescope oldfiles<CR>\15<Leader>fo\19:Obsession<CR>\15<Leader>ss\28:source Session.vim<CR>\15<Leader>sl\tnmap\1\0\3\vaction\tquit\tdesc&Quit Neovim                     q\ticon\nﴘ  \1\0\3\vaction\16SessionLoad\tdesc&Load Last Session         SPC s l\ticon\t勒 \1\0\3\vaction\24Telescope live_grep\tdesc&Find Word                 SPC f a\ticon\n  \1\0\3\vaction\23Telescope oldfiles\tdesc&Recents                   SPC f h\ticon\nﲊ  \1\0\3\vaction\25Telescope find_files\tdesc&Find File                 SPC f f\ticon\n  \1\0\3\vaction\21DashboardNewFile\tdesc&New File                  SPC c n\ticon\n  \17hide_tabline\20hide_statusline\18custom_footer\18custom_center\1\31\0\0�\2┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐�\2│ ⠀⠀⠀⠀⣀⠀⠠⠄⠠⠀⠀⠀⠄⠄⠠⠀⠆⠀⠢⠀⠀⠁⡀⠈⠁⠀⠁⠀⡀⠀⠘⠄⠀⠄⠈⠀⠀⠁⠀⠀⠂⠀⠀⠀⠀⠈⠈⠅⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠂⠄⠀⠈⠀⠀⠈⠤⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠄⠂⠀│�\2│ ⡀⡀⠀⠀⠀⠀⡀⠀⢌⠀⠀⠂⠀⠀⠀⠀⠀⠀⠁⠀⢀⠀⠀⠠⠀⠀⠠⠀⠀⠀⡀⠀⠀⠀⠀⠀⠨⠀⣈⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠠⠀⠀⠀⠈⠀⠀⠀⠀⠄⠀⠂⠀⠀⠀⠀⠀⠀⠄⠀⠀⢱⣿⡦⠀⢀⠄⠀⠀⠄⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀│�\2│ ⠁⠀⢀⡈⠀⠂⠀⠀⠀⠀⠀⠀⠀⡂⠀⠐⠀⠈⠈⠀⠀⠀⠀⠀⠀⠂⠀⠀⠂⢄⠄⠠⠀⠂⠀⠂⢄⠀⠈⠉⠒⠀⠀⠀⠀⡈⠀⠁⠢⠒⠀⠀⠀⠀⠀⠀⠠⠀⠂⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⡀⠀⠀⠀⠀⠀⠀⠀⢈⠉⠁⠀⠀⠀⠀⡀⠀⠀⠀⠐⠀⠀⠀⠀⠀⠠⠀⠀⠀⠁│�\2│ ⠀⠀⡈⠀⠀⠀⠀⠀⠈⠀⠀⠂⠀⠈⠀⠂⠀⠀⠐⠈⡀⠀⠀⠀⠀⠀⠨⠀⠀⡀⠀⠀⠀⣠⣤⣅⠁⠀⠀⠄⠀⠃⠀⠂⠐⠀⠄⠐⠀⠀⠀⡀⠐⠀⠠⠀⠀⢀⡤⠤⣤⡠⠂⠀⠀⠀⠀⠀⠀⠒⠀⠀⠀⠀⠀⠀⠈⠠⠂⠀⠀⠀⠠⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⡄⡊⠀⢀⠀⠀⠁⠀⠀⣈⢠⡄⠀⣀⠀⢀⠀⠀⠻⣿⠿⠁⠄⡀⠀⠠⠀⠁⠠⠀⠀⠐⠐⡄⠀⠀⠀⠀⠀⠀⠃⠈⣟⠻⡝⢟⣿⠔⠀⠠⠀⠁⠀⠀⢀⣀⣤⣤⣤⣀⡀⠀⠀⠀⠐⠀⠀⠀⠂⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀│�\2│ ⠀⠀⠀⠀⠁⠄⠀⡀⠀⢂⠀⠀⠀⠁⠄⠈⠀⣀⠐⠀⠀⠀⠀⠐⠂⠄⠀⣀⣀⣀⣀⡀⠁⠐⠀⠨⢀⠢⠉⠀⠀⠁⡀⠃⢉⠐⢀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠙⢧⣻⡱⠞⠀⠀⠀⠀⠀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠠⠄⠀⠀⠀⠀⠀⠀⠈│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠂⠀⠠⣀⠀⠀⠁⡀⠐⠊⠀⠀⢄⣴⣿⣿⣿⣿⣿⣿⣷⣔⠀⠀⠀⠀⠄⠀⢊⠀⡄⠁⠀⠂⠀⠠⠈⠀⠄⠀⠀⠀⠀⠔⠀⠂⠀⠀⠀⠈⠈⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡶⠞⢛⣻⣻⣿⡿⠇⢀⠐⠀⠀⠀⠀⠀⠀⠀⠂⠠⠀⠀│�\2│ ⠀⠀⠁⠀⠀⠀⠄⠀⡀⠀⠀⠀⠀⠐⠀⢀⡀⠀⠐⢀⠀⠄⠀⢁⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠠⠁⠘⠀⠀⠀⠀⠈⠀⠀⣂⠀⠀⡀⠁⠀⠀⠀⡀⠠⠅⠀⠠⠀⠁⠀⠀⠀⠀⢀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠿⠟⠟⠉⠁⠈⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠈⠆⠀⠠⠀⠀⠐⠀⠀⠀⠀⡠⠀⠀⠀⠀⠀⠁⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠃⠀⠁⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠁⠀⠀⢀⣠⣤⡶⠟⢛⣹⣿⣿⣿⣿⣻⣿⣯⣿⣷⣿⣿⣿⣿⡇⠀⠀⠀⢈⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀│�\2│ ⠐⠀⠀⠀⠀⠀⠀⢀⡀⠀⠁⠀⠁⠀⠀⢠⣄⠐⠀⠄⠈⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠁⠀⠀⠠⠠⠀⠄⠀⢐⠠⠀⠁⠀⠀⠀⠀⠔⢀⠀⠀⠀⠰⠽⠿⠿⠿⠿⠛⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠫⠀⠀⠀⠀⠀⠀⢈⡞⢑⣛⣯⣿⣿⠿⠿⠋⡁⠀⠀⠐⠀⠀⠀⠀⠠⠀⠠⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⡿⠟⠉⠀⠀⠀⠠⠰⠐⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠄⠐⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠘⣿⣟⣿⣟⢿⠇⠄⠀⠂⡀⠀⠀⠀⠀⠀⠀⠅⠈⠂⢀⠤⠒⠉⠁⠀⠀⠉⠓⣄⠀⢈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⡀⠀⠀⠀⠀⠀⠈⢉⢉⢀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⢠⠀⠀⠀⠀⠂⠠⠀⠀⠀⠀⠈⠙⠛⠋⠅⠄⠀⠀⠀⠃⠀⠠⠀⠀⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⣤⡀⠈⣦⡀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⡀⠀⠀⠐⠀⡀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠂⠀⠈⠀⠀⠄⠁⠀⠐⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⠀⠀⠀⠀⠀⠀⠀⠙⠗⠀⠈⠱⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠁⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⡀⠀⠈⠀⡀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠱⡀⠀⠀⠀⠀⠀⡔⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠈⠀⠀⠂⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡃⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⠁⠀⠀⠀⠀⠀⠈⠢⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠔⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠤⠤⠀⠀⠀⣀⣀⣀⣀⣀⣀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡃⠀⣀⣀⣒⣒⣂⣀⡀⠀⠀⠀⠀⠤⠤⠤⠤⠤⠤⠄⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠤⢀⣀⣉⣉⣁⣒⠒⠒⠶⠶⣤⠤⡤⠤⠭⣉⣉⣉⣛⣛⣛⡒⣒⣒⣂⣀⣀⣠⣀⣀⠀⠠⠀⠀⠤⠤⠤⠤⠔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⠀⠀⠀⠠⠤⠤⠄⠀⠀⢀⣀⣀⣐⣀⣘⣉⣉⣉⣉⡉⠉⠉⠭⠤⠤⠤⠤⠤⠶⠀⠀⢀⣀⣀⣈⣉⣉⣉⡉⠉│�\2│ ⣧⣶⣶⣿⣿⠿⠷⠾⠿⠟⠛⠛⠛⢳⣚⣛⣛⣭⠭⠭⠅⠉⢩⣛⣿⣳⣒⣳⣶⣂⣀⣀⠀⠈⠉⠭⠭⠭⠯⠍⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠄⠠⠤⠥⠨⠉⠉⣄⣀⣄⣰⡚⠒⠒⣂⣈⣸⡿⠿⠿⠿⠿⠉⠈⣙⣻⣿⣿⡿⡷⠄⢶⣿⣷⣷⣶⡖⣀⣐⣂│�\2│ ⠦⠤⠽⡗⠓⠒⣺⣯⣭⠿⠿⠶⠒⢒⣒⣛⣛⠉⠭⠭⠭⣭⣥⣄⣄⣶⣶⣶⣶⣶⣶⡶⢦⠦⣤⣤⠿⠿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠿⠿⣿⣖⣶⣴⣶⣶⣶⣶⣖⣀⣭⣭⣭⣍⣀⣒⣒⣒⣛⡻⠛⠿⠥⠴⠶⢶⣾⣛⣩⣭⣭⠵⠶⢒⠒⡛⠁│�\2│ ⠤⢒⣒⠉⣉⠁⣠⡄⣀⣉⣹⡭⠷⠶⠖⠛⣿⡓⠢⡼⠿⡉⠛⠓⠲⠖⠄⠶⠒⠛⣛⠛⠋⢉⣉⣉⣛⠿⠯⡇⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⢸⣿⠿⠾⣛⣋⣿⠷⠒⣖⡚⢛⣊⠭⣿⣛⣙⡟⠛⠛⣿⣿⠟⢒⣶⣿⢻⣭⠴⣶⣒⢦⣤⢩⣉⡉⠐⠚⠓⠠⠤│�\2│ ⠭⠃⠉⢲⠝⠩⢙⠉⠉⠀⠀⠡⠒⢈⠉⡠⢀⠜⡓⠉⠛⠀⡤⠲⠝⠉⠀⢠⠊⢉⠒⠂⣬⠓⠒⢲⡌⢻⣻⣧⣀⣀⡠⠧⠄⢀⣀⣀⣀⣀⣀⣀⠠⠤⢤⣶⡶⠯⠹⠿⣹⣭⣒⡯⢆⡒⢫⡍⠀⡈⠑⠌⠙⠛⢶⣟⠹⡫⣅⠒⠠⡉⠉⠉⠒⠚⠥⡚⠉⠐⠈⠩⡑⠫⡚⠩⡁⠒⠒⠤│�\2│ ⠄⡀⠀⠁⠀⡢⣠⢄⡀⠀⠘⠤⣀⠑⢌⣢⢀⡒⠤⢄⣀⣄⠑⠪⠤⠀⠀⠈⠒⠤⢉⣒⠒⠫⠭⠭⠁⠿⢚⡒⠈⢉⡉⠾⠟⠋⠉⠭⠭⢉⣙⣛⠛⠟⠦⠬⠟⢈⣓⣒⣒⣒⣒⠤⠤⢭⡓⠒⢉⠬⢕⣁⣬⡠⠴⡋⣤⠣⢟⣀⠴⠃⠀⠀⢀⣀⡴⠆⠔⢃⠀⠤⣃⠤⡀⠥⠊⠀⠀⠀│�\2└─────────────────────────────────────────────────────────────────────────────────────────────────────┘\18custom_header\14dashboard\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/dashboard-nvim",
    url = "https://github.com/glepnir/dashboard-nvim"
  },
  ["editorconfig-vim"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/editorconfig-vim",
    url = "https://github.com/editorconfig/editorconfig-vim"
  },
  ["emmet-vim"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  fzf = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["git-messenger.vim"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/git-messenger.vim",
    url = "https://github.com/rhysd/git-messenger.vim"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/goyo.vim",
    url = "https://github.com/junegunn/goyo.vim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["kanagawa.nvim"] = {
    config = { "\27LJ\2\n�\f\0\0\3\0\4\0\t6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\1K\0\1\0\25colorscheme kanagawa�\v\t\taugroup Kanawaga\n\t\t\tautocmd!\n\t\t\tautocmd ColorScheme * hi Normal guibg=NONE\n\n\t\t  autocmd ColorScheme * hi TelescopePromptBorder guibg=#16161D guifg=#16161D\n\t\t  autocmd ColorScheme * hi TelescopePromptCounter guibg=#16161D guifg=#C8C093\n\t\t  autocmd ColorScheme * hi TelescopePromptNormal guibg=#16161D guifg=#C8C093\n\t\t  autocmd ColorScheme * hi TelescopePromptTitle guibg=#C34043 guifg=#16161D\n\n\t\t  autocmd ColorScheme * hi TelescopePreviewBorder guibg=#16161D guifg=#16161D\n\t\t  autocmd ColorScheme * hi TelescopePreviewNormal guibg=#16161D guifg=#C8C093\n\t\t  autocmd ColorScheme * hi TelescopePreviewTitle guibg=#957FB8 guifg=#16161D\n\n\t\t  autocmd ColorScheme * hi TelescopeResultsBorder guibg=#16161D guifg=#16161D\n\t\t  autocmd ColorScheme * hi TelescopeResultsNormal guibg=#16161D guifg=#C8C093\n\t\t  autocmd ColorScheme * hi TelescopeResultsTitle guibg=#6A9589 guifg=#16161D\n\n\t\t\tautocmd ColorScheme * hi VertSplit guibg=#16161D\n\t\t\tautocmd ColorScheme * hi NvimTreeNormal guibg=#16161D\n\t\t\tautocmd ColorScheme * hi NvimTreeNormalNC guibg=#16161D\n\t\t\tautocmd ColorScheme * hi NvimTreeEndOfBuffer guibg=#16161D guifg=#16161D\n\n\t\t\tautocmd ColorScheme * hi WinSeparator guibg=NONE guifg=#16161D\n\n\t\t\tautocmd ColorScheme * hi DashboardHeader guibg=NONE guifg=#54546D\n\t\t\tautocmd ColorScheme * hi DashboardCenter guibg=NONE guifg=#54546D\n\t\t\tautocmd ColorScheme * hi DashboardShortCut guibg=NONE guifg=#54546D\n\t\t\tautocmd ColorScheme * hi DashboardFooter guibg=NONE guifg=#54546D\n\t\taugroup end\n\t\t\bcmd\bvim\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/kanagawa.nvim",
    url = "https://github.com/rebelot/kanagawa.nvim"
  },
  ["lightspeed.nvim"] = {
    config = { "\27LJ\2\n<\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\15lightspeed\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/lightspeed.nvim",
    url = "https://github.com/ggandor/lightspeed.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n�\5\0\0\a\0%\0?6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0004\5\0\0=\5\a\0044\5\0\0=\5\b\4=\4\t\3=\3\v\0025\3\17\0004\4\3\0005\5\f\0005\6\r\0=\6\14\0055\6\15\0=\6\16\5>\5\1\4=\4\18\0035\4\20\0005\5\19\0>\5\1\4=\4\21\0034\4\3\0005\5\22\0>\5\1\4=\4\23\0035\4\24\0=\4\25\0034\4\3\0005\5\26\0>\5\1\4=\4\27\0034\4\3\0005\5\28\0>\5\1\4=\4\29\3=\3\30\0025\3 \0005\4\31\0=\4\18\0034\4\0\0=\4\21\0034\4\0\0=\4\23\0034\4\0\0=\4\25\0034\4\0\0=\4\27\0035\4!\0=\4\29\3=\3\"\0024\3\0\0=\3#\0024\3\0\0=\3$\2B\0\2\1K\0\1\0\15extensions\ftabline\22inactive_sections\1\2\0\0\rlocation\1\0\0\1\2\0\0\rfilename\rsections\14lualine_z\1\2\1\0\rprogress\ticon\b\14lualine_y\1\2\1\0.vim.fn.fnamemodify(vim.fn.getcwd(), \":t\")\ticon\t \14lualine_x\1\2\0\0\16diagnostics\14lualine_c\1\2\1\0\vbranch\ticon\b\14lualine_b\1\3\0\0\0\rfilename\1\2\1\0\rfiletype\14icon_only\2\14lualine_a\1\0\0\ncolor\1\0\1\bgui\tbold\14separator\1\0\1\tleft\5\1\2\2\0\tmode\18right_padding\3\2\ticon\b\foptions\1\0\0\23disabled_filetypes\vwinbar\15statusline\1\0\0\23section_separators\1\0\2\nright\5\tleft\5\1\0\1\25component_separators\5\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/hoob3rt/lualine.nvim"
  },
  neoformat = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/neoformat",
    url = "https://github.com/sbdchd/neoformat"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n�\3\0\0\4\0\14\0\0246\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\0014\0\0\0005\1\a\0005\2\b\0>\2\2\1=\1\6\0005\1\n\0005\2\v\0>\2\2\1=\1\t\0006\1\0\0'\3\f\0B\1\2\0029\1\r\1\18\3\0\0B\1\2\1K\0\1\0\17set_mappings\21neoscroll.config\1\4\0\0\18vim.wo.scroll\ttrue\b250\1\2\0\0\vscroll\6}\1\4\0\0\19-vim.wo.scroll\ttrue\b250\1\2\0\0\vscroll\6{\rmappings\1\0\6\16hide_cursor\1\rstop_eof\2\24use_local_scrolloff\1\22respect_scrolloff\1\25cursor_scrolls_alone\2\21performance_mode\1\1\f\0\0\n<C-u>\n<C-d>\n<C-b>\n<C-f>\n<C-y>\n<C-e>\azt\azz\azb\6{\6}\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n�\1\0\0\b\0\b\2!6\0\0\0006\2\1\0009\2\2\0029\2\3\2)\4\0\0B\2\2\0A\0\0\3\b\1\0\0X\2\20�6\2\1\0009\2\2\0029\2\4\2)\4\0\0\23\5\1\0\18\6\0\0+\a\2\0B\2\5\2:\2\1\2\18\4\2\0009\2\5\2\18\5\1\0\18\6\1\0B\2\4\2\18\4\2\0009\2\6\2'\5\a\0B\2\3\2\n\2\0\0X\2\2�+\2\1\0X\3\1�+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\vunpack\0\2:\0\1\4\0\4\0\0066\1\0\0009\1\1\0019\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\19UltiSnips#Anon\afn\bvim�\1\0\1\3\2\6\0\21-\1\0\0009\1\0\1B\1\1\2\14\0\1\0X\1\15�6\1\1\0009\1\2\0019\1\3\1\6\1\4\0X\1\b�-\1\1\0B\1\1\2\15\0\1\0X\2\4�-\1\0\0009\1\5\1B\1\1\1X\1\2�\18\1\0\0B\1\1\1K\0\1\0\1�\2�\rcomplete\vprompt\fbuftype\abo\bvim\21select_next_item�\1\0\1\3\2\6\0\21-\1\0\0009\1\0\1B\1\1\2\14\0\1\0X\1\15�6\1\1\0009\1\2\0019\1\3\1\6\1\4\0X\1\b�-\1\1\0B\1\1\2\15\0\1\0X\2\4�-\1\0\0009\1\5\1B\1\1\1X\1\2�\18\1\0\0B\1\1\1K\0\1\0\1�\2�\rcomplete\vprompt\fbuftype\abo\bvim\21select_prev_item�\1\0\2\a\1\b\0\0156\2\1\0009\2\2\2'\4\3\0-\5\0\0009\6\0\0018\5\6\0059\6\0\1B\2\4\2=\2\0\0015\2\5\0009\3\6\0009\3\a\0038\2\3\2=\2\4\1L\1\2\0\0�\tname\vsource\1\0\3\vbuffer\r[Buffer]\fluasnip\14[LuaSnip]\rnvim_lsp\n[LSP]\tmenu\n%s %s\vformat\vstring\tkind�\14\1\0\f\0W\0�\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\0026\3\n\0009\3\v\3'\5\f\0006\6\r\0009\6\14\6'\b\15\0B\6\2\0A\3\1\2=\3\16\2B\0\2\0015\0\17\0006\1\0\0'\3\18\0B\1\2\0023\2\19\0009\3\2\0015\5\23\0005\6\21\0003\a\20\0=\a\22\6=\6\24\0055\6\26\0005\a\25\0=\a\27\6=\6\28\0055\6 \0009\a\29\0019\a\30\a9\a\31\aB\a\1\2=\a!\0069\a\29\0019\a\30\a9\a\31\aB\a\1\2=\a\"\6=\6\30\0059\6#\0019\6$\0069\6%\0065\b'\0009\t#\0019\t&\t)\v��B\t\2\2=\t(\b9\t#\0019\t&\t)\v\4\0B\t\2\2=\t)\b9\t#\0019\t*\tB\t\1\2=\t+\b9\t#\0019\t,\tB\t\1\2=\t-\b9\t#\0019\t.\t5\v/\0B\t\2\2=\t0\b3\t1\0=\t2\b3\t3\0=\t4\bB\6\2\2=\6#\0059\6\29\0019\0065\0064\b\3\0005\t6\0>\t\1\b5\t7\0>\t\2\b4\t\3\0005\n8\0>\n\1\tB\6\3\2=\0065\0055\6:\0003\a9\0=\a\v\6=\6;\5B\3\2\0016\3\0\0'\5<\0B\3\2\0029\3=\0036\5>\0009\5?\0059\5@\0059\5A\5B\5\1\0A\3\0\0026\4\0\0'\6B\0B\4\2\0029\4C\0049\4\2\0045\6D\0=\3E\6B\4\2\0016\4\0\0'\6B\0B\4\2\0029\4F\0049\4\2\0045\6G\0=\3E\6B\4\2\0016\4\0\0'\6B\0B\4\2\0029\4H\0049\4\2\0045\6I\0=\3E\6B\4\2\0016\4\0\0'\6B\0B\4\2\0029\4J\0049\4\2\0045\6K\0=\3E\6B\4\2\0016\4\0\0'\6B\0B\4\2\0029\4L\0049\4\2\0045\6M\0=\3E\6B\4\2\0016\4N\0'\6O\0'\aP\0B\4\3\0016\4N\0'\6Q\0'\aR\0B\4\3\0016\4N\0'\6S\0'\aT\0B\4\3\0016\4N\0'\6U\0'\aV\0B\4\3\0012\0\0�K\0\1\0):lua vim.diagnostic.open_float()<CR>\15<Leader>ld&:lua vim.lsp.buf.definition()<CR>\15<Leader>lf\":lua vim.lsp.buf.rename()<CR>\15<Leader>lr!:lua vim.lsp.buf.hover()<CR>\15<Leader>lh\tnmap\1\0\0\ngopls\1\0\0\15solargraph\1\0\0\ncssls\1\0\0\rtsserver\17capabilities\1\0\0\relixirls\14lspconfig\29make_client_capabilities\rprotocol\blsp\bvim\25default_capabilities\17cmp_nvim_lsp\15formatting\1\0\0\0\1\0\1\tname\vbuffer\1\0\1\tname\14ultisnips\1\0\1\tname\rnvim_lsp\fsources\f<S-Tab>\0\n<Tab>\0\t<CR>\1\0\1\vselect\2\fconfirm\n<C-e>\nabort\14<C-Space>\rcomplete\n<C-f>\n<C-b>\1\0\0\16scroll_docs\vinsert\vpreset\fmapping\18documentation\15completion\1\0\0\rbordered\vwindow\vconfig\tview\fentries\1\0\0\1\0\1\tname\vcustom\fsnippet\1\0\0\vexpand\1\0\0\0\0\bcmp\1\0\25\nEvent\b\vMethod\b\nClass\bﴯ\nColor\b\rOperator\b\fSnippet\b\14Interface\b\fKeyword\b\18TypeParameter\b\tEnum\b\tFile\b\rFunction\b\14Reference\b\nValue\b\vFolder\b\16Constructor\b\15EnumMember\b\rConstant\b\vModule\b\nField\b\rProperty\bﰠ\vStruct\b\tUnit\b\rVariable\b\tText\b\21install_root_dir\tHOME\vgetenv\aos\18%s/.local/bin\vformat\vstring\aui\nicons\1\0\0\1\0\3\23server_uninstalled\b✗\21server_installed\b✓\19server_pending\b➜\21ensure_installed\1\0\1\27automatic_installation\2\1\6\0\0\relixirls\rtsserver\16sumneko_lua\ncssls\ngopls\nsetup\23nvim-lsp-installer\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n�\17\0\0\b\0F\0S6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0004\5\0\0=\5\6\4=\4\a\3=\3\b\0025\3\t\0005\4\n\0005\5\v\0=\5\f\4=\4\r\0035\4\14\0005\5\15\0=\5\16\0045\5\17\0005\6\18\0=\6\19\0055\6\20\0=\6\21\5=\5\22\4=\4\f\0035\4\23\0=\4\24\3=\3\25\0025\3\26\0=\3\27\0025\3\28\0004\4\0\0=\4\29\3=\3\30\0024\3\0\0=\3\31\0025\3 \0004\4\0\0=\4!\3=\3\"\0025\3#\0005\4$\0=\4\f\3=\3%\0025\3&\0004\4\0\0=\4'\0034\4\0\0=\4(\3=\3)\0025\3*\0=\3+\0025\3,\0=\3\21\0025\3-\0005\4.\0=\4/\0035\0040\0=\0041\0035\0042\0005\0053\0005\0065\0005\a4\0=\a6\0065\a7\0=\a8\6=\6(\5=\0059\4=\4:\0035\4;\0=\4<\3=\3=\0025\3>\0=\3?\0025\3@\0=\3A\0025\3B\0005\4C\0=\4D\3=\3E\2B\0\2\1K\0\1\0\blog\ntypes\1\0\a\16diagnostics\1\15copy_paste\1\bgit\1\vconfig\1\fprofile\1\fwatcher\1\ball\1\1\0\2\rtruncate\1\venable\1\16live_filter\1\0\2\vprefix\15[FILTER]: \24always_show_folders\2\ntrash\1\0\2\bcmd\14gio trash\20require_confirm\2\factions\16remove_file\1\0\1\17close_window\2\14open_file\18window_picker\fbuftype\1\4\0\0\vnofile\rterminal\thelp\rfiletype\1\0\0\1\a\0\0\vnotify\vpacker\aqf\tdiff\rfugitive\18fugitiveblame\1\0\2\nchars)ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890\venable\2\1\0\2\18resize_window\2\17quit_on_open\1\15expand_all\1\0\1\25max_folder_discovery\3�\2\15change_dir\1\0\3\23restrict_above_cwd\1\venable\2\vglobal\1\1\0\1\25use_system_clipboard\2\1\0\3\venable\2\ftimeout\3�\3\vignore\1\24filesystem_watchers\1\0\1\venable\1\ffilters\fexclude\vcustom\1\0\1\rdotfiles\1\16diagnostics\1\0\4\fwarning\b\tinfo\b\thint\b\nerror\b\1\0\2\17show_on_dirs\1\venable\1\16system_open\targs\1\0\1\bcmd\5\23ignore_ft_on_setup\24update_focused_file\16ignore_list\1\0\2\15update_cwd\1\venable\1\23hijack_directories\1\0\2\venable\2\14auto_open\2\rrenderer\18special_files\1\5\0\0\15Cargo.toml\rMakefile\14README.md\14readme.md\vglyphs\bgit\1\0\a\vstaged\b✓\fdeleted\b\runmerged\b\frenamed\b➜\runstaged\b✗\14untracked\b★\fignored\b◌\vfolder\1\0\b\17arrow_closed\b\topen\b\nempty\b\fsymlink\b\fdefault\b\15arrow_open\b\17symlink_open\b\15empty_open\b\1\0\2\fsymlink\b\fdefault\b\tshow\1\0\4\bgit\2\tfile\2\vfolder\2\17folder_arrow\2\1\0\4\18git_placement\vbefore\18symlink_arrow\n ➛ \18webdev_colors\2\fpadding\6 \19indent_markers\nicons\1\0\4\vcorner\t└ \titem\t│ \tnone\a  \tedge\t│ \1\0\1\venable\1\1\0\6\17add_trailing\1\16group_empty\1\18highlight_git\1\14full_name\1\27highlight_opened_files\tnone\25root_folder_modifier\a:~\tview\rmappings\tlist\1\0\1\16custom_only\1\1\0\t\15signcolumn\byes\nwidth\3\30\18adaptive_size\1\25centralize_selection\1\21hide_root_folder\1\vnumber\1\tside\tleft preserve_window_proportions\1\19relativenumber\1\1\0\14\18hijack_cursor\1\20respect_buf_cwd\1\23reload_on_bufenter\1\18open_on_setup\1\23open_on_setup_file\1\fsort_by\tname\16open_on_tab\1\25auto_reload_on_write\2\28create_in_closed_folder\1\18disable_netrw\1\15update_cwd\1\17hijack_netrw\2'hijack_unnamed_buffer_when_opening\1\27ignore_buffer_on_setup\1\nsetup\14nvim-tree\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n�\2\0\0\5\0\n\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\0\0=\3\6\0025\3\a\0004\4\0\0=\4\b\3=\3\t\2B\0\2\1K\0\1\0\14highlight\fdisable\1\0\2&additional_vim_regex_highlighting\1\venable\2\19ignore_install\21ensure_installed\1\0\1\17sync_install\1\1\14\0\0\velixir\15typescript\thttp\tjson\15javascript\truby\fclojure\fc_sharp\ago\vkotlin\nscala\tbash\bsql\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    config = { "\27LJ\2\n�\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\roverride\1\0\0\arb\1\0\0\1\0\3\tname\truby\ncolor\f#a91401\ticon\b\nsetup\22nvim-web-devicons\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["symbols-outline.nvim"] = {
    config = { "\27LJ\2\n�\f\0\0\5\0B\0G6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\0024\3\0\0=\3\n\0024\3\0\0=\3\v\0025\3\r\0005\4\f\0=\4\14\0035\4\15\0=\4\16\0035\4\17\0=\4\18\0035\4\19\0=\4\20\0035\4\21\0=\4\22\0035\4\23\0=\4\24\0035\4\25\0=\4\26\0035\4\27\0=\4\28\0035\4\29\0=\4\30\0035\4\31\0=\4 \0035\4!\0=\4\"\0035\4#\0=\4$\0035\4%\0=\4&\0035\4'\0=\4(\0035\4)\0=\4*\0035\4+\0=\4,\0035\4-\0=\4.\0035\4/\0=\0040\0035\0041\0=\0042\0035\0043\0=\0044\0035\0045\0=\0046\0035\0047\0=\0048\0035\0049\0=\4:\0035\4;\0=\4<\0035\4=\0=\4>\0035\4?\0=\4@\3=\3A\2B\0\2\1K\0\1\0\fsymbols\18TypeParameter\1\0\2\ticon\t𝙏\ahl\16TSParameter\rOperator\1\0\2\ticon\6+\ahl\15TSOperator\nEvent\1\0\2\ticon\t🗲\ahl\vTSType\vStruct\1\0\2\ticon\t𝓢\ahl\vTSType\15EnumMember\1\0\2\ticon\b\ahl\fTSField\tNull\1\0\2\ticon\tNULL\ahl\vTSType\bKey\1\0\2\ticon\t🔐\ahl\vTSType\vObject\1\0\2\ticon\b⦿\ahl\vTSType\nArray\1\0\2\ticon\b\ahl\15TSConstant\fBoolean\1\0\2\ticon\b⊨\ahl\14TSBoolean\vNumber\1\0\2\ticon\6#\ahl\rTSNumber\vString\1\0\2\ticon\t𝓐\ahl\rTSString\rConstant\1\0\2\ticon\b\ahl\15TSConstant\rVariable\1\0\2\ticon\b\ahl\15TSConstant\rFunction\1\0\2\ticon\b\ahl\15TSFunction\14Interface\1\0\2\ticon\bﰮ\ahl\vTSType\tEnum\1\0\2\ticon\bℰ\ahl\vTSType\16Constructor\1\0\2\ticon\b\ahl\18TSConstructor\nField\1\0\2\ticon\b\ahl\fTSField\rProperty\1\0\2\ticon\b\ahl\rTSMethod\vMethod\1\0\2\ticon\aƒ\ahl\rTSMethod\nClass\1\0\2\ticon\t𝓒\ahl\vTSType\fPackage\1\0\2\ticon\b\ahl\16TSNamespace\14Namespace\1\0\2\ticon\b\ahl\16TSNamespace\vModule\1\0\2\ticon\b\ahl\16TSNamespace\tFile\1\0\0\1\0\2\ticon\b\ahl\nTSURI\21symbol_blacklist\18lsp_blacklist\fkeymaps\nclose\1\0\v\rfold_all\6W\19toggle_preview\6K\15unfold_all\6E\15fold_reset\6R\18goto_location\t<Cr>\19focus_location\6o\17hover_symbol\14<C-space>\18rename_symbol\6r\17code_actions\6a\tfold\6h\vunfold\6l\1\3\0\0\n<Esc>\6q\17fold_markers\1\3\0\0\b\b\1\0\r\22auto_unfold_hover\2\16show_guides\2\27highlight_hovered_item\2\17auto_preview\1\rposition\nright\nwidth\3\25\twrap\1\19relative_width\2\15auto_close\1\17show_numbers\1\26show_relative_numbers\1\24show_symbol_details\2\25preview_bg_highlight\nPmenu\nsetup\20symbols-outline\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/symbols-outline.nvim",
    url = "https://github.com/simrat39/symbols-outline.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n�\b\0\0\a\0%\0@6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2!\0005\3\4\0005\4\3\0=\4\5\0035\4\a\0005\5\6\0=\5\b\0045\5\t\0=\5\n\4=\4\v\0036\4\0\0'\6\f\0B\4\2\0029\4\r\4=\4\14\0035\4\15\0=\4\16\0036\4\0\0'\6\f\0B\4\2\0029\4\17\4=\4\18\0035\4\19\0=\4\20\0034\4\0\0=\4\21\0035\4\22\0=\4\23\0036\4\0\0'\6\24\0B\4\2\0029\4\25\0049\4\26\4=\4\27\0036\4\0\0'\6\24\0B\4\2\0029\4\28\0049\4\26\4=\4\29\0036\4\0\0'\6\24\0B\4\2\0029\4\30\0049\4\26\4=\4\31\0036\4\0\0'\6\24\0B\4\2\0029\4 \4=\4 \3=\3\"\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0#\0'\2$\0B\0\2\1K\0\1\0\bfzf\19load_extension\rdefaults\1\0\0\27buffer_previewer_maker\21qflist_previewer\22vim_buffer_qflist\19grep_previewer\23vim_buffer_vimgrep\19file_previewer\bnew\19vim_buffer_cat\25telescope.previewers\fset_env\1\0\1\14COLORTERM\14truecolor\vborder\17path_display\1\2\0\0\rtruncate\19generic_sorter\29get_generic_fuzzy_sorter\25file_ignore_patterns\1\2\0\0\17node_modules\16file_sorter\19get_fuzzy_file\22telescope.sorters\18layout_config\rvertical\1\0\1\vmirror\1\15horizontal\1\0\3\19preview_cutoff\3x\nwidth\4����\3����\3\vheight\4͙��\f̙��\3\1\0\3\20prompt_position\btop\18preview_width\4����\t����\3\18results_width\4����\t����\3\22vimgrep_arguments\1\0\n\19color_devicons\2\ruse_less\2\18prompt_prefix\n  \17entry_prefix\a  \17initial_mode\vinsert\23selection_strategy\nreset\21sorting_strategy\14ascending\20layout_strategy\15horizontal\20selection_caret\a  \rwinblend\3\0\1\b\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\nsetup\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\n�\a\0\0\6\0*\00016\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\a\0005\4\4\0005\5\5\0=\5\6\4=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\0035\4\r\0005\5\14\0=\5\6\4=\4\15\0035\4\16\0005\5\17\0=\5\6\4=\4\18\0035\4\19\0005\5\20\0=\5\6\4=\4\21\3=\3\22\0025\3\23\0004\4\0\0=\4\24\3=\3\25\0025\3\27\0005\4\26\0=\4\28\0035\4\29\0=\4\30\0035\4\31\0=\4 \0035\4!\0=\4\"\0035\4#\0=\4$\3=\3%\0025\3&\0005\4'\0=\4(\3=\3)\2B\0\2\1K\0\1\0\vsearch\targs\1\6\0\0\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\1\0\2\fpattern\18\\b(KEYWORDS):\fcommand\arg\vcolors\fdefault\1\3\0\0\15Identifier\f#7C3AED\thint\1\3\0\0\19DiagnosticHint\f#10B981\tinfo\1\3\0\0\19DiagnosticInfo\f#2563EB\fwarning\1\4\0\0\22DiagnosticWarning\15WarningMsg\f#FBBF24\nerror\1\0\0\1\4\0\0\20DiagnosticError\rErrorMsg\f#DC2626\14highlight\fexclude\1\0\6\nafter\afg\17max_line_len\3�\3\vbefore\5\fpattern\22.*<(KEYWORDS)\\s*:\fkeyword\twide\18comments_only\2\rkeywords\tNOTE\1\2\0\0\tINFO\1\0\2\ncolor\thint\ticon\t \tPERF\1\4\0\0\nOPTIM\16PERFORMANCE\rOPTIMIZE\1\0\1\ticon\t \tWARN\1\3\0\0\fWARNING\bXXX\1\0\2\ncolor\fwarning\ticon\t \tHACK\1\0\2\ncolor\fwarning\ticon\t \tTODO\1\0\2\ncolor\tinfo\ticon\t \bFIX\1\0\0\balt\1\5\0\0\nFIXME\bBUG\nFIXIT\nISSUE\1\0\2\ncolor\nerror\ticon\t \1\0\2\nsigns\2\19merge_keywords\2\nsetup\18todo-comments\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "\27LJ\2\ny\0\1\2\0\6\1\0159\1\0\0\a\1\1\0X\1\3�)\1\15\0L\1\2\0X\1\b�9\1\0\0\a\1\2\0X\1\5�6\1\3\0009\1\4\0019\1\5\1\24\1\0\1L\1\2\0K\0\1\0\fcolumns\6o\bvim\rvertical\15horizontal\14direction��̙\19����\3�\1\1\0\4\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0003\3\3\0=\3\5\2B\0\2\0016\0\6\0'\2\a\0'\3\b\0B\0\3\1K\0\1\0\25<C-\\><C-n><C-w><C-w>\15<C-w><C-w>\ttmap\tsize\1\0\6\17open_mapping\n<A-m>\14direction\15horizontal\16auto_scroll\2\18close_on_exit\2\20start_in_insert\2\17hide_numbers\2\0\nsetup\15toggleterm\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/ultisnips",
    url = "https://github.com/SirVer/ultisnips"
  },
  ["vim-bbye"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/vim-bbye",
    url = "https://github.com/moll/vim-bbye"
  },
  ["vim-closetag"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/vim-closetag",
    url = "https://github.com/alvan/vim-closetag"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-elixir"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/vim-elixir",
    url = "https://github.com/elixir-editors/vim-elixir"
  },
  ["vim-endwise"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/vim-endwise",
    url = "https://github.com/tpope/vim-endwise"
  },
  ["vim-misc"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/vim-misc",
    url = "https://github.com/xolox/vim-misc"
  },
  ["vim-obsession"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/vim-obsession",
    url = "https://github.com/tpope/vim-obsession"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-test"] = {
    config = { "\27LJ\2\n�\1\0\0\4\0\a\0\r6\0\0\0'\2\1\0'\3\2\0B\0\3\0016\0\0\0'\2\3\0'\3\4\0B\0\3\0016\0\0\0'\2\5\0'\3\6\0B\0\3\1K\0\1\0\19:TestSuite<CR>\14<Leader>T\18:TestFile<CR>\14<Leader>R\21:TestNearest<CR>\14<Leader>r\tnmap\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/vim-test",
    url = "https://github.com/vim-test/vim-test"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/Users/mluna/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: bufferline.nvim
time([[Config for bufferline.nvim]], true)
try_loadstring("\27LJ\2\n�\4\0\0\6\0\v\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0004\4\3\0005\5\3\0>\5\1\4=\4\5\3=\3\a\2B\0\2\0016\0\b\0009\0\t\0'\2\n\0B\0\2\1K\0\1\0000hi BufferLineHintSelected guifg=fg guibg=fg\bcmd\bvim\foptions\1\0\0\foffsets\1\0\15\20max_name_length\3\14\22max_prefix_length\3\r\20show_close_icon\1\28show_buffer_close_icons\2\22buffer_close_icon\b\16diagnostics\1\25enforce_regular_tabs\1\18modified_icon\b\27always_show_bufferline\1\24show_tab_indicators\2\22left_trunc_marker\b\tview\16multiwindow\20separator_style\tthin\23right_trunc_marker\b\rtab_size\3\20\1\0\3\ttext\18File explorer\rfiletype\rNvimTree\fpadding\3\1\nsetup\15bufferline\frequire\0", "config", "bufferline.nvim")
time([[Config for bufferline.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n�\17\0\0\b\0F\0S6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0004\5\0\0=\5\6\4=\4\a\3=\3\b\0025\3\t\0005\4\n\0005\5\v\0=\5\f\4=\4\r\0035\4\14\0005\5\15\0=\5\16\0045\5\17\0005\6\18\0=\6\19\0055\6\20\0=\6\21\5=\5\22\4=\4\f\0035\4\23\0=\4\24\3=\3\25\0025\3\26\0=\3\27\0025\3\28\0004\4\0\0=\4\29\3=\3\30\0024\3\0\0=\3\31\0025\3 \0004\4\0\0=\4!\3=\3\"\0025\3#\0005\4$\0=\4\f\3=\3%\0025\3&\0004\4\0\0=\4'\0034\4\0\0=\4(\3=\3)\0025\3*\0=\3+\0025\3,\0=\3\21\0025\3-\0005\4.\0=\4/\0035\0040\0=\0041\0035\0042\0005\0053\0005\0065\0005\a4\0=\a6\0065\a7\0=\a8\6=\6(\5=\0059\4=\4:\0035\4;\0=\4<\3=\3=\0025\3>\0=\3?\0025\3@\0=\3A\0025\3B\0005\4C\0=\4D\3=\3E\2B\0\2\1K\0\1\0\blog\ntypes\1\0\a\16diagnostics\1\15copy_paste\1\bgit\1\vconfig\1\fprofile\1\fwatcher\1\ball\1\1\0\2\rtruncate\1\venable\1\16live_filter\1\0\2\vprefix\15[FILTER]: \24always_show_folders\2\ntrash\1\0\2\bcmd\14gio trash\20require_confirm\2\factions\16remove_file\1\0\1\17close_window\2\14open_file\18window_picker\fbuftype\1\4\0\0\vnofile\rterminal\thelp\rfiletype\1\0\0\1\a\0\0\vnotify\vpacker\aqf\tdiff\rfugitive\18fugitiveblame\1\0\2\nchars)ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890\venable\2\1\0\2\18resize_window\2\17quit_on_open\1\15expand_all\1\0\1\25max_folder_discovery\3�\2\15change_dir\1\0\3\23restrict_above_cwd\1\venable\2\vglobal\1\1\0\1\25use_system_clipboard\2\1\0\3\venable\2\ftimeout\3�\3\vignore\1\24filesystem_watchers\1\0\1\venable\1\ffilters\fexclude\vcustom\1\0\1\rdotfiles\1\16diagnostics\1\0\4\fwarning\b\tinfo\b\thint\b\nerror\b\1\0\2\17show_on_dirs\1\venable\1\16system_open\targs\1\0\1\bcmd\5\23ignore_ft_on_setup\24update_focused_file\16ignore_list\1\0\2\15update_cwd\1\venable\1\23hijack_directories\1\0\2\venable\2\14auto_open\2\rrenderer\18special_files\1\5\0\0\15Cargo.toml\rMakefile\14README.md\14readme.md\vglyphs\bgit\1\0\a\vstaged\b✓\fdeleted\b\runmerged\b\frenamed\b➜\runstaged\b✗\14untracked\b★\fignored\b◌\vfolder\1\0\b\17arrow_closed\b\topen\b\nempty\b\fsymlink\b\fdefault\b\15arrow_open\b\17symlink_open\b\15empty_open\b\1\0\2\fsymlink\b\fdefault\b\tshow\1\0\4\bgit\2\tfile\2\vfolder\2\17folder_arrow\2\1\0\4\18git_placement\vbefore\18symlink_arrow\n ➛ \18webdev_colors\2\fpadding\6 \19indent_markers\nicons\1\0\4\vcorner\t└ \titem\t│ \tnone\a  \tedge\t│ \1\0\1\venable\1\1\0\6\17add_trailing\1\16group_empty\1\18highlight_git\1\14full_name\1\27highlight_opened_files\tnone\25root_folder_modifier\a:~\tview\rmappings\tlist\1\0\1\16custom_only\1\1\0\t\15signcolumn\byes\nwidth\3\30\18adaptive_size\1\25centralize_selection\1\21hide_root_folder\1\vnumber\1\tside\tleft preserve_window_proportions\1\19relativenumber\1\1\0\14\18hijack_cursor\1\20respect_buf_cwd\1\23reload_on_bufenter\1\18open_on_setup\1\23open_on_setup_file\1\fsort_by\tname\16open_on_tab\1\25auto_reload_on_write\2\28create_in_closed_folder\1\18disable_netrw\1\15update_cwd\1\17hijack_netrw\2'hijack_unnamed_buffer_when_opening\1\27ignore_buffer_on_setup\1\nsetup\14nvim-tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n�\2\0\0\5\0\n\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\0\0=\3\6\0025\3\a\0004\4\0\0=\4\b\3=\3\t\2B\0\2\1K\0\1\0\14highlight\fdisable\1\0\2&additional_vim_regex_highlighting\1\venable\2\19ignore_install\21ensure_installed\1\0\1\17sync_install\1\1\14\0\0\velixir\15typescript\thttp\tjson\15javascript\truby\fclojure\fc_sharp\ago\vkotlin\nscala\tbash\bsql\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: toggleterm.nvim
time([[Config for toggleterm.nvim]], true)
try_loadstring("\27LJ\2\ny\0\1\2\0\6\1\0159\1\0\0\a\1\1\0X\1\3�)\1\15\0L\1\2\0X\1\b�9\1\0\0\a\1\2\0X\1\5�6\1\3\0009\1\4\0019\1\5\1\24\1\0\1L\1\2\0K\0\1\0\fcolumns\6o\bvim\rvertical\15horizontal\14direction��̙\19����\3�\1\1\0\4\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0003\3\3\0=\3\5\2B\0\2\0016\0\6\0'\2\a\0'\3\b\0B\0\3\1K\0\1\0\25<C-\\><C-n><C-w><C-w>\15<C-w><C-w>\ttmap\tsize\1\0\6\17open_mapping\n<A-m>\14direction\15horizontal\16auto_scroll\2\18close_on_exit\2\20start_in_insert\2\17hide_numbers\2\0\nsetup\15toggleterm\frequire\0", "config", "toggleterm.nvim")
time([[Config for toggleterm.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n�\1\0\0\b\0\b\2!6\0\0\0006\2\1\0009\2\2\0029\2\3\2)\4\0\0B\2\2\0A\0\0\3\b\1\0\0X\2\20�6\2\1\0009\2\2\0029\2\4\2)\4\0\0\23\5\1\0\18\6\0\0+\a\2\0B\2\5\2:\2\1\2\18\4\2\0009\2\5\2\18\5\1\0\18\6\1\0B\2\4\2\18\4\2\0009\2\6\2'\5\a\0B\2\3\2\n\2\0\0X\2\2�+\2\1\0X\3\1�+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\vunpack\0\2:\0\1\4\0\4\0\0066\1\0\0009\1\1\0019\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\19UltiSnips#Anon\afn\bvim�\1\0\1\3\2\6\0\21-\1\0\0009\1\0\1B\1\1\2\14\0\1\0X\1\15�6\1\1\0009\1\2\0019\1\3\1\6\1\4\0X\1\b�-\1\1\0B\1\1\2\15\0\1\0X\2\4�-\1\0\0009\1\5\1B\1\1\1X\1\2�\18\1\0\0B\1\1\1K\0\1\0\1�\2�\rcomplete\vprompt\fbuftype\abo\bvim\21select_next_item�\1\0\1\3\2\6\0\21-\1\0\0009\1\0\1B\1\1\2\14\0\1\0X\1\15�6\1\1\0009\1\2\0019\1\3\1\6\1\4\0X\1\b�-\1\1\0B\1\1\2\15\0\1\0X\2\4�-\1\0\0009\1\5\1B\1\1\1X\1\2�\18\1\0\0B\1\1\1K\0\1\0\1�\2�\rcomplete\vprompt\fbuftype\abo\bvim\21select_prev_item�\1\0\2\a\1\b\0\0156\2\1\0009\2\2\2'\4\3\0-\5\0\0009\6\0\0018\5\6\0059\6\0\1B\2\4\2=\2\0\0015\2\5\0009\3\6\0009\3\a\0038\2\3\2=\2\4\1L\1\2\0\0�\tname\vsource\1\0\3\vbuffer\r[Buffer]\fluasnip\14[LuaSnip]\rnvim_lsp\n[LSP]\tmenu\n%s %s\vformat\vstring\tkind�\14\1\0\f\0W\0�\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\0026\3\n\0009\3\v\3'\5\f\0006\6\r\0009\6\14\6'\b\15\0B\6\2\0A\3\1\2=\3\16\2B\0\2\0015\0\17\0006\1\0\0'\3\18\0B\1\2\0023\2\19\0009\3\2\0015\5\23\0005\6\21\0003\a\20\0=\a\22\6=\6\24\0055\6\26\0005\a\25\0=\a\27\6=\6\28\0055\6 \0009\a\29\0019\a\30\a9\a\31\aB\a\1\2=\a!\0069\a\29\0019\a\30\a9\a\31\aB\a\1\2=\a\"\6=\6\30\0059\6#\0019\6$\0069\6%\0065\b'\0009\t#\0019\t&\t)\v��B\t\2\2=\t(\b9\t#\0019\t&\t)\v\4\0B\t\2\2=\t)\b9\t#\0019\t*\tB\t\1\2=\t+\b9\t#\0019\t,\tB\t\1\2=\t-\b9\t#\0019\t.\t5\v/\0B\t\2\2=\t0\b3\t1\0=\t2\b3\t3\0=\t4\bB\6\2\2=\6#\0059\6\29\0019\0065\0064\b\3\0005\t6\0>\t\1\b5\t7\0>\t\2\b4\t\3\0005\n8\0>\n\1\tB\6\3\2=\0065\0055\6:\0003\a9\0=\a\v\6=\6;\5B\3\2\0016\3\0\0'\5<\0B\3\2\0029\3=\0036\5>\0009\5?\0059\5@\0059\5A\5B\5\1\0A\3\0\0026\4\0\0'\6B\0B\4\2\0029\4C\0049\4\2\0045\6D\0=\3E\6B\4\2\0016\4\0\0'\6B\0B\4\2\0029\4F\0049\4\2\0045\6G\0=\3E\6B\4\2\0016\4\0\0'\6B\0B\4\2\0029\4H\0049\4\2\0045\6I\0=\3E\6B\4\2\0016\4\0\0'\6B\0B\4\2\0029\4J\0049\4\2\0045\6K\0=\3E\6B\4\2\0016\4\0\0'\6B\0B\4\2\0029\4L\0049\4\2\0045\6M\0=\3E\6B\4\2\0016\4N\0'\6O\0'\aP\0B\4\3\0016\4N\0'\6Q\0'\aR\0B\4\3\0016\4N\0'\6S\0'\aT\0B\4\3\0016\4N\0'\6U\0'\aV\0B\4\3\0012\0\0�K\0\1\0):lua vim.diagnostic.open_float()<CR>\15<Leader>ld&:lua vim.lsp.buf.definition()<CR>\15<Leader>lf\":lua vim.lsp.buf.rename()<CR>\15<Leader>lr!:lua vim.lsp.buf.hover()<CR>\15<Leader>lh\tnmap\1\0\0\ngopls\1\0\0\15solargraph\1\0\0\ncssls\1\0\0\rtsserver\17capabilities\1\0\0\relixirls\14lspconfig\29make_client_capabilities\rprotocol\blsp\bvim\25default_capabilities\17cmp_nvim_lsp\15formatting\1\0\0\0\1\0\1\tname\vbuffer\1\0\1\tname\14ultisnips\1\0\1\tname\rnvim_lsp\fsources\f<S-Tab>\0\n<Tab>\0\t<CR>\1\0\1\vselect\2\fconfirm\n<C-e>\nabort\14<C-Space>\rcomplete\n<C-f>\n<C-b>\1\0\0\16scroll_docs\vinsert\vpreset\fmapping\18documentation\15completion\1\0\0\rbordered\vwindow\vconfig\tview\fentries\1\0\0\1\0\1\tname\vcustom\fsnippet\1\0\0\vexpand\1\0\0\0\0\bcmp\1\0\25\nEvent\b\vMethod\b\nClass\bﴯ\nColor\b\rOperator\b\fSnippet\b\14Interface\b\fKeyword\b\18TypeParameter\b\tEnum\b\tFile\b\rFunction\b\14Reference\b\nValue\b\vFolder\b\16Constructor\b\15EnumMember\b\rConstant\b\vModule\b\nField\b\rProperty\bﰠ\vStruct\b\tUnit\b\rVariable\b\tText\b\21install_root_dir\tHOME\vgetenv\aos\18%s/.local/bin\vformat\vstring\aui\nicons\1\0\0\1\0\3\23server_uninstalled\b✗\21server_installed\b✓\19server_pending\b➜\21ensure_installed\1\0\1\27automatic_installation\2\1\6\0\0\relixirls\rtsserver\16sumneko_lua\ncssls\ngopls\nsetup\23nvim-lsp-installer\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\n�\a\0\0\6\0*\00016\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\a\0005\4\4\0005\5\5\0=\5\6\4=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\0035\4\r\0005\5\14\0=\5\6\4=\4\15\0035\4\16\0005\5\17\0=\5\6\4=\4\18\0035\4\19\0005\5\20\0=\5\6\4=\4\21\3=\3\22\0025\3\23\0004\4\0\0=\4\24\3=\3\25\0025\3\27\0005\4\26\0=\4\28\0035\4\29\0=\4\30\0035\4\31\0=\4 \0035\4!\0=\4\"\0035\4#\0=\4$\3=\3%\0025\3&\0005\4'\0=\4(\3=\3)\2B\0\2\1K\0\1\0\vsearch\targs\1\6\0\0\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\1\0\2\fpattern\18\\b(KEYWORDS):\fcommand\arg\vcolors\fdefault\1\3\0\0\15Identifier\f#7C3AED\thint\1\3\0\0\19DiagnosticHint\f#10B981\tinfo\1\3\0\0\19DiagnosticInfo\f#2563EB\fwarning\1\4\0\0\22DiagnosticWarning\15WarningMsg\f#FBBF24\nerror\1\0\0\1\4\0\0\20DiagnosticError\rErrorMsg\f#DC2626\14highlight\fexclude\1\0\6\nafter\afg\17max_line_len\3�\3\vbefore\5\fpattern\22.*<(KEYWORDS)\\s*:\fkeyword\twide\18comments_only\2\rkeywords\tNOTE\1\2\0\0\tINFO\1\0\2\ncolor\thint\ticon\t \tPERF\1\4\0\0\nOPTIM\16PERFORMANCE\rOPTIMIZE\1\0\1\ticon\t \tWARN\1\3\0\0\fWARNING\bXXX\1\0\2\ncolor\fwarning\ticon\t \tHACK\1\0\2\ncolor\fwarning\ticon\t \tTODO\1\0\2\ncolor\tinfo\ticon\t \bFIX\1\0\0\balt\1\5\0\0\nFIXME\bBUG\nFIXIT\nISSUE\1\0\2\ncolor\nerror\ticon\t \1\0\2\nsigns\2\19merge_keywords\2\nsetup\18todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\n�\3\0\0\4\0\14\0\0246\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\0014\0\0\0005\1\a\0005\2\b\0>\2\2\1=\1\6\0005\1\n\0005\2\v\0>\2\2\1=\1\t\0006\1\0\0'\3\f\0B\1\2\0029\1\r\1\18\3\0\0B\1\2\1K\0\1\0\17set_mappings\21neoscroll.config\1\4\0\0\18vim.wo.scroll\ttrue\b250\1\2\0\0\vscroll\6}\1\4\0\0\19-vim.wo.scroll\ttrue\b250\1\2\0\0\vscroll\6{\rmappings\1\0\6\16hide_cursor\1\rstop_eof\2\24use_local_scrolloff\1\22respect_scrolloff\1\25cursor_scrolls_alone\2\21performance_mode\1\1\f\0\0\n<C-u>\n<C-d>\n<C-b>\n<C-f>\n<C-y>\n<C-e>\azt\azz\azb\6{\6}\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n�\b\0\0\a\0%\0@6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2!\0005\3\4\0005\4\3\0=\4\5\0035\4\a\0005\5\6\0=\5\b\0045\5\t\0=\5\n\4=\4\v\0036\4\0\0'\6\f\0B\4\2\0029\4\r\4=\4\14\0035\4\15\0=\4\16\0036\4\0\0'\6\f\0B\4\2\0029\4\17\4=\4\18\0035\4\19\0=\4\20\0034\4\0\0=\4\21\0035\4\22\0=\4\23\0036\4\0\0'\6\24\0B\4\2\0029\4\25\0049\4\26\4=\4\27\0036\4\0\0'\6\24\0B\4\2\0029\4\28\0049\4\26\4=\4\29\0036\4\0\0'\6\24\0B\4\2\0029\4\30\0049\4\26\4=\4\31\0036\4\0\0'\6\24\0B\4\2\0029\4 \4=\4 \3=\3\"\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0#\0'\2$\0B\0\2\1K\0\1\0\bfzf\19load_extension\rdefaults\1\0\0\27buffer_previewer_maker\21qflist_previewer\22vim_buffer_qflist\19grep_previewer\23vim_buffer_vimgrep\19file_previewer\bnew\19vim_buffer_cat\25telescope.previewers\fset_env\1\0\1\14COLORTERM\14truecolor\vborder\17path_display\1\2\0\0\rtruncate\19generic_sorter\29get_generic_fuzzy_sorter\25file_ignore_patterns\1\2\0\0\17node_modules\16file_sorter\19get_fuzzy_file\22telescope.sorters\18layout_config\rvertical\1\0\1\vmirror\1\15horizontal\1\0\3\19preview_cutoff\3x\nwidth\4����\3����\3\vheight\4͙��\f̙��\3\1\0\3\20prompt_position\btop\18preview_width\4����\t����\3\18results_width\4����\t����\3\22vimgrep_arguments\1\0\n\19color_devicons\2\ruse_less\2\18prompt_prefix\n  \17entry_prefix\a  \17initial_mode\vinsert\23selection_strategy\nreset\21sorting_strategy\14ascending\20layout_strategy\15horizontal\20selection_caret\a  \rwinblend\3\0\1\b\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\nsetup\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: dashboard-nvim
time([[Config for dashboard-nvim]], true)
try_loadstring("\27LJ\2\n�Q\0\0\5\0 \0<6\0\0\0'\2\1\0B\0\2\0025\1\3\0=\1\2\0004\1\0\0=\1\4\0004\1\0\0=\1\5\0)\1\1\0=\1\6\0)\1\1\0=\1\a\0004\1\a\0005\2\b\0>\2\1\0015\2\t\0>\2\2\0015\2\n\0>\2\3\0015\2\v\0>\2\4\0015\2\f\0>\2\5\0015\2\r\0>\2\6\1=\1\4\0006\1\14\0'\3\15\0'\4\16\0B\1\3\0016\1\14\0'\3\17\0'\4\18\0B\1\3\0016\1\14\0'\3\19\0'\4\20\0B\1\3\0016\1\14\0'\3\21\0'\4\22\0B\1\3\0016\1\14\0'\3\23\0'\4\24\0B\1\3\0016\1\14\0'\3\25\0'\4\26\0B\1\3\0016\1\14\0'\3\27\0'\4\28\0B\1\3\0016\1\29\0009\1\30\1'\3\31\0B\1\2\1K\0\1\0�\1\t\taugroup DashboardTweaks\n\t\tautocmd!\n\t\tautocmd FileType dashboard set noruler\n\t\tautocmd FileType dashboard nmap <buffer> q :quit<CR>\n\t\taugroup END\n\t\t\bcmd\bvim :NvimTreeFindFileToggle<CR>\15<Leader>fn\26:DashboardNewFile<CR>\15<Leader>cn\30:Telescope find_files<CR>\15<Leader>ff\29:Telescope live_grep<CR>\15<Leader>fw\28:Telescope oldfiles<CR>\15<Leader>fo\19:Obsession<CR>\15<Leader>ss\28:source Session.vim<CR>\15<Leader>sl\tnmap\1\0\3\vaction\tquit\tdesc&Quit Neovim                     q\ticon\nﴘ  \1\0\3\vaction\16SessionLoad\tdesc&Load Last Session         SPC s l\ticon\t勒 \1\0\3\vaction\24Telescope live_grep\tdesc&Find Word                 SPC f a\ticon\n  \1\0\3\vaction\23Telescope oldfiles\tdesc&Recents                   SPC f h\ticon\nﲊ  \1\0\3\vaction\25Telescope find_files\tdesc&Find File                 SPC f f\ticon\n  \1\0\3\vaction\21DashboardNewFile\tdesc&New File                  SPC c n\ticon\n  \17hide_tabline\20hide_statusline\18custom_footer\18custom_center\1\31\0\0�\2┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐�\2│ ⠀⠀⠀⠀⣀⠀⠠⠄⠠⠀⠀⠀⠄⠄⠠⠀⠆⠀⠢⠀⠀⠁⡀⠈⠁⠀⠁⠀⡀⠀⠘⠄⠀⠄⠈⠀⠀⠁⠀⠀⠂⠀⠀⠀⠀⠈⠈⠅⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠂⠄⠀⠈⠀⠀⠈⠤⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠄⠂⠀│�\2│ ⡀⡀⠀⠀⠀⠀⡀⠀⢌⠀⠀⠂⠀⠀⠀⠀⠀⠀⠁⠀⢀⠀⠀⠠⠀⠀⠠⠀⠀⠀⡀⠀⠀⠀⠀⠀⠨⠀⣈⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠠⠀⠀⠀⠈⠀⠀⠀⠀⠄⠀⠂⠀⠀⠀⠀⠀⠀⠄⠀⠀⢱⣿⡦⠀⢀⠄⠀⠀⠄⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀│�\2│ ⠁⠀⢀⡈⠀⠂⠀⠀⠀⠀⠀⠀⠀⡂⠀⠐⠀⠈⠈⠀⠀⠀⠀⠀⠀⠂⠀⠀⠂⢄⠄⠠⠀⠂⠀⠂⢄⠀⠈⠉⠒⠀⠀⠀⠀⡈⠀⠁⠢⠒⠀⠀⠀⠀⠀⠀⠠⠀⠂⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⡀⠀⠀⠀⠀⠀⠀⠀⢈⠉⠁⠀⠀⠀⠀⡀⠀⠀⠀⠐⠀⠀⠀⠀⠀⠠⠀⠀⠀⠁│�\2│ ⠀⠀⡈⠀⠀⠀⠀⠀⠈⠀⠀⠂⠀⠈⠀⠂⠀⠀⠐⠈⡀⠀⠀⠀⠀⠀⠨⠀⠀⡀⠀⠀⠀⣠⣤⣅⠁⠀⠀⠄⠀⠃⠀⠂⠐⠀⠄⠐⠀⠀⠀⡀⠐⠀⠠⠀⠀⢀⡤⠤⣤⡠⠂⠀⠀⠀⠀⠀⠀⠒⠀⠀⠀⠀⠀⠀⠈⠠⠂⠀⠀⠀⠠⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⡄⡊⠀⢀⠀⠀⠁⠀⠀⣈⢠⡄⠀⣀⠀⢀⠀⠀⠻⣿⠿⠁⠄⡀⠀⠠⠀⠁⠠⠀⠀⠐⠐⡄⠀⠀⠀⠀⠀⠀⠃⠈⣟⠻⡝⢟⣿⠔⠀⠠⠀⠁⠀⠀⢀⣀⣤⣤⣤⣀⡀⠀⠀⠀⠐⠀⠀⠀⠂⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀│�\2│ ⠀⠀⠀⠀⠁⠄⠀⡀⠀⢂⠀⠀⠀⠁⠄⠈⠀⣀⠐⠀⠀⠀⠀⠐⠂⠄⠀⣀⣀⣀⣀⡀⠁⠐⠀⠨⢀⠢⠉⠀⠀⠁⡀⠃⢉⠐⢀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠙⢧⣻⡱⠞⠀⠀⠀⠀⠀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠠⠄⠀⠀⠀⠀⠀⠀⠈│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠂⠀⠠⣀⠀⠀⠁⡀⠐⠊⠀⠀⢄⣴⣿⣿⣿⣿⣿⣿⣷⣔⠀⠀⠀⠀⠄⠀⢊⠀⡄⠁⠀⠂⠀⠠⠈⠀⠄⠀⠀⠀⠀⠔⠀⠂⠀⠀⠀⠈⠈⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡶⠞⢛⣻⣻⣿⡿⠇⢀⠐⠀⠀⠀⠀⠀⠀⠀⠂⠠⠀⠀│�\2│ ⠀⠀⠁⠀⠀⠀⠄⠀⡀⠀⠀⠀⠀⠐⠀⢀⡀⠀⠐⢀⠀⠄⠀⢁⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠠⠁⠘⠀⠀⠀⠀⠈⠀⠀⣂⠀⠀⡀⠁⠀⠀⠀⡀⠠⠅⠀⠠⠀⠁⠀⠀⠀⠀⢀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠿⠟⠟⠉⠁⠈⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠈⠆⠀⠠⠀⠀⠐⠀⠀⠀⠀⡠⠀⠀⠀⠀⠀⠁⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠃⠀⠁⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠁⠀⠀⢀⣠⣤⡶⠟⢛⣹⣿⣿⣿⣿⣻⣿⣯⣿⣷⣿⣿⣿⣿⡇⠀⠀⠀⢈⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀│�\2│ ⠐⠀⠀⠀⠀⠀⠀⢀⡀⠀⠁⠀⠁⠀⠀⢠⣄⠐⠀⠄⠈⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠁⠀⠀⠠⠠⠀⠄⠀⢐⠠⠀⠁⠀⠀⠀⠀⠔⢀⠀⠀⠀⠰⠽⠿⠿⠿⠿⠛⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠫⠀⠀⠀⠀⠀⠀⢈⡞⢑⣛⣯⣿⣿⠿⠿⠋⡁⠀⠀⠐⠀⠀⠀⠀⠠⠀⠠⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⡿⠟⠉⠀⠀⠀⠠⠰⠐⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠄⠐⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠘⣿⣟⣿⣟⢿⠇⠄⠀⠂⡀⠀⠀⠀⠀⠀⠀⠅⠈⠂⢀⠤⠒⠉⠁⠀⠀⠉⠓⣄⠀⢈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⡀⠀⠀⠀⠀⠀⠈⢉⢉⢀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⢠⠀⠀⠀⠀⠂⠠⠀⠀⠀⠀⠈⠙⠛⠋⠅⠄⠀⠀⠀⠃⠀⠠⠀⠀⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⣤⡀⠈⣦⡀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⡀⠀⠀⠐⠀⡀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠂⠀⠈⠀⠀⠄⠁⠀⠐⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⠀⠀⠀⠀⠀⠀⠀⠙⠗⠀⠈⠱⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠁⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⡀⠀⠈⠀⡀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠱⡀⠀⠀⠀⠀⠀⡔⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠈⠀⠀⠂⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡃⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⠁⠀⠀⠀⠀⠀⠈⠢⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠔⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠤⠤⠀⠀⠀⣀⣀⣀⣀⣀⣀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡃⠀⣀⣀⣒⣒⣂⣀⡀⠀⠀⠀⠀⠤⠤⠤⠤⠤⠤⠄⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀│�\2│ ⠤⢀⣀⣉⣉⣁⣒⠒⠒⠶⠶⣤⠤⡤⠤⠭⣉⣉⣉⣛⣛⣛⡒⣒⣒⣂⣀⣀⣠⣀⣀⠀⠠⠀⠀⠤⠤⠤⠤⠔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⠀⠀⠀⠠⠤⠤⠄⠀⠀⢀⣀⣀⣐⣀⣘⣉⣉⣉⣉⡉⠉⠉⠭⠤⠤⠤⠤⠤⠶⠀⠀⢀⣀⣀⣈⣉⣉⣉⡉⠉│�\2│ ⣧⣶⣶⣿⣿⠿⠷⠾⠿⠟⠛⠛⠛⢳⣚⣛⣛⣭⠭⠭⠅⠉⢩⣛⣿⣳⣒⣳⣶⣂⣀⣀⠀⠈⠉⠭⠭⠭⠯⠍⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠄⠠⠤⠥⠨⠉⠉⣄⣀⣄⣰⡚⠒⠒⣂⣈⣸⡿⠿⠿⠿⠿⠉⠈⣙⣻⣿⣿⡿⡷⠄⢶⣿⣷⣷⣶⡖⣀⣐⣂│�\2│ ⠦⠤⠽⡗⠓⠒⣺⣯⣭⠿⠿⠶⠒⢒⣒⣛⣛⠉⠭⠭⠭⣭⣥⣄⣄⣶⣶⣶⣶⣶⣶⡶⢦⠦⣤⣤⠿⠿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠿⠿⣿⣖⣶⣴⣶⣶⣶⣶⣖⣀⣭⣭⣭⣍⣀⣒⣒⣒⣛⡻⠛⠿⠥⠴⠶⢶⣾⣛⣩⣭⣭⠵⠶⢒⠒⡛⠁│�\2│ ⠤⢒⣒⠉⣉⠁⣠⡄⣀⣉⣹⡭⠷⠶⠖⠛⣿⡓⠢⡼⠿⡉⠛⠓⠲⠖⠄⠶⠒⠛⣛⠛⠋⢉⣉⣉⣛⠿⠯⡇⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⢸⣿⠿⠾⣛⣋⣿⠷⠒⣖⡚⢛⣊⠭⣿⣛⣙⡟⠛⠛⣿⣿⠟⢒⣶⣿⢻⣭⠴⣶⣒⢦⣤⢩⣉⡉⠐⠚⠓⠠⠤│�\2│ ⠭⠃⠉⢲⠝⠩⢙⠉⠉⠀⠀⠡⠒⢈⠉⡠⢀⠜⡓⠉⠛⠀⡤⠲⠝⠉⠀⢠⠊⢉⠒⠂⣬⠓⠒⢲⡌⢻⣻⣧⣀⣀⡠⠧⠄⢀⣀⣀⣀⣀⣀⣀⠠⠤⢤⣶⡶⠯⠹⠿⣹⣭⣒⡯⢆⡒⢫⡍⠀⡈⠑⠌⠙⠛⢶⣟⠹⡫⣅⠒⠠⡉⠉⠉⠒⠚⠥⡚⠉⠐⠈⠩⡑⠫⡚⠩⡁⠒⠒⠤│�\2│ ⠄⡀⠀⠁⠀⡢⣠⢄⡀⠀⠘⠤⣀⠑⢌⣢⢀⡒⠤⢄⣀⣄⠑⠪⠤⠀⠀⠈⠒⠤⢉⣒⠒⠫⠭⠭⠁⠿⢚⡒⠈⢉⡉⠾⠟⠋⠉⠭⠭⢉⣙⣛⠛⠟⠦⠬⠟⢈⣓⣒⣒⣒⣒⠤⠤⢭⡓⠒⢉⠬⢕⣁⣬⡠⠴⡋⣤⠣⢟⣀⠴⠃⠀⠀⢀⣀⡴⠆⠔⢃⠀⠤⣃⠤⡀⠥⠊⠀⠀⠀│�\2└─────────────────────────────────────────────────────────────────────────────────────────────────────┘\18custom_header\14dashboard\frequire\0", "config", "dashboard-nvim")
time([[Config for dashboard-nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n�\5\0\0\a\0%\0?6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0004\5\0\0=\5\a\0044\5\0\0=\5\b\4=\4\t\3=\3\v\0025\3\17\0004\4\3\0005\5\f\0005\6\r\0=\6\14\0055\6\15\0=\6\16\5>\5\1\4=\4\18\0035\4\20\0005\5\19\0>\5\1\4=\4\21\0034\4\3\0005\5\22\0>\5\1\4=\4\23\0035\4\24\0=\4\25\0034\4\3\0005\5\26\0>\5\1\4=\4\27\0034\4\3\0005\5\28\0>\5\1\4=\4\29\3=\3\30\0025\3 \0005\4\31\0=\4\18\0034\4\0\0=\4\21\0034\4\0\0=\4\23\0034\4\0\0=\4\25\0034\4\0\0=\4\27\0035\4!\0=\4\29\3=\3\"\0024\3\0\0=\3#\0024\3\0\0=\3$\2B\0\2\1K\0\1\0\15extensions\ftabline\22inactive_sections\1\2\0\0\rlocation\1\0\0\1\2\0\0\rfilename\rsections\14lualine_z\1\2\1\0\rprogress\ticon\b\14lualine_y\1\2\1\0.vim.fn.fnamemodify(vim.fn.getcwd(), \":t\")\ticon\t \14lualine_x\1\2\0\0\16diagnostics\14lualine_c\1\2\1\0\vbranch\ticon\b\14lualine_b\1\3\0\0\0\rfilename\1\2\1\0\rfiletype\14icon_only\2\14lualine_a\1\0\0\ncolor\1\0\1\bgui\tbold\14separator\1\0\1\tleft\5\1\2\2\0\tmode\18right_padding\3\2\ticon\b\foptions\1\0\0\23disabled_filetypes\vwinbar\15statusline\1\0\0\23section_separators\1\0\2\nright\5\tleft\5\1\0\1\25component_separators\5\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: symbols-outline.nvim
time([[Config for symbols-outline.nvim]], true)
try_loadstring("\27LJ\2\n�\f\0\0\5\0B\0G6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\0024\3\0\0=\3\n\0024\3\0\0=\3\v\0025\3\r\0005\4\f\0=\4\14\0035\4\15\0=\4\16\0035\4\17\0=\4\18\0035\4\19\0=\4\20\0035\4\21\0=\4\22\0035\4\23\0=\4\24\0035\4\25\0=\4\26\0035\4\27\0=\4\28\0035\4\29\0=\4\30\0035\4\31\0=\4 \0035\4!\0=\4\"\0035\4#\0=\4$\0035\4%\0=\4&\0035\4'\0=\4(\0035\4)\0=\4*\0035\4+\0=\4,\0035\4-\0=\4.\0035\4/\0=\0040\0035\0041\0=\0042\0035\0043\0=\0044\0035\0045\0=\0046\0035\0047\0=\0048\0035\0049\0=\4:\0035\4;\0=\4<\0035\4=\0=\4>\0035\4?\0=\4@\3=\3A\2B\0\2\1K\0\1\0\fsymbols\18TypeParameter\1\0\2\ticon\t𝙏\ahl\16TSParameter\rOperator\1\0\2\ticon\6+\ahl\15TSOperator\nEvent\1\0\2\ticon\t🗲\ahl\vTSType\vStruct\1\0\2\ticon\t𝓢\ahl\vTSType\15EnumMember\1\0\2\ticon\b\ahl\fTSField\tNull\1\0\2\ticon\tNULL\ahl\vTSType\bKey\1\0\2\ticon\t🔐\ahl\vTSType\vObject\1\0\2\ticon\b⦿\ahl\vTSType\nArray\1\0\2\ticon\b\ahl\15TSConstant\fBoolean\1\0\2\ticon\b⊨\ahl\14TSBoolean\vNumber\1\0\2\ticon\6#\ahl\rTSNumber\vString\1\0\2\ticon\t𝓐\ahl\rTSString\rConstant\1\0\2\ticon\b\ahl\15TSConstant\rVariable\1\0\2\ticon\b\ahl\15TSConstant\rFunction\1\0\2\ticon\b\ahl\15TSFunction\14Interface\1\0\2\ticon\bﰮ\ahl\vTSType\tEnum\1\0\2\ticon\bℰ\ahl\vTSType\16Constructor\1\0\2\ticon\b\ahl\18TSConstructor\nField\1\0\2\ticon\b\ahl\fTSField\rProperty\1\0\2\ticon\b\ahl\rTSMethod\vMethod\1\0\2\ticon\aƒ\ahl\rTSMethod\nClass\1\0\2\ticon\t𝓒\ahl\vTSType\fPackage\1\0\2\ticon\b\ahl\16TSNamespace\14Namespace\1\0\2\ticon\b\ahl\16TSNamespace\vModule\1\0\2\ticon\b\ahl\16TSNamespace\tFile\1\0\0\1\0\2\ticon\b\ahl\nTSURI\21symbol_blacklist\18lsp_blacklist\fkeymaps\nclose\1\0\v\rfold_all\6W\19toggle_preview\6K\15unfold_all\6E\15fold_reset\6R\18goto_location\t<Cr>\19focus_location\6o\17hover_symbol\14<C-space>\18rename_symbol\6r\17code_actions\6a\tfold\6h\vunfold\6l\1\3\0\0\n<Esc>\6q\17fold_markers\1\3\0\0\b\b\1\0\r\22auto_unfold_hover\2\16show_guides\2\27highlight_hovered_item\2\17auto_preview\1\rposition\nright\nwidth\3\25\twrap\1\19relative_width\2\15auto_close\1\17show_numbers\1\26show_relative_numbers\1\24show_symbol_details\2\25preview_bg_highlight\nPmenu\nsetup\20symbols-outline\frequire\0", "config", "symbols-outline.nvim")
time([[Config for symbols-outline.nvim]], false)
-- Config for: lightspeed.nvim
time([[Config for lightspeed.nvim]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\15lightspeed\frequire\0", "config", "lightspeed.nvim")
time([[Config for lightspeed.nvim]], false)
-- Config for: kanagawa.nvim
time([[Config for kanagawa.nvim]], true)
try_loadstring("\27LJ\2\n�\f\0\0\3\0\4\0\t6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\1K\0\1\0\25colorscheme kanagawa�\v\t\taugroup Kanawaga\n\t\t\tautocmd!\n\t\t\tautocmd ColorScheme * hi Normal guibg=NONE\n\n\t\t  autocmd ColorScheme * hi TelescopePromptBorder guibg=#16161D guifg=#16161D\n\t\t  autocmd ColorScheme * hi TelescopePromptCounter guibg=#16161D guifg=#C8C093\n\t\t  autocmd ColorScheme * hi TelescopePromptNormal guibg=#16161D guifg=#C8C093\n\t\t  autocmd ColorScheme * hi TelescopePromptTitle guibg=#C34043 guifg=#16161D\n\n\t\t  autocmd ColorScheme * hi TelescopePreviewBorder guibg=#16161D guifg=#16161D\n\t\t  autocmd ColorScheme * hi TelescopePreviewNormal guibg=#16161D guifg=#C8C093\n\t\t  autocmd ColorScheme * hi TelescopePreviewTitle guibg=#957FB8 guifg=#16161D\n\n\t\t  autocmd ColorScheme * hi TelescopeResultsBorder guibg=#16161D guifg=#16161D\n\t\t  autocmd ColorScheme * hi TelescopeResultsNormal guibg=#16161D guifg=#C8C093\n\t\t  autocmd ColorScheme * hi TelescopeResultsTitle guibg=#6A9589 guifg=#16161D\n\n\t\t\tautocmd ColorScheme * hi VertSplit guibg=#16161D\n\t\t\tautocmd ColorScheme * hi NvimTreeNormal guibg=#16161D\n\t\t\tautocmd ColorScheme * hi NvimTreeNormalNC guibg=#16161D\n\t\t\tautocmd ColorScheme * hi NvimTreeEndOfBuffer guibg=#16161D guifg=#16161D\n\n\t\t\tautocmd ColorScheme * hi WinSeparator guibg=NONE guifg=#16161D\n\n\t\t\tautocmd ColorScheme * hi DashboardHeader guibg=NONE guifg=#54546D\n\t\t\tautocmd ColorScheme * hi DashboardCenter guibg=NONE guifg=#54546D\n\t\t\tautocmd ColorScheme * hi DashboardShortCut guibg=NONE guifg=#54546D\n\t\t\tautocmd ColorScheme * hi DashboardFooter guibg=NONE guifg=#54546D\n\t\taugroup end\n\t\t\bcmd\bvim\0", "config", "kanagawa.nvim")
time([[Config for kanagawa.nvim]], false)
-- Config for: nvim-web-devicons
time([[Config for nvim-web-devicons]], true)
try_loadstring("\27LJ\2\n�\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\roverride\1\0\0\arb\1\0\0\1\0\3\tname\truby\ncolor\f#a91401\ticon\b\nsetup\22nvim-web-devicons\frequire\0", "config", "nvim-web-devicons")
time([[Config for nvim-web-devicons]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: vim-test
time([[Config for vim-test]], true)
try_loadstring("\27LJ\2\n�\1\0\0\4\0\a\0\r6\0\0\0'\2\1\0'\3\2\0B\0\3\0016\0\0\0'\2\3\0'\3\4\0B\0\3\0016\0\0\0'\2\5\0'\3\6\0B\0\3\1K\0\1\0\19:TestSuite<CR>\14<Leader>T\18:TestFile<CR>\14<Leader>R\21:TestNearest<CR>\14<Leader>r\tnmap\0", "config", "vim-test")
time([[Config for vim-test]], false)
-- Config for: conjure
time([[Config for conjure]], true)
try_loadstring("\27LJ\2\n�\1\0\0\4\0\a\0\r6\0\0\0'\2\1\0'\3\2\0B\0\3\0016\0\0\0'\2\3\0'\3\4\0B\0\3\0016\0\0\0'\2\5\0'\3\6\0B\0\3\1K\0\1\0\24:ConjureEvalBuf<CR>\15<leader>cp :ConjureEvalCurrentForm<CR>\15<leader>ce\29:ConjureEvalRootForm<CR>\15<leader>cl\tnmap\0", "config", "conjure")
time([[Config for conjure]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
