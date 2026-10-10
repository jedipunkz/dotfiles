local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

local is_linux = wezterm.target_triple:find('linux') ~= nil
local is_mac = wezterm.target_triple:find('darwin') ~= nil

-- IME / キーボード
config.use_ime = true
config.macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL'
-- herdr 0.9.0 が WezTerm の kitty CSI-u 報告を取りこぼし Enter/BS/Ctrl 系が
-- 死ぬため無効化 (herdrdev/herdr#3589)。修正リリース後に true へ戻す
config.enable_kitty_keyboard = false
-- config.disable_default_key_bindings = true

-- フォント
config.font = wezterm.font_with_fallback {
  -- 'JetBrains Mono',
  'Consolas',
  'Hiragino Sans',
  'Monaco',
  'FuraMono Nerd Font Mono',
}
config.font_size = 14
if is_linux then
  config.font_size = 12
elseif is_mac then
  config.font_size = wezterm.hostname() == 'bob-san.local' and 15.4 or 14.2
end

-- ウィンドウ
config.window_decorations = 'RESIZE'
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_background_opacity = is_linux and 0.8 or 1.0
config.enable_tab_bar = false
config.scrollback_lines = 1000000

-- 配色
-- config.color_scheme = 'Dracula (Gogh)'
-- config.color_scheme = 'Dracula (base16)'
-- config.color_scheme = 'Dracula (Official)'
-- config.color_scheme = 'Catppuccin Macchiato'
config.color_scheme = 'Tokyo Night'
-- config.color_scheme = 'Sakura'
-- config.color_scheme = 'Solarized Dark Higher Contrast'
-- config.color_scheme = 'terafox'
-- config.color_scheme = 'Gruvbox Dark (Gogh)'
-- config.color_scheme = 'GruvboxDark'
-- config.color_scheme = 'Gruvbox dark, hard (base16)'
-- config.color_scheme = 'GruvboxDarkHard'
-- config.color_scheme = 'Gruvbox Material (Gogh)'
-- config.color_scheme = 'VSCodeDark+ (Gogh)'
config.colors = {
  cursor_bg = '#ffffff',
  cursor_fg = 'black',
  selection_fg = 'white',
  selection_bg = '#C2185B',
}

-- マウス
config.mouse_bindings = {
  -- 右クリックでペースト
  {
    event = { Up = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'PrimarySelection',
  },
  -- マウス選択時に直接クリップボードにコピーする (workaround)
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelectionOrOpenLinkAtMouseCursor 'Clipboard',
  },
  -- Ctrl + ホイールでフォントサイズ変更
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'CTRL',
    action = act.IncreaseFontSize,
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'CTRL',
    action = act.DecreaseFontSize,
  },
}

return config
