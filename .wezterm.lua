local wezterm = require('wezterm')

return {
  font = wezterm.font("FiraCode Nerd Font Mono", {weight="Medium"}),
  font_size = 20.0,
  line_height = 1.1,
  window_background_opacity = 0.92,
  window_decorations = "RESIZE",
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  window_padding = {
    left = 5,
    right = 5,
    top = 5,
    bottom = 5,
  },
  harfbuzz_features = { "calt=0", "lig=0", "liga=0" },
}
