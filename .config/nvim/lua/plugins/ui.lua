return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
