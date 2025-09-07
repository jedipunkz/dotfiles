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

-- Apply colorscheme after plugins are loaded
vim.api.nvim_create_autocmd("User", {
  pattern = "PackerComplete",
  callback = function()
    vim.cmd [[
    try
      colorscheme doom-one
    catch /^Vim\%((\a\+)\)\=:E185/
      colorscheme default
      set background=dark
    endtry
    ]]
  end
})

-- Apply DoomOne terminal colors to Snacks terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      -- DoomOne color palette
      vim.api.nvim_set_hl(0, "TermCursor", { fg = "#282c34", bg = "#51afef" })
      vim.api.nvim_set_hl(0, "TermCursorNC", { fg = "#282c34", bg = "#5c6370" })
      
      -- Set terminal colors to match DoomOne theme
      vim.g.terminal_color_0 = "#282c34"   -- black
      vim.g.terminal_color_1 = "#ff6c6b"   -- red
      vim.g.terminal_color_2 = "#98be65"   -- green
      vim.g.terminal_color_3 = "#ecbe7b"   -- yellow
      vim.g.terminal_color_4 = "#51afef"   -- blue
      vim.g.terminal_color_5 = "#c678dd"   -- magenta
      vim.g.terminal_color_6 = "#46d9ff"   -- cyan
      vim.g.terminal_color_7 = "#bbc2cf"   -- white
      vim.g.terminal_color_8 = "#5c6370"   -- bright black
      vim.g.terminal_color_9 = "#ff6c6b"   -- bright red
      vim.g.terminal_color_10 = "#98be65"  -- bright green
      vim.g.terminal_color_11 = "#ecbe7b"  -- bright yellow
      vim.g.terminal_color_12 = "#51afef"  -- bright blue
      vim.g.terminal_color_13 = "#c678dd"  -- bright magenta
      vim.g.terminal_color_14 = "#46d9ff"  -- bright cyan
      vim.g.terminal_color_15 = "#dfdfdf"  -- bright white
    end
  end
})
