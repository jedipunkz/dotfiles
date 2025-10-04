return {
  -- Project management
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
        silent_chdir = true,
        show_hidden = false,
      })
    end,
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      -- doom テーマを使用して project.nvim と統合
      local dashboard = require("dashboard")

      -- project.nvim からプロジェクトを取得
      local function get_projects()
        local ok, project_nvim = pcall(require, "project_nvim")
        if not ok then
          return {}
        end

        local recent_projects = project_nvim.get_recent_projects()
        local shortcuts = {}

        for i, project in ipairs(recent_projects) do
          if i > 12 then
            break
          end -- 最大12個まで
          local shortcut_key
          if i <= 9 then
            shortcut_key = tostring(i)
          elseif i == 10 then
            shortcut_key = "0"
          elseif i == 11 then
            shortcut_key = "a"
          elseif i == 12 then
            shortcut_key = "b"
          end
          table.insert(shortcuts, {
            desc = " " .. vim.fn.fnamemodify(project, ":t"),
            group = "Number",
            action = "cd " .. project .. " | edit .",
            key = shortcut_key,
          })
        end

        return shortcuts
      end

      dashboard.setup({
        theme = "doom",
        config = {
          header = {
            "",
            "░░░░░██╗███████╗██████╗░██╗██████╗░██╗░░░██╗███╗░░██╗██╗░░██╗███████╗",
            "░░░░░██║██╔════╝██╔══██╗██║██╔══██╗██║░░░██║████╗░██║██║░██╔╝╚════██║",
            "░░░░░██║█████╗░░██║░░██║██║██████╔╝██║░░░██║██╔██╗██║█████═╝░░░███╔═╝",
            "██╗░░██║██╔══╝░░██║░░██║██║██╔═══╝░██║░░░██║██║╚████║██╔═██╗░██╔══╝░░",
            "╚█████╔╝███████╗██████╔╝██║██║░░░░░╚██████╔╝██║░╚███║██║░╚██╗███████╗",
            "░╚════╝░╚══════╝╚═════╝░╚═╝╚═╝░░░░░░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝",
            "",
          },
          center = vim.list_extend({
            {
              desc = "󰊳 Update Plugins",
              group = "@property",
              action = "Lazy sync",
              key = "u",
            },
            {
              desc = " Find File",
              group = "Label",
              action = 'lua vim.cmd("cd " .. vim.fn.expand("~")) vim.cmd("edit .")',
              key = "f",
            },
          }, get_projects()),
          footer = {},
        },
      })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons", "ahmedkhalf/project.nvim" },
  },
}
