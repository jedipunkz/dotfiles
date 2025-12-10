local wezterm = require 'wezterm'

local font_size = 14 -- デフォルトのフォントサイズ

if wezterm.target_triple:find("linux") then
  font_size = 12 -- Linux用のフォントサイズ
  window_background_opacity = 0.8 -- 透明化
elseif wezterm.target_triple:find("darwin") then
  font_size = 15 -- macOS用のフォントサイズ
  window_background_opacity = 1.0 -- 透明化せず
end

return {
  use_ime = true,
  macos_forward_to_ime_modifier_mask = "SHIFT|CTRL",

  font = wezterm.font_with_fallback {
    -- 'JetBrains Mono',
    'Consolas',
    'Hiragino Sans',
    'Monaco',
    'FuraMono Nerd Font Mono',
  },

  font_size = font_size,

  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  },

  window_decorations = "RESIZE",

  -- color_scheme = "Dracula (Gogh)",
  -- color_scheme = "Dracula (base16)",
  -- color_scheme = "Dracula (Official)",
  -- color_scheme = "Catppuccin Macchiato",
  color_scheme = "Tokyo Night",
  -- color_scheme = "Sakura",
  -- color_scheme = "Solarized Dark Higher Contrast",
  -- color_scheme = "terafox",
  -- color_scheme = "Gruvbox Dark (Gogh)",
  -- color_scheme = "GruvboxDark",
  -- color_scheme = "Gruvbox dark, hard (base16)",
  -- color_scheme = "GruvboxDarkHard",
  -- color_scheme = "Gruvbox Material (Gogh)",
  -- color_scheme = "VSCodeDark+ (Gogh)",

  colors = {
    cursor_bg = '#ffffff',
    cursor_fg = 'black',
    selection_fg = 'white',
    selection_bg = '#C2185B',
  },

  window_background_opacity = window_background_opacity,

  scrollback_lines = 1000000,
  enable_tab_bar = false,

  mouse_bindings = {
    -- 右クリックでペースト
    {
      event = { Up = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action.PasteFrom("PrimarySelection"),
    },
    -- マウス選択時に直接クリップボードにコピーする (workarround)
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("Clipboard"),
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

  -- disable_default_key_bindings = true
}

