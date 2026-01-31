return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine = require("lualine")

      -- DoomOne color palette
      local colors = {
        bg = '#282c34',
        bg_alt = '#21242b',
        fg = '#bbc2cf',
        fg_alt = '#5b6268',
        yellow = '#ecbe7b',
        cyan = '#46d9ff',
        darkblue = '#2257a0',
        green = '#98be65',
        orange = '#da8548',
        violet = '#c678dd',
        magenta = '#c678dd',
        blue = '#51afef',
        red = '#ff6c6b',
        gray = '#3f444a',
        light_gray = '#5b6268',
      }

      -- Custom DoomOne theme
      local doom_one_theme = {
        normal = {
          a = { fg = colors.fg, bg = colors.gray, gui = 'bold' },
          b = { fg = colors.fg, bg = colors.bg_alt },
          c = { fg = colors.fg, bg = colors.bg },
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

      -- Custom diff component
      local diff_component = {
        'diff',
        colored = false,
        color = { fg = '#9ece6a', bg = '#24283b' },
        symbols = { added = '+', modified = '~', removed = '-' },
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

      -- Custom diagnostics component
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

      -- Git branch component
      local branch_component = {
        'branch',
        icon = '',
        color = { fg = '#9ece6a', bg = '#24283b' },
      }

      lualine.setup {
        options = {
          icons_enabled = true,
          theme = 'tokyonight',
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
          lualine_a = { { 'mode', fmt = function(s) return s:sub(1, 1) end } },
          lualine_b = { branch_component, diff_component, diagnostics_component },
          lualine_c = {
            {
              'filename',
              file_status = true,
              newfile_status = false,
              path = 3,
              shorting_target = 40,
              symbols = {
                modified = '[+]',
                readonly = '[-]',
                unnamed = '[No Name]',
                newfile = '[New]',
              },
              color = { fg = '#7dcfff', bg = '#24283b' },
            }
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = { function() return os.date('%H:%M') end }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end,
  },

  -- Icons
  {
    "ryanoasis/vim-devicons",
  },
  {
    "nvim-tree/nvim-web-devicons",
  },

  -- Namu.nvim - Symbol navigator
  {
    "bassamsdata/namu.nvim",
    config = function()
      require("namu").setup({})
    end,
  },

  -- Chunk highlighting
  {
    "shellRaining/hlchunk.nvim",
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          style = "#00ffff",
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = ">",
          },
        },
        indent = {
          enable = false,
        },
      })
    end,
  },

  -- Modicator: カーソルライン番号の色をモードによって変更
  {
    "mawkler/modicator.nvim",
    config = function()
      require("modicator").setup({
        show_warnings = false,
        highlights = {
          defaults = {
            bold = true,
            italic = false,
          },
        },
      })
    end,
  },

  -- Scrollview: スクロールバーを表示
  {
    "dstein64/nvim-scrollview",
    config = function()
      require("scrollview").setup({
        excluded_filetypes = { "nerdtree", "neo-tree", "neo-tree-popup" },
        current_only = true,
        base = "right",
        column = 1,
        signs_on_startup = { "all" },
        diagnostics_severities = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
        winblend = 50,
        signs_overflow = "right",
        signs_max_per_row = 3,
        handle = true,
        handlers = {
          cursor = false,
          diagnostic = true,
          gitsigns = true,
          handle = true,
          search = true,
          ale = false,
          lsp = false,
        },
        marks = {
          Search = {
            text = { "-", "=" },
            priority = 1,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "Search",
          },
          Error = {
            text = { "┃", "━" },
            priority = 2,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticError",
          },
          Warn = {
            text = { "┃", "━" },
            priority = 3,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticWarn",
          },
          Info = {
            text = { "┃", "━" },
            priority = 4,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticInfo",
          },
          Hint = {
            text = { "┃", "━" },
            priority = 5,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticHint",
          },
          Misc = {
            text = { "┃", "━" },
            priority = 6,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "Normal",
          },
          GitAdd = {
            text = { "┃", "━" },
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiffAdd",
          },
          GitChange = {
            text = { "┃", "━" },
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiffChange",
          },
          GitDelete = {
            text = { "┃", "━" },
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiffDelete",
          },
        },
      })
    end,
  },
}
