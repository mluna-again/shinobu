local kanagawa = require("kanagawa")
local w = require("wezterm")
local act = w.action
local mux = w.mux
local helpers = require("helpers")

w.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local config = {}

config.font = w.font("FiraCode Nerd Font")
config.font_size = 12

config.colors = kanagawa

config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
	left = 0,
	right = 0,
	bottom = 0,
	top = 0,
}

config.window_background_image = string.format("%s/.local/walls/valhalla.gif", os.getenv("HOME"))
config.window_background_image_hsb = {
	brightness = helpers.get_background_brightness(),
}

config.keys = {
	{
		key = "f",
		mods = "CMD",
		action = w.action.ToggleFullScreen,
	},
	{
		key = "f",
		mods = "CTRL",
		action = w.action.ToggleFullScreen,
	},
	{
		key = "+",
		mods = "CMD",
		action = w.action.IncreaseFontSize,
	},
	{
		key = "+",
		mods = "CTRL",
		action = w.action.IncreaseFontSize,
	},
	{
		key = "-",
		mods = "CMD",
		action = w.action.DecreaseFontSize,
	},
	{
		key = "-",
		mods = "CTRL",
		action = w.action.DecreaseFontSize,
	},
	{
		key = "n",
		mods = "CMD",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "n",
		mods = "CTRL|SHIFT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
}

for i = 1, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL",
		action = act.ActivateTab(i - 1),
	})

	table.insert(config.keys, {
		key = tostring(i),
		mods = "META",
		action = act.ActivateTab(i - 1),
	})
end

config.check_for_updates = false

config.native_macos_fullscreen_mode = true

config.audible_bell = "Disabled"

return config
