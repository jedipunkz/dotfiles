local wezterm = require 'wezterm'

return {
  use_ime = true,
  macos_forward_to_ime_modifier_mask = "SHIFT|CTRL",

  font = wezterm.font_with_fallback {
    -- for mac font
    'Consolas',
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

  window_decorations = "RESIZE",

  -- color_scheme = "Dracula (Gogh)",
  -- color_scheme = "Dracula (base16)",
  -- color_scheme = "Sakura",
  -- color_scheme = "Solarized Dark Higher Contrast",
  -- color_scheme = "terafox",
  -- color_scheme = "Gruvbox Dark (Gogh)",
  -- color_scheme = "GruvboxDark",
  -- color_scheme = "Gruvbox dark, hard (base16)",
  color_scheme = "GruvboxDarkHard",
  -- color_scheme = "Gruvbox Material (Gogh)",
  -- color_scheme = "VSCodeDark+ (Gogh)",

  colors = {
    cursor_bg = '#ffffff',
    cursor_fg = 'black',
    selection_fg = 'white',
    selection_bg = '#C2185B',
  },

  scrollback_lines = 1000000,
  enable_tab_bar = false,

  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action.PasteFrom("PrimarySelection"),
    },
    {
      event = { Down = { streak = 1, button = { WheelUp = 1 } } },
      mods = 'CTRL',
      action = wezterm.action.IncreaseFontSize,
    },

    {
      event = { Down = { streak = 1, button = { WheelDown = 1 } } },
      mods = 'CTRL',
      action = wezterm.action.DecreaseFontSize,
    },
  },

  disable_default_key_bindings = true
}

