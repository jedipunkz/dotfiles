return {
  -- Snacks.nvim (dependency for claudecode.nvim)
  {
    "folke/snacks.nvim",
    config = function()
      local snacks = require("snacks")
      if not snacks.did_setup then
        snacks.setup({
          terminal = {
            enabled = true,
            win = {
              style = "terminal",
              -- DoomOne theme colors for terminal
              wo = {
                winhl = "Normal:Normal,FloatBorder:FloatBorder,FloatTitle:FloatTitle,FloatFooter:FloatFooter",
              },
            },
            env = {
              TERM = "xterm-256color",
            },
            bo = {
              filetype = "snacks_terminal",
            },
            keys = {
              q = "hide",
              term_normal = {
                "<C-\\><C-n>",
                mode = "t",
                desc = "Terminal normal mode",
              },
            },
          },
          explorer = {
            enabled = true,
          },
          gitbrowse = {
            enabled = true,
          },
          lazygit = {
            enabled = true,
            configure = true,
            win = {
              style = "lazygit",
            },
          },
        })
      end

      -- Create Snacks commands manually
      vim.api.nvim_create_user_command("SnackTerminal", function()
        require("snacks").terminal.toggle()
      end, { desc = "Toggle terminal" })

      vim.api.nvim_create_user_command("SnackTerminalOpen", function()
        require("snacks").terminal.open()
      end, { desc = "Open terminal" })
    end,
  },

  -- Claude Code for Neovim
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup()
    end,
  },
}
