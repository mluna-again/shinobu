local kanagawa = require("kanagawa")
local w = require("wezterm")
-- local mux = w.mux

-- w.on("gui-startup", function(cmd)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

local config = {}

config.font = w.font("FiraCode Nerd Font")
config.font_size = 12

config.colors = kanagawa

config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
  left = 0,
  right = 0,
  bottom = 0,
  top = 0
}

-- config.window_background_image = string.format("%s/.local/walls/valhalla.gif", os.getenv("HOME"))
config.window_background_image_hsb = {
  brightness = 0.01
}

config.keys = {
  {
    key = "f",
    mods = "CMD",
    action = w.action.ToggleFullScreen
  },
  {
    key = "f",
    mods = "CTRL",
    action = w.action.ToggleFullScreen
  }
}

config.check_for_updates = false

config.native_macos_fullscreen_mode = true

return config
