return {
  -- Snacks.nvim (dependency for claudecode.nvim)
  {
    "folke/snacks.nvim",
    config = function()
      local snacks = require("snacks")
      if not snacks.did_setup then
        snacks.setup({
          picker = {
            sources = {
              files = {
                hidden = true,
              },
            },
          },
          dashboard = {
            enabled = true,
            sections = {
              {
                section = "header",
                header = [[
░░░░░██╗███████╗██████╗░██╗██████╗░██╗░░░██╗███╗░░██╗██╗░░██╗███████╗
░░░░░██║██╔════╝██╔══██╗██║██╔══██╗██║░░░██║████╗░██║██║░██╔╝╚════██║
░░░░░██║█████╗░░██║░░██║██║██████╔╝██║░░░██║██╔██╗██║█████═╝░░░███╔═╝
██╗░░██║██╔══╝░░██║░░██║██║██╔═══╝░██║░░░██║██║╚████║██╔═██╗░██╔══╝░░
╚█████╔╝███████╗██████╔╝██║██║░░░░░╚██████╔╝██║░╚███║██║░╚██╗███████╗
░╚════╝░╚══════╝╚═════╝░╚═╝╚═╝░░░░░░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝]],
              },
              { section = "keys", gap = 1, padding = 1 },
              {
                pane = 2,
                icon = " ",
                title = "Recent Files",
                section = "recent_files",
                indent = 2,
                padding = 1,
              },
              {
                pane = 2,
                icon = " ",
                title = "Projects",
                section = "projects",
                indent = 2,
                padding = 1,
              },
              {
                pane = 2,
                icon = " ",
                title = "Git Status",
                section = "terminal",
                enabled = function()
                  return Snacks.git.get_root() ~= nil
                end,
                cmd = "git status --short --branch --renames",
                height = 5,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              },
              { section = "startup" },
            },
          },
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
            hidden = true,
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

}
