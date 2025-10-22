-- TokyoNight theme configuration
require("tokyonight").setup({
  style = "night",
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = false },
    keywords = { italic = false },
    functions = {},
    variables = {},
    sidebars = "dark",
    floats = "dark",
  },
  on_highlights = function(hl, c)
    -- Customize Visual selection colors
    hl.Visual = {
      bg = "#9d7cd8",  -- purple background
      fg = "#ffffff",  -- white text
    }
  end,
})

-- Apply colorscheme
local function apply_colorscheme()
  vim.cmd [[
  try
    colorscheme tokyonight
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
  endtry
  ]]
end

-- Try to apply colorscheme immediately if tokyonight is available
local has_tokyonight = pcall(require, 'tokyonight')
if has_tokyonight then
  apply_colorscheme()
else
  -- Also try on VimEnter as fallback
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.defer_fn(apply_colorscheme, 100)
    end
  })
end

-- Tokyo Night Color Palette
-- Source: https://github.com/folke/tokyonight.nvim
local tokyonight_colors = {
  -- Background & Foreground
  bg          = "#1a1b26",  -- main background
  bg_dark     = "#16161e",  -- darker background
  bg_highlight = "#292e42", -- highlight background
  fg          = "#c0caf5",  -- main foreground
  fg_dark     = "#a9b1d6",  -- darker foreground

  -- Base Colors
  black       = "#15161e",
  red         = "#f7768e",
  green       = "#9ece6a",
  yellow      = "#e0af68",
  blue        = "#7aa2f7",
  magenta     = "#bb9af7",
  cyan        = "#7dcfff",
  white       = "#c0caf5",

  -- Bright Colors
  bright_black   = "#414868",
  bright_red     = "#ff899d",
  bright_green   = "#9fe044",
  bright_yellow  = "#faba4a",
  bright_blue    = "#8db0ff",
  bright_magenta = "#c7a9ff",
  bright_cyan    = "#a4daff",
  bright_white   = "#c0caf5",

  -- Special
  orange      = "#ff9e64",
  comment     = "#565f89",
}

-- Apply TokyoNight terminal colors
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      -- TokyoNight color palette
      vim.api.nvim_set_hl(0, "TermCursor", { fg = tokyonight_colors.bg, bg = tokyonight_colors.blue })
      vim.api.nvim_set_hl(0, "TermCursorNC", { fg = tokyonight_colors.bg, bg = tokyonight_colors.comment })

      -- Set terminal colors to match TokyoNight theme (16 ANSI colors)
      vim.g.terminal_color_0  = tokyonight_colors.black         -- black
      vim.g.terminal_color_1  = tokyonight_colors.red           -- red
      vim.g.terminal_color_2  = tokyonight_colors.green         -- green
      vim.g.terminal_color_3  = tokyonight_colors.yellow        -- yellow
      vim.g.terminal_color_4  = tokyonight_colors.blue          -- blue
      vim.g.terminal_color_5  = tokyonight_colors.magenta       -- magenta
      vim.g.terminal_color_6  = tokyonight_colors.cyan          -- cyan
      vim.g.terminal_color_7  = tokyonight_colors.fg_dark       -- white
      vim.g.terminal_color_8  = tokyonight_colors.bright_black  -- bright black (gray)
      vim.g.terminal_color_9  = tokyonight_colors.bright_red    -- bright red
      vim.g.terminal_color_10 = tokyonight_colors.bright_green  -- bright green
      vim.g.terminal_color_11 = tokyonight_colors.bright_yellow -- bright yellow
      vim.g.terminal_color_12 = tokyonight_colors.bright_blue   -- bright blue
      vim.g.terminal_color_13 = tokyonight_colors.bright_magenta-- bright magenta
      vim.g.terminal_color_14 = tokyonight_colors.bright_cyan   -- bright cyan
      vim.g.terminal_color_15 = tokyonight_colors.white         -- bright white
    end
  end
})
