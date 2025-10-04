return {
  -- Treesitter for syntax highlighting and parsing
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
          "javascript",
          "typescript",
          "python",
          "go",
          "rust",
          "json",
          "yaml",
          "markdown",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },

  -- TreeSJ for split/join syntax tree nodes
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup()
    end,
  },
}
