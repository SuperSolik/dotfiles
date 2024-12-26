-- Pull in the wezterm API
local wezterm = require("wezterm")

local mux = wezterm.mux
-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.color_scheme = "Zenwritten_dark"
-- local colors = require('lua/rose-pine').colors()
-- config.colors = colors
-- config.window_background_opacity = 1.0

config.font = wezterm.font("JetBrains Mono", { italic = false })
config.font_size = 15

wezterm.on("gui-startup", function(cmd)
    local _, _, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

config.keys = {
    {
        key = "w",
        mods = "CMD",
        action = wezterm.action.CloseCurrentTab({ confirm = false }),
    },
}

-- disable checking for updates
config.check_for_updates = true
config.show_update_window = true

-- font
-- config.font = wezterm.font 'IBM Plex Mono'

-- window decorations
config.window_decorations = "TITLE | RESIZE"

-- and finally, return the configuration to wezterm
return config
