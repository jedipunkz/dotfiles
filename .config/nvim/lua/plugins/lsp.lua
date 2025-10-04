return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "glepnir/lspsaga.nvim",
  },
  {
    "juliosueiras/terraform-lsp",
  },
  {
    "prabirshrestha/asyncomplete.vim",
  },
  {
    "prabirshrestha/asyncomplete-lsp.vim",
  },

  -- Formatter
  {
    "MunifTanjim/prettier.nvim",
  },
}
