-- Duskfox (Nightfox) theme configuration
require("nightfox").setup({
  options = {
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled",
    transparent = false,
    terminal_colors = true,
    dim_inactive = false,
    module_default = true,
    colorblind = {
      enable = false,
      simulate_only = false,
      severity = {
        protan = 0,
        deutan = 0,
        tritan = 0,
      },
    },
    styles = {
      comments = "NONE",
      conditionals = "NONE",
      constants = "NONE",
      functions = "NONE",
      keywords = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
    },
    inverse = {
      match_paren = false,
      visual = false,
      search = false,
    },
    modules = {},
  },
  palettes = {},
  specs = {},
  groups = {},
})

-- Apply colorscheme
local function apply_colorscheme()
  vim.cmd [[
  try
    colorscheme duskfox
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
  endtry
  ]]
end

-- Try to apply colorscheme immediately if nightfox is available
local has_nightfox = pcall(require, 'nightfox')
if has_nightfox then
  apply_colorscheme()
else
  -- Also try on VimEnter as fallback
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.defer_fn(apply_colorscheme, 100)
    end
  })
end

-- Duskfox Color Palette
-- Source: https://github.com/edeneast/nightfox.nvim
local duskfox_colors = {
  -- Background & Foreground
  bg          = "#232136",  -- main background
  bg_dark     = "#1d1b2d",  -- darker background
  bg_highlight = "#2d2a45", -- highlight background
  fg          = "#e0def4",  -- main foreground
  fg_dark     = "#cdcbe0",  -- darker foreground

  -- Base Colors
  black       = "#393552",
  red         = "#eb6f92",
  green       = "#a3be8c",
  yellow      = "#f6c177",
  blue        = "#569fba",
  magenta     = "#c4a7e7",
  cyan        = "#9ccfd8",
  white       = "#e0def4",

  -- Bright Colors
  bright_black   = "#47407d",
  bright_red     = "#f083a2",
  bright_green   = "#b1d196",
  bright_yellow  = "#f9cb8c",
  bright_blue    = "#65b1cd",
  bright_magenta = "#ccb1ed",
  bright_cyan    = "#a6dae3",
  bright_white   = "#e2e0f7",

  -- Special
  orange      = "#ea9a97",
  comment     = "#6e6a86",
}

-- Apply Duskfox terminal colors
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      -- Duskfox color palette
      vim.api.nvim_set_hl(0, "TermCursor", { fg = duskfox_colors.bg, bg = duskfox_colors.blue })
      vim.api.nvim_set_hl(0, "TermCursorNC", { fg = duskfox_colors.bg, bg = duskfox_colors.comment })

      -- Set terminal colors to match Duskfox theme (16 ANSI colors)
      vim.g.terminal_color_0  = duskfox_colors.black         -- black
      vim.g.terminal_color_1  = duskfox_colors.red           -- red
      vim.g.terminal_color_2  = duskfox_colors.green         -- green
      vim.g.terminal_color_3  = duskfox_colors.yellow        -- yellow
      vim.g.terminal_color_4  = duskfox_colors.blue          -- blue
      vim.g.terminal_color_5  = duskfox_colors.magenta       -- magenta
      vim.g.terminal_color_6  = duskfox_colors.cyan          -- cyan
      vim.g.terminal_color_7  = duskfox_colors.fg_dark       -- white
      vim.g.terminal_color_8  = duskfox_colors.bright_black  -- bright black (gray)
      vim.g.terminal_color_9  = duskfox_colors.bright_red    -- bright red
      vim.g.terminal_color_10 = duskfox_colors.bright_green  -- bright green
      vim.g.terminal_color_11 = duskfox_colors.bright_yellow -- bright yellow
      vim.g.terminal_color_12 = duskfox_colors.bright_blue   -- bright blue
      vim.g.terminal_color_13 = duskfox_colors.bright_magenta-- bright magenta
      vim.g.terminal_color_14 = duskfox_colors.bright_cyan   -- bright cyan
      vim.g.terminal_color_15 = duskfox_colors.white         -- bright white
    end
  end
})
