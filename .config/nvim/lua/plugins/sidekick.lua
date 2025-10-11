return {
  {
    "folke/sidekick.nvim",
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>ar",
        function() require("sidekick.cli").toggle({ name = "claude-resume", focus = true }) end,
        desc = "Sidekick: Claude Resume",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },

      -- Claude specific keybindings
      { "<leader>ff", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Sidekick: Claude" },
      { "<leader>fr", function() require("sidekick.cli").toggle({ name = "claude-resume", focus = true }) end, desc = "Sidekick: Claude Resume" },
      { "<leader>ft", function() require("sidekick.cli").send({ name = "claude", msg = "{this}" }) end, desc = "Sidekick: Send This to Claude" },
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
        win = {
          keys = {
            nav_left = false,   -- Disable C-h navigation (keep C-h for backspace)
            nav_right = false,  -- Disable C-l navigation
            nav_down = false,   -- Disable C-j navigation
            nav_up = false,     -- Disable C-k navigation
          },
        },
      },
    },
  },
}
