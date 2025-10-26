local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 18
config.color_scheme = "Rosé Pine (Gogh)"
config.colors = { background = "#000000"}
config.font = wezterm.font("Fira Code")
config.enable_tab_bar = false
config.default_cursor_style = "SteadyBar"
config.use_fancy_tab_bar = false
config.harfbuzz_features = { 'calt = 0', 'clig = 0', 'liga = 0' }
config.window_background_opacity = 1.0

return config
