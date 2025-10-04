local wezterm = require 'wezterm'

return {
    color_scheme = 'Gruvbox dark, hard (base16)',
    font_size = 20,
    font = wezterm.font("FiraCode", { weight = "Medium"}),
    enable_tab_bar = false,
    default_cursor_style = "SteadyBar",
    use_fancy_tab_bar = false,
    animation_fps = 60,
    max_fps = 60,
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

