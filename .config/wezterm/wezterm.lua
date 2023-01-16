local wezterm = require 'wezterm'

return {
  font = wezterm.font_with_fallback {
    -- for mac font
    'Monaco', 
    'FuraMono Nerd Font Mono',
  }, 

  font_size = 14, 

  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  },

  -- color_scheme = "Dracula (Gogh)",
  -- color_scheme = "Dracula (base16)",
  -- color_scheme = "Gruvbox Dark"
  -- color_scheme = "Sakura",
  color_scheme = "Solarized Dark Higher Contrast", 
  -- color_scheme = "VSCodeDark+ (Gogh)",

  colors = {
    cursor_bg = '#ffffff',
    cursor_fg = 'black',
    selection_fg = 'white',
    selection_bg = '#C2185B',
  }, 

  scrollback_lines = 1000000,
  enable_tab_bar = false, 
}

