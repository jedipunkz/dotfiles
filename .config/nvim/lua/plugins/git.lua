return {
  -- GitSigns for git integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        current_line_blame = false,
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
      })
    end,
  },

  -- fuzz.nvim for git fuzzy finder
  {
    "jedipunkz/fuzz.nvim",
    event = "VeryLazy",
    config = function()
      require("fuzz").setup({
        keymap = "<C-g>",
        pull_keymap = "<C-r>",
        push_keymap = "<C-y>",
        featch_keymap = "<C-'>",
      })
    end,
  },

  -- Git blame
  {
    "f-person/git-blame.nvim",
    cmd = { "GitBlameToggle", "GitBlameCopyCommitURL", "GitBlameEnable", "GitBlameDisable" },
    config = function()
      require("gitblame").setup({
        enabled = true,
        message_template = " <summary> • <date> • <author>",
        date_format = "%m/%d/%y",
        virtual_text_column = 1,
      })
    end,
  },
}
