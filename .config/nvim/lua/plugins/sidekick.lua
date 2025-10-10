return {
  {
    "folke/sidekick.nvim",
    keys = {
      -- Agent selection
      { "<leader>aa", function() require("sidekick.cli").toggle() end, desc = "Sidekick: Toggle CLI" },
      { "<leader>as", function() require("sidekick.cli").select() end, desc = "Sidekick: Select CLI" },
      { "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, desc = "Sidekick: Send This" },
      { "<leader>ap", function() require("sidekick.cli").prompt() end, desc = "Sidekick: Send Prompt" },

      -- Claude specific keybindings
      { "<leader>fc", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Sidekick: Claude" },
      { "<leader>fr", function() require("sidekick.cli").toggle({ name = "claude-resume", focus = true }) end, desc = "Sidekick: Claude Resume" },
      { "<leader>fb", function() require("sidekick.cli").send({ name = "claude", msg = "{file}" }) end, desc = "Sidekick: Send Buffer to Claude" },
      { "<leader>fs", function() require("sidekick.cli").send({ name = "claude", msg = "{selection}" }) end, mode = "v", desc = "Sidekick: Send Selection to Claude" },

      -- Focus switching
      { "<C-w>p", function() require("sidekick.cli").focus() end, mode = { "n", "t" }, desc = "Sidekick: Switch Focus" },
    },
    opts = {
      mux = {
        backend = "zellij",
        enabled = true,
      },
      cli = {
        tools = {
          ["claude-resume"] = {
            cmd = { "claude", "--resume" },
            url = "https://github.com/anthropics/claude-code",
          },
        },
      },
    },
  },
}
