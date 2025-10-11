-- DoomOne theme configuration
vim.g.doom_one_cursor_coloring = false
vim.g.doom_one_terminal_colors = true
vim.g.doom_one_italic_comments = false
vim.g.doom_one_enable_treesitter = true
vim.g.doom_one_diagnostics_text_color = false
vim.g.doom_one_transparent_background = false

-- Pumblend transparency
vim.g.doom_one_pumblend_enable = false
vim.g.doom_one_pumblend_transparency = 20

-- Plugins integration
vim.g.doom_one_plugin_neorg = true
vim.g.doom_one_plugin_barbar = false
vim.g.doom_one_plugin_telescope = false
vim.g.doom_one_plugin_neogit = true
vim.g.doom_one_plugin_nvim_tree = true
vim.g.doom_one_plugin_dashboard = true
vim.g.doom_one_plugin_startify = true
vim.g.doom_one_plugin_whichkey = true
vim.g.doom_one_plugin_indent_blankline = true
vim.g.doom_one_plugin_vim_illuminate = true
vim.g.doom_one_plugin_lspsaga = false

-- Apply colorscheme
local function apply_colorscheme()
  vim.cmd [[
  try
    colorscheme doom-one
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
  endtry
  ]]
end

-- Apply colorscheme after plugins are loaded
vim.api.nvim_create_autocmd("User", {
  pattern = "PackerComplete",
  callback = apply_colorscheme
})

-- Try to apply colorscheme immediately if doom-one is available
local has_doom_one = pcall(require, 'doom-one')
if has_doom_one then
  apply_colorscheme()
else
  -- Fallback to waiting for PackerComplete
  vim.api.nvim_create_autocmd("User", {
    pattern = "PackerComplete",
    callback = apply_colorscheme
  })

  -- Also try on VimEnter as additional fallback
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.defer_fn(apply_colorscheme, 100)
    end
  })
end

-- Doom One Official Color Palette
-- Source: https://github.com/doomemacs/themes/blob/master/themes/doom-one-theme.el
local doom_one_colors = {
  -- Background & Foreground
  bg          = "#282c34",  -- main background
  bg_alt      = "#21242b",  -- alternate background
  fg          = "#bbc2cf",  -- main foreground
  fg_alt      = "#5B6268",  -- alternate foreground

  -- Base Colors (Grayscale)
  base0       = "#1B2229",  -- darkest
  base1       = "#1c1f24",
  base2       = "#202328",
  base3       = "#23272e",
  base4       = "#3f444a",
  base5       = "#5B6268",
  base6       = "#73797e",
  base7       = "#9ca0a4",
  base8       = "#DFDFDF",  -- lightest

  -- Primary Theme Colors
  red         = "#ff6c6b",
  orange      = "#da8548",
  green       = "#98be65",
  teal        = "#4db5bd",
  yellow      = "#ECBE7B",
  blue        = "#51afef",
  dark_blue   = "#2257A0",
  magenta     = "#c678dd",
  violet      = "#a9a1e1",
  cyan        = "#46D9FF",
  dark_cyan   = "#5699AF",

  -- Special
  black       = "#1B2229",
  white       = "#DFDFDF",
  grey        = "#3B3F46",
  dark_grey   = "#23272e",
}

-- Apply DoomOne terminal colors to Snacks terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      -- DoomOne color palette
      vim.api.nvim_set_hl(0, "TermCursor", { fg = doom_one_colors.bg, bg = doom_one_colors.blue })
      vim.api.nvim_set_hl(0, "TermCursorNC", { fg = doom_one_colors.bg, bg = doom_one_colors.base5 })

      -- Set terminal colors to match DoomOne theme (16 ANSI colors)
      vim.g.terminal_color_0  = doom_one_colors.black       -- black
      vim.g.terminal_color_1  = doom_one_colors.red         -- red
      vim.g.terminal_color_2  = doom_one_colors.green       -- green
      vim.g.terminal_color_3  = doom_one_colors.yellow      -- yellow
      vim.g.terminal_color_4  = doom_one_colors.blue        -- blue
      vim.g.terminal_color_5  = doom_one_colors.magenta     -- magenta
      vim.g.terminal_color_6  = doom_one_colors.cyan        -- cyan
      vim.g.terminal_color_7  = doom_one_colors.fg          -- white
      vim.g.terminal_color_8  = doom_one_colors.base5       -- bright black (gray)
      vim.g.terminal_color_9  = doom_one_colors.red         -- bright red
      vim.g.terminal_color_10 = doom_one_colors.green       -- bright green
      vim.g.terminal_color_11 = doom_one_colors.yellow      -- bright yellow
      vim.g.terminal_color_12 = doom_one_colors.blue        -- bright blue
      vim.g.terminal_color_13 = doom_one_colors.magenta     -- bright magenta
      vim.g.terminal_color_14 = doom_one_colors.cyan        -- bright cyan
      vim.g.terminal_color_15 = doom_one_colors.white       -- bright white
    end
  end
})
