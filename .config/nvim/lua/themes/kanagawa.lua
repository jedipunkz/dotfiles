-- Kanagawa theme configuration
require("kanagawa").setup({
  compile = false,
  undercurl = true,
  commentStyle = { italic = false },
  functionStyle = {},
  keywordStyle = { italic = false },
  statementStyle = { bold = true },
  typeStyle = {},
  transparent = false,
  dimInactive = false,
  terminalColors = true,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none"
        }
      }
    }
  },
  theme = "wave",
  background = {
    dark = "wave",
    light = "lotus"
  },
})

-- Apply colorscheme
local function apply_colorscheme()
  vim.cmd [[
  try
    colorscheme kanagawa
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
  endtry
  ]]
end

-- Try to apply colorscheme immediately if kanagawa is available
local has_kanagawa = pcall(require, 'kanagawa')
if has_kanagawa then
  apply_colorscheme()
else
  -- Also try on VimEnter as fallback
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.defer_fn(apply_colorscheme, 100)
    end
  })
end

-- Kanagawa Color Palette (Wave theme)
-- Source: https://github.com/rebelot/kanagawa.nvim
local kanagawa_colors = {
  -- Background & Foreground
  bg          = "#1f1f28",  -- main background
  bg_dark     = "#16161d",  -- darker background
  bg_highlight = "#2d4f67", -- highlight background
  fg          = "#dcd7ba",  -- main foreground
  fg_dark     = "#c8c093",  -- darker foreground

  -- Base Colors
  black       = "#090618",
  red         = "#c34043",
  green       = "#76946a",
  yellow      = "#c0a36e",
  blue        = "#7e9cd8",
  magenta     = "#957fb8",
  cyan        = "#6a9589",
  white       = "#c8c093",

  -- Bright Colors
  bright_black   = "#727169",
  bright_red     = "#e82424",
  bright_green   = "#98bb6c",
  bright_yellow  = "#e6c384",
  bright_blue    = "#7fb4ca",
  bright_magenta = "#938aa9",
  bright_cyan    = "#7aa89f",
  bright_white   = "#dcd7ba",

  -- Special
  orange      = "#ffa066",
  comment     = "#727169",
}

-- Apply Kanagawa terminal colors
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      -- Kanagawa color palette
      vim.api.nvim_set_hl(0, "TermCursor", { fg = kanagawa_colors.bg, bg = kanagawa_colors.blue })
      vim.api.nvim_set_hl(0, "TermCursorNC", { fg = kanagawa_colors.bg, bg = kanagawa_colors.comment })

      -- Set terminal colors to match Kanagawa theme (16 ANSI colors)
      vim.g.terminal_color_0  = kanagawa_colors.black         -- black
      vim.g.terminal_color_1  = kanagawa_colors.red           -- red
      vim.g.terminal_color_2  = kanagawa_colors.green         -- green
      vim.g.terminal_color_3  = kanagawa_colors.yellow        -- yellow
      vim.g.terminal_color_4  = kanagawa_colors.blue          -- blue
      vim.g.terminal_color_5  = kanagawa_colors.magenta       -- magenta
      vim.g.terminal_color_6  = kanagawa_colors.cyan          -- cyan
      vim.g.terminal_color_7  = kanagawa_colors.fg_dark       -- white
      vim.g.terminal_color_8  = kanagawa_colors.bright_black  -- bright black (gray)
      vim.g.terminal_color_9  = kanagawa_colors.bright_red    -- bright red
      vim.g.terminal_color_10 = kanagawa_colors.bright_green  -- bright green
      vim.g.terminal_color_11 = kanagawa_colors.bright_yellow -- bright yellow
      vim.g.terminal_color_12 = kanagawa_colors.bright_blue   -- bright blue
      vim.g.terminal_color_13 = kanagawa_colors.bright_magenta-- bright magenta
      vim.g.terminal_color_14 = kanagawa_colors.bright_cyan   -- bright cyan
      vim.g.terminal_color_15 = kanagawa_colors.white         -- bright white
    end
  end
})
