return {
  -- Snacks.nvim (dependency for claudecode.nvim)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
          },
          explorer = {
            hidden = true,
            ignored = true,
            win = {
              list = {
                keys = {
                  ["s"] = { "edit_split", mode = { "n" } },
                  ["v"] = { "edit_vsplit", mode = { "n" } },
                },
              },
            },
          },
        },
      },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
░██████╗░██╗░░██╗░█████╗░░██████╗████████╗
██╔════╝░██║░░██║██╔══██╗██╔════╝╚══██╔══╝
██║░░██╗░███████║██║░░██║╚█████╗░░░░██║░░░
██║░░╚██╗██╔══██║██║░░██║░╚═══██╗░░░██║░░░
╚██████╔╝██║░░██║╚█████╔╝██████╔╝░░░██║░░░
░╚═════╝░╚═╝░░╚═╝░╚════╝░╚═════╝░░░░╚═╝░░░]],
        },
        sections = {
          { section = "header" },
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
          -- NOTE: Git Status section disabled for startup performance
          -- Executes external command which slows down dashboard loading
          -- {
          --   pane = 2,
          --   icon = " ",
          --   title = "Git Status",
          --   section = "terminal",
          --   enabled = function()
          --     return Snacks.git.get_root() ~= nil
          --   end,
          --   cmd = "git status --short --branch --renames",
          --   height = 5,
          --   padding = 1,
          --   ttl = 5 * 60,
          --   indent = 3,
          -- },
          { section = "startup" },
        },
      },
      terminal = {
        enabled = false,
      },
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
      gitbrowse = {
        enabled = true,
      },
      lazygit = {
        enabled = true,
        configure = true,
        env = {
          LANG = "en_US.UTF-8",
          LC_ALL = "en_US.UTF-8",
        },
        win = {
          style = "lazygit",
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup keymaps after Snacks is fully loaded
          vim.keymap.set("n", "<leader>sf", function() Snacks.picker.smart() end, { desc = "Smart file search" })
          vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep search" })
          vim.keymap.set("n", "<leader>sb", function() Snacks.gitbrowse() end, { desc = "Git browse" })
          vim.keymap.set("n", "<leader>sl", function() Snacks.lazygit() end, { desc = "Lazygit" })
          vim.keymap.set("n", "<C-e>", function() Snacks.explorer() end, { desc = "File explorer" })
        end,
      })
    end,
  },

}
