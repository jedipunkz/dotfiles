return {
  -- Editor utilities
  {
    "vim-scripts/tComment",
    event = "VeryLazy",
  },
  {
    "nathanaelkane/vim-indent-guides",
    event = "VeryLazy",
  },
  {
    "SirVer/ultisnips",
    event = "InsertEnter",
  },
  {
    "honza/vim-snippets",
    event = "InsertEnter",
  },
  {
    "sebdah/vim-delve",
    ft = "go",
  },
  {
    "vim-test/vim-test",
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
  },
  {
    "tpope/vim-dispatch",
    event = "VeryLazy",
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
  },
}
