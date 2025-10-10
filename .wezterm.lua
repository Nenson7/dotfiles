local wezterm = require 'wezterm'

return {
  color_scheme = 'Rosé Pine (Gogh)',
  colors = {
    background = "#121212",
  },
  font_size = 20,
  font = wezterm.font("JetBrainsMono Nerd Font"),
  window_background_opacity = 0.95,
  enable_tab_bar = false,
  default_cursor_style = "SteadyBar",
  use_fancy_tab_bar = false,
  harfbuzz_features = { 'calt = 0', 'clig = 0', 'liga = 0' },
  front_end = "OpenGL",
  window_padding = {
    left = 8,
    right = 8,
    top = 4,
    bottom = 4
  },
  enable_wayland = true,
  enable_scroll_bar = false,
}
