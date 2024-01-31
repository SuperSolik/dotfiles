-- Pull in the wezterm API
local wezterm = require('wezterm')
local colors = require('lua/rose-pine-moon').colors()

local mux = wezterm.mux
-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- config.color_scheme = 'Gruvbox Dark (Gogh)'
config.colors = colors
config.window_background_opacity = 0.945

config.font_size = 16

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

config.keys = {
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
}

-- disable checking for updates
config.check_for_updates = false
config.show_update_window = false

-- and finally, return the configuration to wezterm
return config
