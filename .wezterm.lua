local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Rosé Pine (Gogh)'
config.colors = { background = "#121212" }
config.font_size = 26
config.window_decorations = "RESIZE"
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium"})
config.enable_tab_bar = false
config.default_cursor_style = "SteadyBar"
config.use_fancy_tab_bar = false
config.harfbuzz_features = { 'calt = 0', 'clig = 0', 'liga = 0' }
config.window_padding = { left = 8, right = 8, top = 4, bottom = 4 }

return config
