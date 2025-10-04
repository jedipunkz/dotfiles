return {
  -- GitSigns for git integration
  {
    "lewis6991/gitsigns.nvim",
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

  -- Git blame
  {
    "f-person/git-blame.nvim",
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
