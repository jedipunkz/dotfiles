local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

-- DoomOne color palette (exact colors from doom-one.nvim)
local colors = {
  bg = '#282c34',      -- Background
  bg_alt = '#21242b',  -- Alternative background
  fg = '#bbc2cf',      -- Foreground
  fg_alt = '#5b6268',  -- Alternative foreground
  yellow = '#ecbe7b',
  cyan = '#46d9ff',
  darkblue = '#2257a0',
  green = '#98be65',
  orange = '#da8548',
  violet = '#c678dd',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ff6c6b',
  gray = '#3f444a',    -- Darker gray for better contrast
  light_gray = '#5b6268',
}

-- Custom DoomOne theme for lualine
local doom_one_theme = {
  normal = {
    a = { fg = colors.fg, bg = colors.gray, gui = 'bold' },  -- Changed to gray background with light text
    b = { fg = colors.fg, bg = colors.bg_alt },
    c = { fg = colors.fg, bg = colors.bg },  -- Changed to brighter text
  },
  insert = {
    a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.bg_alt },
    c = { fg = colors.fg, bg = colors.bg },
  },
  visual = {
    a = { fg = colors.bg, bg = colors.violet, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.bg_alt },
    c = { fg = colors.fg, bg = colors.bg },
  },
  replace = {
    a = { fg = colors.bg, bg = colors.red, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.bg_alt },
    c = { fg = colors.fg, bg = colors.bg },
  },
  command = {
    a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.bg_alt },
    c = { fg = colors.fg, bg = colors.bg },
  },
  inactive = {
    a = { fg = colors.fg_alt, bg = colors.bg_alt },
    b = { fg = colors.fg_alt, bg = colors.bg },
    c = { fg = colors.gray, bg = colors.bg },
  },
}

-- Custom diff component with colors and line counts
local diff_component = {
  'diff',
  colored = true,
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.yellow },
    removed = { fg = colors.red },
  },
  symbols = { added = '+', modified = '~', removed = '-' },  -- Simple text symbols
  source = function()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed
      }
    end
  end,
}

-- Custom diagnostics component with colors
local diagnostics_component = {
  'diagnostics',
  sources = { 'nvim_diagnostic', 'nvim_lsp' },
  sections = { 'error', 'warn', 'info', 'hint' },
  diagnostics_color = {
    error = { fg = colors.red },
    warn = { fg = colors.yellow },
    info = { fg = colors.blue },
    hint = { fg = colors.cyan },
  },
  symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
  colored = true,
  update_in_insert = false,
  always_visible = false,
}

-- Git branch with icon
local branch_component = {
  'branch',
  icon = '[git]',  -- Text label for git
  color = { fg = colors.green },
}

lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'dracula',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { branch_component, diff_component, diagnostics_component },
    lualine_c = {
      {
        'filename',
        file_status = true,
        newfile_status = false,
        path = 1,
        shorting_target = 40,
        symbols = {
          modified = '[+]',
          readonly = '[-]',
          unnamed = '[No Name]',
          newfile = '[New]',
        }
      }
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
